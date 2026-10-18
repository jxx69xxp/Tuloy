import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart' show RoomArt;
import '../../core/adaptive.dart' show isWide;
import '../../core/format.dart';
import '../../core/http.dart';
import '../../core/ui.dart';
import '../../l10n/app_localizations.dart';
import '../../core/config.dart' show hotelId;
import '../admin/admin_catalog_screens.dart' show MenuAdminScreen, trOf;
import '../booking/domain/booking.dart';
import '../services/services_screens.dart' show ServiceRequestScreen;
import '../auth/presentation/auth_controller.dart' show tokenStoreProvider;

// ───────────── room board ─────────────

/// Every room's state today, grouped by room type (photo, name, how many are available), colored by status.
/// Tapping a room with a guest opens the booking.
class RoomBoard extends ConsumerStatefulWidget {
  const RoomBoard({super.key, required this.base, this.full = false});
  final String base;

  /// The Rooms page: adds search (number, type, guest) and a room-type filter.
  final bool full;

  /// Room states in the order the legend lists them.
  static const states = ['free', 'arriving', 'occupied', 'departing', 'reserved', 'blocked'];

  static (Color, Color) colors(ColorScheme c, String status) => switch (status) {
    'free' => (c.primaryContainer, c.onPrimaryContainer),
    'arriving' => (c.tertiaryContainer, c.onTertiaryContainer),
    'departing' => (c.secondaryContainer, c.onSecondaryContainer),
    'blocked' => (c.errorContainer, c.onErrorContainer),
    _ => (c.surfaceContainerHigh, c.onSurface), // occupied, reserved: taken, nothing to do
  };

  static IconData icon(String status) => switch (status) {
    'free' => Icons.check_circle_outline,
    'arriving' => Icons.login,
    'occupied' => Icons.person_outline,
    'departing' => Icons.logout,
    'blocked' => Icons.build_outlined,
    _ => Icons.event_outlined,
  };

  static String label(AppLocalizations l, String status) => switch (status) {
    'free' => l.roomAvailable,
    'occupied' => l.roomOccupied,
    'arriving' => l.roomArriving,
    'departing' => l.roomDeparting,
    'blocked' => l.roomBlocked,
    _ => l.roomReserved,
  };

  @override
  ConsumerState<RoomBoard> createState() => _RoomBoardState();
}

class _RoomBoardState extends ConsumerState<RoomBoard> {
  bool _availableOnly = false;
  String _q = '';
  String? _type;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final t = Theme.of(context);
    const path = '/staff/board';
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
        child: AsyncBody(
          value: ref.watch(getProvider(path)),
          onRetry: () => ref.invalidate(getProvider(path)),
          builder: (data) {
            final d = (data as Map).cast<String, dynamic>();
            final rooms = jsonList(d['rooms']);
            // A departing room is free again for tonight, so it counts as available.
            bool available(J r) => r['status'] == 'free' || r['status'] == 'departing';
            final q = _q.toLowerCase();
            bool shown(J r) =>
                (!_availableOnly || available(r)) &&
                (q.isEmpty ||
                    [r['number'], r['roomType'], r['guestName']].any((v) => '${v ?? ''}'.toLowerCase().contains(q)));
            final types = [
              for (final type in jsonList(d['types']))
                if (_type == null || _type == type['roomTypeId']) type,
            ];
            final availableChip = FilterChip(
              label: Text(l.availableOnly),
              selected: _availableOnly,
              onSelected: (v) => setState(() => _availableOnly = v),
            );
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: Text(l.roomBoard, style: t.textTheme.titleLarge)),
                    if (!widget.full) availableChip,
                  ],
                ),
                if (widget.full) ...[
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      SizedBox(
                        width: 280,
                        child: TextField(
                          decoration: InputDecoration(prefixIcon: const Icon(Icons.search), hintText: l.search),
                          onChanged: (v) => setState(() => _q = v.trim()),
                        ),
                      ),
                      DropdownButton<String?>(
                        value: _type,
                        underline: const SizedBox(),
                        items: [
                          DropdownMenuItem(value: null, child: Text(l.allRoomTypes)),
                          for (final x in jsonList(d['types']))
                            DropdownMenuItem(value: '${x['roomTypeId']}', child: Text('${x['roomType']}')),
                        ],
                        onChanged: (v) => setState(() => _type = v),
                      ),
                      availableChip,
                    ],
                  ),
                ],
                const SizedBox(height: 4),
                Wrap(
                  spacing: 16,
                  runSpacing: 4,
                  children: [
                    for (final s in RoomBoard.states)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 14,
                            height: 14,
                            decoration: BoxDecoration(
                              color: RoomBoard.colors(t.colorScheme, s).$1,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: t.colorScheme.outlineVariant),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(RoomBoard.label(l, s), style: t.textTheme.bodySmall),
                        ],
                      ),
                  ],
                ),
                for (final type in types)
                  if (rooms.any((r) => r['roomTypeId'] == type['roomTypeId'] && shown(r))) ...[
                    const SizedBox(height: 20),
                    _TypeHeader(type),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final r in rooms)
                          if (r['roomTypeId'] == type['roomTypeId'] && shown(r)) _RoomTile(r, widget.base),
                      ],
                    ),
                  ],
                if (!rooms.any(shown)) EmptyState(l.nothingHere, icon: Icons.bed_outlined),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// Room type photo, name and "X of Y free" above its rooms.
class _TypeHeader extends StatelessWidget {
  const _TypeHeader(this.type);
  final J type;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final t = Theme.of(context);
    final free = (type['free'] as num).toInt();
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            width: 64,
            child: RoomArt(name: '${type['roomType']}', height: 44, imageUrl: type['photoUrl'] as String?),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text('${type['roomType']}', style: t.textTheme.titleMedium)),
        Text(
          l.freeOf('$free', '${type['total']}'),
          style: t.textTheme.labelLarge?.copyWith(color: free > 0 ? t.colorScheme.primary : t.colorScheme.error),
        ),
      ],
    );
  }
}

class _RoomTile extends StatelessWidget {
  const _RoomTile(this.r, this.base);
  final J r;
  final String base;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final t = Theme.of(context);
    final status = '${r['status']}';
    final (bg, fg) = RoomBoard.colors(t.colorScheme, status);
    final id = r['reservationId'] as String?;
    final guest = r['guestName'] as String?;
    return Semantics(
      button: id != null,
      label: '${r['number']}, ${r['roomType']}, ${RoomBoard.label(l, status)}${guest == null ? '' : ', $guest'}',
      excludeSemantics: true,
      child: Tooltip(
        message: [r['roomType'], guest].whereType<String>().join(' · '),
        child: Material(
          color: bg,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: t.colorScheme.outlineVariant),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            // A guest's room opens their booking; a room free tonight opens Book.
            onTap: id != null && status != 'departing'
                ? () => context.go('$base/reservations/$id')
                : status == 'free' || status == 'departing'
                ? () async {
                    final newId = await showDialog<String>(
                      context: context,
                      builder: (_) => DeskBookDialog(room: r),
                    );
                    if (newId != null && context.mounted) context.go('$base/reservations/$newId');
                  }
                : null,
            child: SizedBox(
              width: 132,
              height: 76,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text('${r['number']}', style: t.textTheme.titleLarge?.copyWith(color: fg, height: 1)),
                        const Spacer(),
                        Icon(RoomBoard.icon(status), size: 18, color: fg),
                      ],
                    ),
                    Text(
                      guest ?? RoomBoard.label(l, status),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: t.textTheme.bodySmall?.copyWith(color: fg, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ───────────── rooms table ─────────────

/// The room board on its own page, with search and a room-type filter.
class RoomsScreen extends StatelessWidget {
  const RoomsScreen({super.key, required this.base});
  final String base;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(AppLocalizations.of(context).rooms)),
    body: SingleChildScrollView(
      padding: EdgeInsets.all(isWide(context) ? 0 : 12),
      child: RoomBoard(base: base, full: true),
    ),
  );
}

// ───────────── arrivals / departures ─────────────

/// Booked guests still to arrive (today first, then the coming days), or today's departures.
class StayListCard extends ConsumerWidget {
  const StayListCard({super.key, required this.base, required this.departures});
  final String base;
  final bool departures;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final t = Theme.of(context);
    final path = '/staff/reservations?view=${departures ? 'departures' : 'upcoming'}';
    final rows = [
      for (final r in jsonList(ref.watch(getProvider(path)).valueOrNull ?? const []))
        if (departures || r['status'] != 'CHECKED_IN') r,
    ];
    return Card(
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            title: Text(departures ? l.todaysDepartures : l.arrivals, style: t.textTheme.titleMedium),
            trailing: TextButton(onPressed: () => context.go('$base/reservations'), child: Text(l.reservations)),
          ),
          if (rows.isEmpty)
            ListTile(
              title: Text(l.nothingHere, style: TextStyle(color: t.colorScheme.onSurfaceVariant)),
            ),
          for (final r in rows.take(8))
            ListTile(
              dense: true,
              title: Text('${r['guestName']}'),
              subtitle: Text(
                [
                  r['room'] == null ? null : l.roomNumber('${r['room']}'),
                  '${r['roomType']}',
                ].whereType<String>().join(' · '),
              ),
              trailing: departures
                  ? (num2(r['balance']) > 0 ? Text(money(num2(r['balance']), '${r['currency']}')) : null)
                  : Text(date(context, DateTime.parse('${r['checkIn']}'))),
              onTap: () => context.go('$base/reservations/${r['id']}'),
            ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

// ───────────── guest list / team ─────────────

class GuestListScreen extends StatefulWidget {
  const GuestListScreen({super.key, required this.base});
  final String base;
  @override
  State<GuestListScreen> createState() => _GuestListState();
}

class _GuestListState extends State<GuestListScreen> {
  String _q = '';

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final path = '/staff/guests${_q.isEmpty ? '' : '?q=${Uri.encodeQueryComponent(_q)}'}';
    String text(Object? v) => '${v ?? ''}'.toLowerCase();
    String last(J g) {
      final s = g['last'] as Map?;
      return s == null ? '' : dateRange(context, DateTime.parse('${s['checkIn']}'), DateTime.parse('${s['checkOut']}'));
    }

    // Opens the guest's bookings: the reservations queue searched by their name.
    void open(J g) => context.go('${widget.base}/reservations?q=${Uri.encodeQueryComponent('${g['fullName']}')}');
    return Scaffold(
      appBar: AppBar(title: Text(l.guestList)),
      body: JsonList(
        path: path,
        header: isWide(context)
            ? null
            : Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: TextField(
                  decoration: InputDecoration(prefixIcon: const Icon(Icons.search), hintText: l.searchGuest),
                  onSubmitted: (v) => setState(() => _q = v.trim()),
                ),
              ),
        table: JsonTable(
          columns: [l.name, l.email, l.phone, l.stays, l.lastStay],
          cells: (context, g) => [
            '${g['fullName']}',
            '${g['email'] ?? ''}',
            '${g['phone'] ?? ''}',
            '${g['stays']}',
            last(g),
          ],
          sortKeys: [
            (g) => text(g['fullName']),
            (g) => text(g['email']),
            (g) => text(g['phone']),
            (g) => g['stays'] as num,
            (g) => text((g['last'] as Map?)?['checkIn']),
          ],
          onTap: open,
          onSearch: (q) => setState(() => _q = q),
          searchHint: l.searchGuest,
        ),
        item: (context, g) => ListTile(
          title: Text('${g['fullName']}'),
          subtitle: Text([g['email'], g['phone'], last(g)].whereType<String>().where((s) => s.isNotEmpty).join(' · ')),
          trailing: Text('${g['stays']}'),
          onTap: () => open(g),
        ),
      ),
    );
  }
}

class TeamScreen extends StatelessWidget {
  const TeamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    String role(J m) => switch (m['role']) {
      'ADMIN' => l.roleAdmin,
      'RESTAURANT' => l.roleRestaurant,
      _ => l.staff,
    };
    // "On leave" today, or the dates of approved leave still to come; empty when working.
    String leave(J m) {
      final x = m['leave'] as Map?;
      if (x == null) return '';
      if (x['today'] == true) return l.onLeaveToday;
      return l.leaveUpcoming(dateRange(context, DateTime.parse('${x['from']}'), DateTime.parse('${x['to']}')));
    }

    Widget? leaveChip(J m) {
      final text = leave(m);
      if (text.isEmpty) return null;
      final c = Theme.of(context).colorScheme;
      final today = (m['leave'] as Map)['today'] == true;
      return Chip(
        label: Text(text),
        visualDensity: VisualDensity.compact,
        backgroundColor: today ? c.errorContainer : c.surfaceContainerHigh,
        labelStyle: TextStyle(color: today ? c.onErrorContainer : c.onSurface),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(l.team)),
      body: JsonList(
        path: '/staff/team',
        table: JsonTable(
          leading: (context, m) => StaffAvatar(name: '${m['fullName']}', url: m['photoUrl'] as String?),
          columns: [l.employeeId, l.name, l.department, l.role, l.status, l.email, l.phone],
          cells: (context, m) => [
            '${m['employeeNo'] ?? ''}',
            '${m['fullName']}',
            '${m['department'] ?? ''}',
            role(m),
            leave(m),
            '${m['email'] ?? ''}',
            '${m['phone'] ?? ''}',
          ],
          sortKeys: [
            (m) => '${m['employeeNo'] ?? ''}',
            (m) => '${m['fullName']}'.toLowerCase(),
            (m) => '${m['department'] ?? ''}'.toLowerCase(),
            (m) => '${m['role']}',
            // On leave today first, then upcoming leave, then everyone working.
            (m) => m['leave'] == null ? 2 : ((m['leave'] as Map)['today'] == true ? 0 : 1),
            (m) => '${m['email'] ?? ''}',
            (m) => '${m['phone'] ?? ''}',
          ],
        ),
        item: (context, m) => ListTile(
          leading: StaffAvatar(name: '${m['fullName']}', url: m['photoUrl'] as String?),
          title: Text('${m['fullName']}'),
          subtitle: Text(
            [m['employeeNo'], m['department'], role(m), m['email'], m['phone']].whereType<String>().join(' · '),
          ),
          trailing: leaveChip(m),
        ),
      ),
    );
  }
}

// ───────────── top-bar notifications and floating chat ─────────────

const _notificationsPath = '/staff/notifications';

/// Bell with a count of items newer than the last time it was opened; the menu links to each item.
class DeskNotifications extends ConsumerStatefulWidget {
  const DeskNotifications({super.key, required this.base});
  final String base;
  @override
  ConsumerState<DeskNotifications> createState() => _DeskNotificationsState();
}

class _DeskNotificationsState extends ConsumerState<DeskNotifications> {
  DateTime? _seen;

  @override
  void initState() {
    super.initState();
    ref.read(tokenStoreProvider).readNotificationsSeen().then((v) {
      if (mounted && v != null) setState(() => _seen = DateTime.tryParse(v));
    });
  }

  (IconData, String, String) _describe(AppLocalizations l, J n) {
    final base = widget.base;
    final id = n['refId'];
    return switch (n['kind']) {
      'booking' => (Icons.event_available, l.notifBooking, '$base/reservations/$id'),
      'pending' => (Icons.pending_actions, l.notifPending, '$base/reservations/$id'),
      'cancelled' => (Icons.event_busy, l.notifCancelled, '$base/reservations/$id'),
      'request' => (Icons.room_service_outlined, l.notifRequest, '$base/tasks'),
      'order' => (Icons.restaurant, l.notifOrder, '$base/orders'),
      _ => (Icons.chat_bubble_outline, l.notifMessage, '$base/inbox/chat/$id'),
    };
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final t = Theme.of(context);
    final items = jsonList(ref.watch(getProvider(_notificationsPath)).valueOrNull ?? const []);
    DateTime at(J n) => DateTime.parse('${n['at']}').toLocal();
    final unread = items.where((n) => _seen == null || at(n).isAfter(_seen!)).length;
    return Poller(
      every: const Duration(seconds: 20),
      onTick: () => ref.invalidate(getProvider(_notificationsPath)),
      child: MenuAnchor(
        alignmentOffset: const Offset(-320, 4),
        style: const MenuStyle(maximumSize: WidgetStatePropertyAll(Size(380, 520))),
        onOpen: () {
          final now = DateTime.now();
          setState(() => _seen = now);
          ref.read(tokenStoreProvider).writeNotificationsSeen(now.toIso8601String());
        },
        menuChildren: [
          SizedBox(
            width: 360,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Text(l.notifications, style: t.textTheme.titleSmall),
            ),
          ),
          if (items.isEmpty) SizedBox(width: 360, child: ListTile(title: Text(l.nothingHere))),
          for (final n in items)
            Builder(
              builder: (context) {
                final (icon, title, link) = _describe(l, n);
                final who = [n['title'], n['detail']].where((s) => '${s ?? ''}'.isNotEmpty).join(' · ');
                return MenuItemButton(
                  leadingIcon: Icon(icon, size: 20),
                  onPressed: () => context.go(link),
                  child: SizedBox(
                    width: 300,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(title, style: t.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                          if (who.isNotEmpty)
                            Text(who, maxLines: 2, overflow: TextOverflow.ellipsis, style: t.textTheme.bodySmall),
                          Text(
                            '${date(context, at(n))} ${TimeOfDay.fromDateTime(at(n)).format(context)}',
                            style: t.textTheme.labelSmall?.copyWith(color: t.colorScheme.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
        ],
        builder: (context, menu, _) => IconButton(
          tooltip: l.notifications,
          icon: Badge(
            isLabelVisible: unread > 0,
            label: Text('$unread'),
            child: const Icon(Icons.notifications_outlined),
          ),
          onPressed: () => menu.isOpen ? menu.close() : menu.open(),
        ),
      ),
    );
  }
}

/// Floating chat button on every desk screen, with the unread guest-message count.
class DeskChatButton extends ConsumerWidget {
  const DeskChatButton({super.key, required this.base});
  final String base;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    const path = '/staff/dashboard';
    final unread = ((ref.watch(getProvider(path)).valueOrNull as Map?)?['unreadChats'] as num?)?.toInt() ?? 0;
    return Poller(
      every: const Duration(seconds: 20),
      onTick: () => ref.invalidate(getProvider(path)),
      child: FloatingActionButton.extended(
        heroTag: 'desk-chat',
        onPressed: () => context.go('$base/inbox'),
        icon: Badge(isLabelVisible: unread > 0, label: Text('$unread'), child: const Icon(Icons.chat_bubble_outline)),
        label: Text(l.chat),
      ),
    );
  }
}

// ───────────── restaurant staff ─────────────

/// Menu availability for restaurant staff: the outlet's menu (first outlet when there is one; a list otherwise).
class RestaurantMenuScreen extends ConsumerWidget {
  const RestaurantMenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const path = '/admin/outlets';
    return AsyncBody(
      value: ref.watch(getProvider(path)),
      onRetry: () => ref.invalidate(getProvider(path)),
      builder: (data) {
        final outlets = jsonList(data);
        if (outlets.length == 1) return MenuAdminScreen(outlet: outlets.first, canEdit: false);
        return Scaffold(
          appBar: AppBar(title: Text(AppLocalizations.of(context).menu)),
          body: ListView(
            children: [
              if (outlets.isEmpty) EmptyState(AppLocalizations.of(context).nothingHere),
              for (final o in outlets)
                ListTile(
                  title: Text(trOf(context, o['name'])),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.of(
                    context,
                  ).push(MaterialPageRoute<void>(builder: (_) => MenuAdminScreen(outlet: o, canEdit: false))),
                ),
            ],
          ),
        );
      },
    );
  }
}

// ───────────── front desk: book a room, change a booking, take a payment ─────────────

String _iso(DateTime d) => d.toIso8601String().substring(0, 10);
DateTime _today() {
  final n = DateTime.now();
  return DateTime(n.year, n.month, n.day);
}

Future<DateTime?> _pickDate(BuildContext context, DateTime initial, DateTime first) => showDatePicker(
  context: context,
  initialDate: initial.isBefore(first) ? first : initial,
  firstDate: first,
  lastDate: _today().add(const Duration(days: 365)),
);

/// Small number picker (guests) as a dropdown field.
Widget _count(String label, int value, int min, int max, ValueChanged<int> onChanged) => DropdownButtonFormField<int>(
  initialValue: value,
  decoration: InputDecoration(labelText: label),
  items: [for (var i = min; i <= max; i++) DropdownMenuItem(value: i, child: Text('$i'))],
  onChanged: (v) => onChanged(v ?? value),
);

/// Walk-in or phone booking for one room: confirmed and paid at the hotel. Arriving today can check in at once.
class DeskBookDialog extends ConsumerStatefulWidget {
  const DeskBookDialog({super.key, required this.room});
  final J room;
  @override
  ConsumerState<DeskBookDialog> createState() => _DeskBookDialogState();
}

class _DeskBookDialogState extends ConsumerState<DeskBookDialog> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _requests = TextEditingController();
  late DateTime _in = _today();
  late DateTime _out = _in.add(const Duration(days: 1));
  int _adults = 1;
  int _children = 0;

  @override
  void dispose() {
    for (final c in [_name, _phone, _email, _requests]) {
      c.dispose();
    }
    super.dispose();
  }

  /// Returns the new reservation id, or null when the form or the API refused.
  Future<String?> _book({required bool checkIn}) async {
    if (!_form.currentState!.validate()) return null;
    final api = ref.read(apiProvider);
    String? id;
    await act(context, () async {
      final r =
          await api.post('/staff/reservations', {
                'roomId': widget.room['id'],
                'checkIn': _iso(_in),
                'checkOut': _iso(_out),
                'adults': _adults,
                'children': _children,
                if (_requests.text.trim().isNotEmpty) 'specialRequests': _requests.text.trim(),
                'guest': {
                  'fullName': _name.text.trim(),
                  if (_phone.text.trim().isNotEmpty) 'phone': _phone.text.trim(),
                  if (_email.text.trim().isNotEmpty) 'email': _email.text.trim(),
                },
              })
              as Map;
      id = '${r['id']}';
      if (checkIn) await api.post('/staff/reservations/$id/check-in');
    });
    return id;
  }

  Future<void> _submit({required bool checkIn}) async {
    final id = await _book(checkIn: checkIn);
    if (id == null || !mounted) return;
    ref.invalidate(getProvider); // board, queues and counts all change
    Navigator.pop(context, id);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    String? contact(String? _) =>
        _phone.text.trim().isEmpty && _email.text.trim().isEmpty ? l.emailOrPhoneRequired : null;
    return AlertDialog(
      title: Text('${l.bookRoom('${widget.room['number']}')} · ${widget.room['roomType']}'),
      content: SizedBox(
        width: 440,
        child: Form(
          key: _form,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _name,
                  autofocus: true,
                  decoration: InputDecoration(labelText: l.fullName),
                  validator: (v) => (v ?? '').trim().isEmpty ? l.required : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _phone,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(labelText: l.phone),
                  validator: contact,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(labelText: l.email),
                  validator: contact,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: PickerField(
                        label: l.arrival,
                        value: date(context, _in),
                        icon: Icons.event,
                        onTap: () async {
                          final v = await _pickDate(context, _in, _today());
                          if (v == null) return;
                          setState(() {
                            _in = v;
                            if (!_out.isAfter(v)) _out = v.add(const Duration(days: 1));
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: PickerField(
                        label: l.departure,
                        value: date(context, _out),
                        icon: Icons.event,
                        onTap: () async {
                          final v = await _pickDate(context, _out, _in.add(const Duration(days: 1)));
                          if (v != null) setState(() => _out = v);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _count(l.adults, _adults, 1, 10, (v) => setState(() => _adults = v))),
                    const SizedBox(width: 12),
                    Expanded(child: _count(l.children, _children, 0, 10, (v) => setState(() => _children = v))),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _requests,
                  minLines: 1,
                  maxLines: 3,
                  decoration: InputDecoration(labelText: l.specialRequests),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text(l.cancel)),
        if (_in == _today()) OutlinedButton(onPressed: () => _submit(checkIn: true), child: Text(l.bookAndCheckIn)),
        BusyButton(label: l.reserve, onPressed: () => _submit(checkIn: false)),
      ],
    );
  }
}

/// Change dates, room, guest count or guest name/phone on a booking. The sign-in email stays as is.
class ChangeBookingDialog extends ConsumerStatefulWidget {
  const ChangeBookingDialog({super.key, required this.reservation});

  /// The staff reservation detail (GET /staff/reservations/:id).
  final J reservation;
  @override
  ConsumerState<ChangeBookingDialog> createState() => _ChangeBookingDialogState();
}

class _ChangeBookingDialogState extends ConsumerState<ChangeBookingDialog> {
  J get r => widget.reservation;
  J get guest => (r['guest'] as Map).cast<String, dynamic>();
  late DateTime _in = DateTime.parse('${r['checkIn']}');
  late DateTime _out = DateTime.parse('${r['checkOut']}');
  late int _adults = (r['adults'] as num).toInt();
  late int _children = (r['children'] as num).toInt();
  String? _roomId; // null until the room list arrives
  late final _name = TextEditingController(text: '${guest['fullName'] ?? ''}');
  late final _phone = TextEditingController(text: '${guest['phone'] ?? ''}');
  late final _requests = TextEditingController(text: '${r['specialRequests'] ?? ''}');

  bool get _inHouse => r['status'] == 'CHECKED_IN';

  @override
  void dispose() {
    for (final c in [_name, _phone, _requests]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    final ok = await act(
      context,
      () => ref.read(apiProvider).patch('/staff/reservations/${r['id']}', {
        if (!_inHouse) 'checkIn': _iso(_in),
        'checkOut': _iso(_out),
        if (_roomId != null) 'roomId': _roomId,
        'adults': _adults,
        'children': _children,
        'specialRequests': _requests.text.trim(),
        'guest': {'fullName': _name.text.trim(), 'phone': _phone.text.trim()},
      }),
    );
    if (ok && mounted) {
      ref.invalidate(getProvider);
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final rooms = jsonList((ref.watch(getProvider('/staff/board')).valueOrNull as Map?)?['rooms'] ?? const []);
    _roomId ??= rooms.where((x) => '${x['number']}' == '${r['room']}').map((x) => '${x['id']}').firstOrNull;
    return AlertDialog(
      title: Text('${l.changeBooking} · ${r['code']}'),
      content: SizedBox(
        width: 440,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: PickerField(
                      label: l.arrival,
                      value: date(context, _in),
                      icon: _inHouse ? Icons.lock_outline : Icons.event,
                      onTap: _inHouse
                          ? () {}
                          : () async {
                              final v = await _pickDate(context, _in, _today());
                              if (v == null) return;
                              setState(() {
                                _in = v;
                                if (!_out.isAfter(v)) _out = v.add(const Duration(days: 1));
                              });
                            },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: PickerField(
                      label: l.departure,
                      value: date(context, _out),
                      icon: Icons.event,
                      onTap: () async {
                        final first = _in.isAfter(_today()) ? _in : _today();
                        final v = await _pickDate(context, _out, first.add(const Duration(days: 1)));
                        if (v != null) setState(() => _out = v);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _roomId,
                decoration: InputDecoration(labelText: l.roomLabel),
                items: [
                  for (final x in rooms)
                    DropdownMenuItem(value: '${x['id']}', child: Text('${x['number']} · ${x['roomType']}')),
                ],
                onChanged: (v) => setState(() => _roomId = v),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _count(l.adults, _adults, 1, 10, (v) => setState(() => _adults = v))),
                  const SizedBox(width: 12),
                  Expanded(child: _count(l.children, _children, 0, 10, (v) => setState(() => _children = v))),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _name,
                decoration: InputDecoration(labelText: l.fullName),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _phone,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(labelText: l.phone),
              ),
              const SizedBox(height: 12),
              TextField(
                enabled: false,
                controller: TextEditingController(text: '${guest['email'] ?? ''}'),
                decoration: InputDecoration(labelText: l.email, helperText: l.emailLocked, helperMaxLines: 2),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _requests,
                minLines: 1,
                maxLines: 3,
                decoration: InputDecoration(labelText: l.specialRequests),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text(l.cancel)),
        BusyButton(label: l.save, onPressed: _save),
      ],
    );
  }
}

/// Cash or card taken at the desk; the amount starts at the balance due.
class RecordPaymentDialog extends ConsumerStatefulWidget {
  const RecordPaymentDialog({super.key, required this.reservationId, required this.balance, required this.currency});
  final String reservationId;
  final double balance;
  final String currency;
  @override
  ConsumerState<RecordPaymentDialog> createState() => _RecordPaymentDialogState();
}

class _RecordPaymentDialogState extends ConsumerState<RecordPaymentDialog> {
  late final _amount = TextEditingController(text: widget.balance.toStringAsFixed(2));
  String _method = 'cash';

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final amount = double.tryParse(_amount.text.replaceAll(',', '').trim());
    final l = AppLocalizations.of(context);
    if (amount == null || amount <= 0) return snack(context, l.required);
    final ok = await act(
      context,
      () => ref.read(apiProvider).post('/staff/reservations/${widget.reservationId}/payments', {
        'amount': amount,
        'method': _method,
      }),
    );
    if (ok && mounted) {
      ref.invalidate(getProvider);
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l.recordPayment),
      content: SizedBox(
        width: 360,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _amount,
              autofocus: true,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: l.amount, prefixText: '${widget.currency} '),
            ),
            const SizedBox(height: 12),
            SegmentedButton<String>(
              segments: [
                ButtonSegment(value: 'cash', icon: const Icon(Icons.payments_outlined), label: Text(l.cash)),
                ButtonSegment(value: 'card', icon: const Icon(Icons.credit_card), label: Text(l.card)),
              ],
              selected: {_method},
              onSelectionChanged: (s) => setState(() => _method = s.first),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text(l.cancel)),
        BusyButton(label: l.recordPayment, onPressed: _save),
      ],
    );
  }
}

/// Front desk files a service request for a guest (phone call, walk-up): pick their booking and the service,
/// then fill the same form the guest would.
class NewServiceRequestDialog extends ConsumerStatefulWidget {
  const NewServiceRequestDialog({super.key});
  @override
  ConsumerState<NewServiceRequestDialog> createState() => _NewServiceRequestDialogState();
}

class _NewServiceRequestDialogState extends ConsumerState<NewServiceRequestDialog> {
  String? _booking; // reservation id: rows are re-fetched, ids stay stable
  String? _service;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    // In-house and upcoming stays: the guests a request can be for.
    final stays = jsonList(ref.watch(getProvider('/staff/reservations?view=upcoming')).valueOrNull ?? const []);
    final services = jsonList(ref.watch(getProvider('/hotels/$hotelId/services')).valueOrNull ?? const []);
    return AlertDialog(
      title: Text(l.newRequest),
      content: SizedBox(
        width: 440,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<String>(
              initialValue: _booking,
              isExpanded: true,
              decoration: InputDecoration(labelText: l.guestBooking),
              items: [
                for (final r in stays)
                  DropdownMenuItem(
                    value: '${r['id']}',
                    child: Text(
                      [
                        r['guestName'],
                        r['room'] == null ? null : l.roomNumber('${r['room']}'),
                        r['code'],
                      ].whereType<Object>().join(' · '),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
              onChanged: (v) => setState(() => _booking = v),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _service,
              isExpanded: true,
              decoration: InputDecoration(labelText: l.services),
              items: [
                for (final s in services)
                  DropdownMenuItem(
                    value: '${s['id']}',
                    child: Text('${s['name']}', overflow: TextOverflow.ellipsis),
                  ),
              ],
              onChanged: (v) => setState(() => _service = v),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text(l.cancel)),
        FilledButton(
          onPressed: _booking == null || _service == null
              ? null
              : () async {
                  final b = stays.firstWhere((r) => '${r['id']}' == _booking);
                  final stay = ReservationSummary(
                    id: '${b['id']}',
                    code: '${b['code']}',
                    status: parseStatus('${b['status']}'),
                    checkIn: DateTime.parse('${b['checkIn']}'),
                    checkOut: DateTime.parse('${b['checkOut']}'),
                    roomTypeName: '${b['roomType']}',
                    total: 0,
                    currency: '${b['currency']}',
                  );
                  final sent = await Navigator.of(context).push<bool>(
                    MaterialPageRoute(
                      builder: (_) => ServiceRequestScreen(id: _service!, forGuest: stay),
                    ),
                  );
                  if (sent == true && context.mounted) Navigator.pop(context, true);
                },
          child: Text(l.next),
        ),
      ],
    );
  }
}
