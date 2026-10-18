import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/adaptive.dart';
import '../../core/format.dart';
import '../../core/http.dart';
import '../../core/ui.dart';
import '../../l10n/app_localizations.dart';
import '../auth/domain/auth.dart';
import '../auth/presentation/auth_controller.dart';
import '../booking/domain/booking.dart';
import '../booking/presentation/booking_providers.dart';
import '../chat/chat_screen.dart';
import '../services/services_screens.dart' show paymentMethodLabel, stepLabel;
import 'desk_screens.dart';

/// Staff routes live under /staff; admins reach the same screens under /admin/desk.
String deskBase(Role role) => role == Role.admin ? '/admin/desk' : '/staff';

// ───────────── T1 dashboard ─────────────

class StaffHomeScreen extends ConsumerWidget {
  const StaffHomeScreen({super.key, this.base = '/staff'});
  final String base;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    const path = '/staff/dashboard';
    final d = (ref.watch(getProvider(path)).valueOrNull as Map?)?.cast<String, dynamic>() ?? const {};
    int n(String k) => (d[k] as num?)?.toInt() ?? 0;
    final wide = isWide(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l.frontDesk),
        actions: [
          if (wide)
            IconButton(
              tooltip: l.refresh,
              icon: const Icon(Icons.refresh),
              onPressed: () => ref.invalidate(getProvider(path)),
            ),
          if (base == '/staff' && !wide)
            IconButton(
              tooltip: l.settings,
              icon: const Icon(Icons.settings_outlined),
              onPressed: () => context.push('/settings'),
            ),
        ],
      ),
      body: Poller(
        every: const Duration(seconds: 15),
        onTick: () => ref.invalidate(getProvider(path)),
        child: RefreshIndicator(
          onRefresh: () => ref.refresh(getProvider(path).future),
          child: ListView(
            padding: const EdgeInsets.all(12),
            children: wide
                ? [
                    // Wide: one overview — today's numbers, the room board, who arrives and leaves, what needs action.
                    KpiGrid([
                      Kpi(l.arrivals, '${n('arrivals')}', onTap: () => context.go('$base/reservations')),
                      Kpi(l.departures, '${n('departures')}', onTap: () => context.go('$base/reservations')),
                      Kpi(l.inHouse, '${n('inHouse')}', onTap: () => context.go('$base/reservations')),
                      Kpi(l.openTasks, '${n('openTasks')}', onTap: () => context.go('$base/tasks')),
                    ]),
                    const SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 3, child: RoomBoard(base: base)),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              AttentionCard([
                                (
                                  Icons.pending_actions,
                                  l.pendingApproval,
                                  n('pending'),
                                  () => context.go('$base/reservations'),
                                ),
                                (Icons.task_alt, l.myTasks, n('myTasks'), () => context.go('$base/tasks')),
                                (
                                  Icons.restaurant,
                                  l.restaurantOrders,
                                  n('openOrders'),
                                  () => context.go('$base/orders'),
                                ),
                                (
                                  Icons.chat_bubble_outline,
                                  l.unreadChats,
                                  n('unreadChats'),
                                  () => context.go('$base/inbox'),
                                ),
                              ]),
                              const SizedBox(height: 16),
                              StayListCard(base: base, departures: false),
                              const SizedBox(height: 16),
                              StayListCard(base: base, departures: true),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 88), // clears the chat button
                  ]
                : [
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _Stat(l.arrivals, n('arrivals')),
                        _Stat(l.departures, n('departures')),
                        _Stat(l.inHouse, n('inHouse')),
                        _Stat(l.pendingApproval, n('pending')),
                      ],
                    ),
                    const SizedBox(height: 8),
                    StayListCard(base: base, departures: false),
                    const SizedBox(height: 8),
                    RoomBoard(base: base),
                    const SizedBox(height: 8),
                    NavTile(
                      Icons.event_note,
                      l.reservations,
                      () => context.push('$base/reservations'),
                      badge: n('pending'),
                    ),
                    NavTile(
                      Icons.room_service_outlined,
                      l.serviceRequests,
                      () => context.push('$base/tasks'),
                      badge: n('myTasks'),
                    ),
                    NavTile(
                      Icons.restaurant,
                      l.restaurantOrders,
                      () => context.push('$base/orders'),
                      badge: n('openOrders'),
                    ),
                    NavTile(
                      Icons.chat_bubble_outline,
                      l.chat,
                      () => context.push('$base/inbox'),
                      badge: n('unreadChats'),
                    ),
                    NavTile(Icons.bed_outlined, l.rooms, () => context.push('$base/rooms')),
                    NavTile(Icons.people_outline, l.guestList, () => context.push('$base/guests')),
                    NavTile(Icons.groups_outlined, l.team, () => context.push('$base/team')),
                    NavTile(Icons.beach_access, l.myLeave, () => context.push('$base/leave')),
                  ],
          ),
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat(this.label, this.value);
  final String label;
  final int value;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 160,
    child: Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$value', style: Theme.of(context).textTheme.headlineSmall),
            Text(label),
          ],
        ),
      ),
    ),
  );
}

// ───────────── T2 reservations queue ─────────────

class ReservationsQueueScreen extends ConsumerStatefulWidget {
  const ReservationsQueueScreen({super.key, required this.base, this.q});
  final String base;
  final String? q;
  @override
  ConsumerState<ReservationsQueueScreen> createState() => _QueueState();
}

class _QueueState extends ConsumerState<ReservationsQueueScreen> {
  late String _q = widget.q ?? '';
  // A guest lookup should show their past stays too.
  late String _view = _q.isEmpty ? 'upcoming' : 'all';

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final views = {
      'arrivals': l.arrivals,
      'departures': l.departures,
      'inhouse': l.inHouse,
      'pending': l.pendingApproval,
      'upcoming': l.upcoming,
      'all': l.all,
    };
    final path = '/staff/reservations?view=$_view${_q.isEmpty ? '' : '&q=${Uri.encodeQueryComponent(_q)}'}';
    final wide = isWide(context);
    DateTime day(Object? v) => DateTime.parse('$v');
    String text(Object? v) => '${v ?? ''}'.toLowerCase();
    return Scaffold(
      appBar: AppBar(title: Text(l.reservations)),
      body: Column(
        children: [
          // Wide: the view dropdown and search live in the table toolbar.
          if (!wide)
            SizedBox(
              height: 48,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                children: [
                  for (final e in views.entries)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ChoiceChip(
                        label: Text(e.value),
                        selected: _view == e.key,
                        onSelected: (_) => setState(() => _view = e.key),
                      ),
                    ),
                ],
              ),
            ),
          if (!wide)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: TextField(
                decoration: InputDecoration(prefixIcon: const Icon(Icons.search), hintText: l.searchGuest),
                onSubmitted: (v) => setState(() => _q = v.trim()),
              ),
            ),
          Expanded(
            child: JsonList(
              path: path,
              table: JsonTable(
                columns: [l.name, l.codeLabel, l.roomTypeLabel, l.roomLabel, l.dates, l.status, l.paymentMethod],
                cells: (context, r) => [
                  '${r['guestName']}',
                  '${r['code']}',
                  '${r['roomType']}',
                  '${r['room'] ?? ''}',
                  dateRange(context, DateTime.parse('${r['checkIn']}'), DateTime.parse('${r['checkOut']}')),
                  statusLabel(l, parseStatus('${r['status']}')),
                  paymentLabel(l, r['payment'] as String?),
                ],
                // Wide only: go (not push) keeps this queue page and opens the detail as a side panel over it.
                onTap: (r) => context.go('${widget.base}/reservations/${r['id']}'),
                sortKeys: [
                  (r) => text(r['guestName']),
                  (r) => text(r['code']),
                  (r) => text(r['roomType']),
                  (r) => text(r['room']),
                  (r) => day(r['checkIn']),
                  (r) => text(r['status']),
                  // Not paid first: that is what the desk chases.
                  (r) => const ['unpaid', 'partial', 'deposit', 'paid'].indexOf('${r['payment']}'),
                ],
                onSearch: (q) => setState(() => _q = q),
                searchHint: l.searchGuest,
                toolbar: [
                  DropdownButton<String>(
                    value: _view,
                    hint: Text(l.viewLabel),
                    underline: const SizedBox(),
                    items: [for (final e in views.entries) DropdownMenuItem(value: e.key, child: Text(e.value))],
                    onChanged: (v) => setState(() => _view = v ?? _view),
                  ),
                ],
              ),
              item: (context, r) => ListTile(
                title: Text('${r['guestName']} · ${r['code']}'),
                subtitle: Text(
                  '${r['roomType']}${r['room'] != null ? ' · ${l.roomNumber('${r['room']}')}' : ''}\n'
                  '${dateRange(context, DateTime.parse('${r['checkIn']}'), DateTime.parse('${r['checkOut']}'))}'
                  ' · ${paymentLabel(l, r['payment'] as String?)}',
                ),
                isThreeLine: true,
                trailing: StatusChip(parseStatus('${r['status']}')),
                onTap: () => context.push('${widget.base}/reservations/${r['id']}'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ───────────── T3 reservation detail + actions ─────────────

class StaffReservationScreen extends ConsumerWidget {
  const StaffReservationScreen({super.key, required this.id, this.panel = false});
  final String id;

  /// Shown as a side panel over the queue (wide screens): close button, and actions refresh the queue too.
  final bool panel;

  /// Staff cancel: the refund follows the cancellation policy (shown first); the API logs it in the audit log.
  Future<void> _cancel(BuildContext context, WidgetRef ref) async {
    final l = AppLocalizations.of(context);
    final api = ref.read(apiProvider);
    Map? q;
    final quoted = await act(context, () async => q = await api.get('/reservations/$id/cancel-quote') as Map);
    if (!quoted || !context.mounted) return;
    final refund = money(num2(q!['refund']), '${q!['currency']}');
    if (!await confirm(context, l.cancelBooking, l.staffCancelConfirm(refund)) || !context.mounted) return;
    final reason = await prompt(context, l.cancelBooking, label: l.reason);
    if (reason == null || !context.mounted) return;
    if (await act(context, () => api.post('/reservations/$id/cancel', {'reason': reason}))) {
      ref.invalidate(getProvider);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final path = '/staff/reservations/$id';
    final api = ref.read(apiProvider);
    Future<void> run(String action, [Object? body]) async {
      if (await act(context, () => api.post('$path/$action', body))) {
        // Panel: the queue underneath shows the new status too (whole family; only watched paths refetch).
        panel ? ref.invalidate(getProvider) : ref.invalidate(getProvider(path));
      }
    }

    return Scaffold(
      appBar: panel
          ? AppBar(
              automaticallyImplyLeading: false,
              title: Text(l.reservation),
              actions: [
                IconButton(
                  tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.maybePop(context),
                ),
              ],
            )
          : AppBar(title: Text(l.reservation)),
      body: AsyncBody(
        value: ref.watch(getProvider(path)),
        onRetry: () => ref.invalidate(getProvider(path)),
        builder: (data) {
          final r = (data as Map).cast<String, dynamic>();
          final status = parseStatus('${r['status']}');
          final guest = (r['guest'] as Map).cast<String, dynamic>();
          final cur = '${r['currency']}';
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                children: [
                  Expanded(child: Text('${guest['fullName']}', style: Theme.of(context).textTheme.titleLarge)),
                  PaymentChip(r['payment'] as String?),
                  const SizedBox(width: 8),
                  StatusChip(status),
                ],
              ),
              Text([guest['email'], guest['phone']].whereType<String>().join(' · ')),
              KV(l.codeLabel, '${r['code']}'),
              KV(l.roomTypeLabel, '${(r['roomType'] as Map)['name']}'),
              if (r['room'] != null) KV(l.roomLabel, '${r['room']}'),
              KV(l.dates, dateRange(context, DateTime.parse('${r['checkIn']}'), DateTime.parse('${r['checkOut']}'))),
              KV(l.guests, '${r['adults']} + ${r['children']}'),
              KV(l.totalLabel, money(num2((r['price'] as Map)['total']), cur)),
              KV(l.paid, money(num2(r['paid']), cur)),
              KV(l.balance, money(num2(r['balance']), cur)),
              if ((r['specialRequests'] ?? '') != '') KV(l.specialRequests, '${r['specialRequests']}'),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (status == BookingStatus.pending) ...[
                    FilledButton(onPressed: () => run('approve'), child: Text(l.approve)),
                    OutlinedButton(
                      onPressed: () async {
                        final reason = await prompt(context, l.decline, label: l.reason);
                        if (reason != null) await run('decline', {'reason': reason});
                      },
                      child: Text(l.decline),
                    ),
                  ],
                  if (status == BookingStatus.confirmed) ...[
                    FilledButton(onPressed: () => run('check-in'), child: Text(l.checkInAction)),
                    OutlinedButton(
                      onPressed: () async {
                        if (await confirm(context, l.markNoShow)) await run('no-show');
                      },
                      child: Text(l.markNoShow),
                    ),
                  ],
                  if (const [BookingStatus.pending, BookingStatus.confirmed, BookingStatus.checkedIn].contains(status))
                    OutlinedButton.icon(
                      icon: const Icon(Icons.edit_calendar_outlined),
                      label: Text(l.changeBooking),
                      onPressed: () => showDialog<bool>(
                        context: context,
                        builder: (_) => ChangeBookingDialog(reservation: r),
                      ),
                    ),
                  if (num2(r['balance']) > 0 &&
                      const [
                        BookingStatus.pending,
                        BookingStatus.confirmed,
                        BookingStatus.checkedIn,
                        BookingStatus.checkedOut,
                      ].contains(status))
                    OutlinedButton.icon(
                      icon: const Icon(Icons.point_of_sale),
                      label: Text(l.recordPayment),
                      onPressed: () => showDialog<bool>(
                        context: context,
                        builder: (_) =>
                            RecordPaymentDialog(reservationId: id, balance: num2(r['balance']), currency: cur),
                      ),
                    ),
                  if (status == BookingStatus.pending || status == BookingStatus.confirmed)
                    TextButton(
                      style: TextButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.error),
                      onPressed: () => _cancel(context, ref),
                      child: Text(l.cancelBooking),
                    ),
                  if (status == BookingStatus.checkedIn) ...[
                    FilledButton(onPressed: () => run('check-out'), child: Text(l.checkOutAction)),
                    OutlinedButton(onPressed: () => run('wifi'), child: Text(l.reissueWifi)),
                  ],
                ],
              ),
              const Divider(),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l.internalNotes),
                subtitle: Text('${r['internalNotes'] ?? '—'}'),
                trailing: const Icon(Icons.edit),
                onTap: () async {
                  final v = await prompt(context, l.internalNotes, initial: '${r['internalNotes'] ?? ''}');
                  if (v == null || !context.mounted) return;
                  if (await act(context, () => api.patch('$path/notes', {'internalNotes': v}))) {
                    ref.invalidate(getProvider(path));
                  }
                },
              ),
              Text(l.history, style: Theme.of(context).textTheme.titleSmall),
              for (final h in jsonList(r['history']))
                KV(
                  '${h['to']}${h['note'] != null ? ' · ${h['note']}' : ''}',
                  date(context, DateTime.parse('${h['at']}').toLocal()),
                ),
            ],
          );
        },
      ),
    );
  }
}

// ───────────── S-3 tasks ─────────────

class TasksScreen extends ConsumerStatefulWidget {
  const TasksScreen({super.key});
  @override
  ConsumerState<TasksScreen> createState() => _TasksState();
}

class _TasksState extends ConsumerState<TasksScreen> {
  String _scope = 'mine';

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final path = '/staff/tasks?scope=$_scope';
    final api = ref.read(apiProvider);
    final scopes = {'mine': l.mine, 'department': l.myDepartment, 'unassigned': l.unassigned, 'all': l.all};
    Future<void> run(String id, String action, [Object? body]) async {
      if (await act(context, () => api.post('/staff/tasks/$id/$action', body))) ref.invalidate(getProvider(path));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l.serviceRequests),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilledButton.icon(
              icon: const Icon(Icons.add),
              label: Text(l.newRequest),
              onPressed: () async {
                final sent = await showDialog<bool>(context: context, builder: (_) => const NewServiceRequestDialog());
                if (sent == true) ref.invalidate(getProvider(path));
              },
            ),
          ),
        ],
      ),
      body: Poller(
        every: const Duration(seconds: 10),
        onTick: () => ref.invalidate(getProvider(path)),
        child: Column(
          children: [
            Wrap(
              spacing: 8,
              children: [
                for (final e in scopes.entries)
                  ChoiceChip(
                    label: Text(e.value),
                    selected: _scope == e.key,
                    onSelected: (_) => setState(() => _scope = e.key),
                  ),
              ],
            ),
            Expanded(
              child: JsonList(
                path: path,
                item: (context, t) {
                  final steps = (t['steps'] as List).cast<String>();
                  final i = steps.indexOf('${t['status']}');
                  final next = i >= 0 && i < steps.length - 1 ? steps[i + 1] : null;
                  final answers = (t['answers'] as Map?)?.entries.map((e) => '${e.key}: ${e.value}').join(' · ') ?? '';
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${t['name']}${t['room'] != null ? ' · ${l.roomNumber('${t['room']}')}' : ''}',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            '${stepLabel('${t['status']}')} · ${paymentMethodLabel(l, '${t['paymentMethod']}')}${t['total'] != null ? ' · ${t['total']}' : ''}',
                          ),
                          if ((t['options'] as List).isNotEmpty) Text((t['options'] as List).join(', ')),
                          if (answers.isNotEmpty) Text(answers, style: Theme.of(context).textTheme.bodySmall),
                          if (t['scheduledFor'] != null)
                            Text(date(context, DateTime.parse('${t['scheduledFor']}').toLocal())),
                          Wrap(
                            spacing: 8,
                            children: [
                              if (i == 0 && t['total'] != null)
                                FilledButton(onPressed: () => run('${t['id']}', 'accept'), child: Text(l.accept)),
                              if (i == 0 && t['total'] == null)
                                FilledButton(
                                  onPressed: () async {
                                    final v = await prompt(context, l.sendQuote, number: true);
                                    final amount = double.tryParse(v ?? '');
                                    if (amount != null) await run('${t['id']}', 'quote', {'amount': amount});
                                  },
                                  child: Text(l.sendQuote),
                                ),
                              if (i > 0 && next != null)
                                FilledButton(
                                  onPressed: () => run('${t['id']}', 'step', {'to': next}),
                                  child: Text(stepLabel(next)),
                                ),
                              TextButton(
                                onPressed: () async {
                                  final v = await prompt(context, l.escalate, label: l.reason);
                                  if (v != null && v.isNotEmpty) await run('${t['id']}', 'escalate', {'note': v});
                                },
                                child: Text(l.escalate),
                              ),
                              TextButton(
                                onPressed: () async {
                                  final v = await prompt(context, l.cancelRequest, label: l.reason);
                                  if (v != null && v.isNotEmpty) await run('${t['id']}', 'cancel', {'note': v});
                                },
                                child: Text(l.cancelRequest),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ───────────── R-3 restaurant queue ─────────────

class OrdersQueueScreen extends ConsumerWidget {
  const OrdersQueueScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    const path = '/staff/restaurant-orders';
    const steps = ['submitted', 'accepted', 'preparing', 'served'];
    final lang = ref.watch(languageProvider) ?? 'en';
    final api = ref.read(apiProvider);
    Future<void> setStatus(String id, String to, [String? reason]) async {
      if (await act(context, () => api.post('$path/$id/status', {'to': to, if (reason != null) 'reason': reason}))) {
        ref.invalidate(getProvider(path));
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text(l.restaurantOrders)),
      body: Poller(
        every: const Duration(seconds: 8),
        onTick: () => ref.invalidate(getProvider(path)),
        child: JsonList(
          path: path,
          item: (context, o) {
            final i = steps.indexOf('${o['status']}');
            final next = steps[i + 1];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${l.tableLabel('${o['table']}')} · ${stepLabel('${o['status']}')}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    for (final it in jsonList(o['items']))
                      Text(
                        '${it['qty']} × ${(it['name'] as Map)[lang] ?? (it['name'] as Map)['en']}${it['notes'] != null ? ' (${it['notes']})' : ''}',
                      ),
                    if (o['allergyNotes'] != null)
                      Text(
                        '${l.allergyNotes}: ${o['allergyNotes']}',
                        style: TextStyle(color: Theme.of(context).colorScheme.error),
                      ),
                    Text('${paymentMethodLabel(l, '${o['paymentMethod']}')} · ${o['total']}'),
                    Wrap(
                      spacing: 8,
                      children: [
                        FilledButton(onPressed: () => setStatus('${o['id']}', next), child: Text(stepLabel(next))),
                        TextButton(
                          onPressed: () async {
                            final v = await prompt(context, l.cancelOrder, label: l.reason);
                            if (v != null) await setStatus('${o['id']}', 'cancelled', v);
                          },
                          child: Text(l.cancelOrder),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ───────────── T8 chat inbox ─────────────

class InboxScreen extends ConsumerWidget {
  const InboxScreen({super.key, required this.base, this.openId, this.openTitle});
  final String base;

  /// Wide two-pane mode: the thread shown on the right (from `inbox/chat/:id`).
  final String? openId;
  final String? openTitle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    const path = '/staff/conversations';
    if (isWide(context)) return _InboxPanes(base: base, openId: openId, openTitle: openTitle);
    return Scaffold(
      appBar: AppBar(title: Text(l.chat)),
      body: Poller(
        every: const Duration(seconds: 10),
        onTick: () => ref.invalidate(getProvider(path)),
        child: JsonList(
          path: path,
          item: (context, c) => ListTile(
            leading: Badge(
              isLabelVisible: (c['unread'] as num) > 0,
              label: Text('${c['unread']}'),
              child: const Icon(Icons.person),
            ),
            title: Text('${c['guestName']}'),
            subtitle: Text(date(context, DateTime.parse('${c['lastMessageAt']}').toLocal())),
            onTap: () => context.push('$base/chat/${c['id']}', extra: '${c['guestName']}'),
          ),
        ),
      ),
    );
  }
}

/// Wide inbox: searchable thread list on the left, the open thread on the right.
class _InboxPanes extends ConsumerStatefulWidget {
  const _InboxPanes({required this.base, this.openId, this.openTitle});
  final String base;
  final String? openId;
  final String? openTitle;
  @override
  ConsumerState<_InboxPanes> createState() => _InboxPanesState();
}

class _InboxPanesState extends ConsumerState<_InboxPanes> {
  static const path = '/staff/conversations';
  String _q = '';

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final value = ref.watch(getProvider(path));
    final rows = jsonList(value.valueOrNull ?? const []);
    final open = widget.openId;
    final title = rows.where((c) => c['id'] == open).map((c) => '${c['guestName']}').firstOrNull ?? widget.openTitle;
    return Scaffold(
      appBar: AppBar(title: Text(l.chat)),
      body: Poller(
        every: const Duration(seconds: 10),
        onTick: () => ref.invalidate(getProvider(path)),
        child: Row(
          children: [
            SizedBox(
              width: 320,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                    child: TextField(
                      onChanged: (v) => setState(() => _q = v.trim().toLowerCase()),
                      decoration: InputDecoration(
                        isDense: true,
                        prefixIcon: const Icon(Icons.search),
                        hintText: l.search,
                      ),
                    ),
                  ),
                  Expanded(
                    child: AsyncBody(
                      value: value,
                      onRetry: () => ref.invalidate(getProvider(path)),
                      builder: (_) {
                        final shown = [
                          for (final c in rows)
                            if ('${c['guestName']}'.toLowerCase().contains(_q)) c,
                        ];
                        if (shown.isEmpty) return Center(child: Text(l.nothingHere));
                        return ListView(
                          children: [
                            for (final c in shown)
                              ListTile(
                                selected: c['id'] == open,
                                leading: Badge(
                                  isLabelVisible: (c['unread'] as num) > 0,
                                  label: Text('${c['unread']}'),
                                  child: const Icon(Icons.person),
                                ),
                                title: Text('${c['guestName']}', overflow: TextOverflow.ellipsis),
                                subtitle: Text(date(context, DateTime.parse('${c['lastMessageAt']}').toLocal())),
                                onTap: () => context.go('${widget.base}/inbox/chat/${c['id']}'),
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const VerticalDivider(width: 1),
            Expanded(
              child: open == null
                  ? Center(child: Text(l.selectThread))
                  // Keyed by thread: switching disposes the old ChatScreen and stops its poll timer.
                  : ChatScreen(key: ValueKey(open), id: open, title: title, embedded: true),
            ),
          ],
        ),
      ),
    );
  }
}

// ───────────── T9 leave ─────────────

class LeaveScreen extends ConsumerWidget {
  const LeaveScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    const path = '/me/leave';
    return Scaffold(
      appBar: AppBar(title: Text(l.myLeave)),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: Text(l.applyLeave),
        onPressed: () async {
          final sent = await showDialog<bool>(
            context: context,
            builder: (_) => const _LeaveForm(path: path),
          );
          if (sent == true) ref.invalidate(getProvider(path));
        },
      ),
      body: JsonList(
        path: path,
        item: (context, r) => ListTile(
          title: Text(dateRange(context, DateTime.parse('${r['from']}'), DateTime.parse('${r['to']}'))),
          subtitle: Text(
            [leaveTypeLabel(l, '${r['type']}'), r['reason']].where((s) => '${s ?? ''}'.isNotEmpty).join(' · '),
          ),
          trailing: Chip(label: Text(leaveStatus(l, '${r['status']}'))),
        ),
      ),
    );
  }
}

String leaveTypeLabel(AppLocalizations l, String t) => switch (t) {
  'sick' => l.leaveSick,
  'emergency' => l.leaveEmergency,
  'other' => l.leaveOther,
  _ => l.leaveVacation,
};

/// Apply for leave in one form: type, From and To dates (To starts on From, so one day is one tap), reason.
class _LeaveForm extends ConsumerStatefulWidget {
  const _LeaveForm({required this.path});
  final String path;
  @override
  ConsumerState<_LeaveForm> createState() => _LeaveFormState();
}

class _LeaveFormState extends ConsumerState<_LeaveForm> {
  static DateTime _today() {
    final n = DateTime.now();
    return DateTime(n.year, n.month, n.day);
  }

  late DateTime _from = _today().add(const Duration(days: 1));
  late DateTime _to = _from;
  String _type = 'vacation';
  final _reason = TextEditingController();

  @override
  void dispose() {
    _reason.dispose();
    super.dispose();
  }

  Future<DateTime?> _pick(DateTime initial, DateTime first) => showDatePicker(
    context: context,
    initialDate: initial,
    firstDate: first,
    lastDate: _today().add(const Duration(days: 365)),
  );

  Future<void> _submit() async {
    String d(DateTime x) => x.toIso8601String().substring(0, 10);
    final reason = _reason.text.trim();
    final ok = await act(
      context,
      () => ref.read(apiProvider).post(widget.path, {
        'from': d(_from),
        'to': d(_to),
        'type': _type,
        if (reason.isNotEmpty) 'reason': reason,
      }),
    );
    if (ok && mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l.applyLeave),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<String>(
              initialValue: _type,
              decoration: InputDecoration(labelText: l.leaveType),
              items: [
                for (final t in const ['vacation', 'sick', 'emergency', 'other'])
                  DropdownMenuItem(value: t, child: Text(leaveTypeLabel(l, t))),
              ],
              onChanged: (v) => setState(() => _type = v ?? _type),
            ),
            const SizedBox(height: 12),
            PickerField(
              label: l.dateFrom,
              value: date(context, _from),
              icon: Icons.event,
              onTap: () async {
                final v = await _pick(_from, _today());
                if (v == null) return;
                setState(() {
                  _from = v;
                  if (_to.isBefore(v)) _to = v; // To never ends before From
                });
              },
            ),
            const SizedBox(height: 12),
            PickerField(
              label: l.dateTo,
              value: date(context, _to),
              icon: Icons.event,
              onTap: () async {
                final v = await _pick(_to, _from);
                if (v != null) setState(() => _to = v);
              },
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _reason,
              minLines: 1,
              maxLines: 3,
              decoration: InputDecoration(labelText: l.reason),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: Text(l.cancel)),
        BusyButton(label: l.submit, onPressed: _submit),
      ],
    );
  }
}

String leaveStatus(AppLocalizations l, String s) => switch (s) {
  'approved' => l.approved,
  'rejected' => l.rejected,
  _ => l.statusPending,
};
