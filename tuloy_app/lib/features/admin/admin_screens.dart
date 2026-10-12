import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/adaptive.dart';
import '../../core/config.dart';
import '../../core/format.dart';
import '../../core/http.dart';
import '../../core/find_by_id.dart';
import '../../core/ui.dart';
import '../../l10n/app_localizations.dart';

// ───────────── A1 dashboard + menu ─────────────

class AdminHomeScreen extends ConsumerWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    const path = '/admin/dashboard';
    final d = (ref.watch(getProvider(path)).valueOrNull as Map?)?.cast<String, dynamic>() ?? const {};
    final cur = '${d['currency'] ?? 'PHP'}';
    final alerts = (d['alerts'] as Map?) ?? const {};
    final wide = isWide(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l.adminHome),
        actions: [
          if (wide)
            IconButton(
              tooltip: l.refresh,
              icon: const Icon(Icons.refresh),
              onPressed: () => ref.invalidate(getProvider(path)),
            ),
          IconButton(
            tooltip: l.settings,
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: Poller(
        every: const Duration(seconds: 30),
        onTick: () => ref.invalidate(getProvider(path)),
        child: RefreshIndicator(
          onRefresh: () => ref.refresh(getProvider(path).future),
          child: ListView(
            padding: const EdgeInsets.all(12),
            children: wide
                ? _wide(context, l, d, cur, alerts)
                : [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: [
                            KV(
                              l.occupancyTonight,
                              '${d['occupancy'] ?? 0}% (${d['roomsSold'] ?? 0}/${d['rooms'] ?? 0})',
                            ),
                            KV(l.arrivals, '${d['arrivals'] ?? 0}'),
                            KV(l.departures, '${d['departures'] ?? 0}'),
                            KV(l.inHouse, '${d['inHouse'] ?? 0}'),
                            KV(l.pendingApproval, '${d['pending'] ?? 0}'),
                            KV(l.openTasks, '${d['openTasks'] ?? 0}'),
                            KV(l.collectedToday, money(num2(d['collectedToday']), cur)),
                            KV(l.refundedToday, money(num2(d['refundedToday']), cur)),
                            KV(l.netToday, money(num2(d['netToday']), cur)),
                          ],
                        ),
                      ),
                    ),
                    if ((alerts['failedRefunds'] ?? 0) > 0 || (alerts['failedNotifications'] ?? 0) > 0)
                      Card(
                        color: Theme.of(context).colorScheme.errorContainer,
                        child: ListTile(
                          leading: const Icon(Icons.warning_amber),
                          title: Text(l.alerts),
                          subtitle: Text(
                            '${l.failedRefunds}: ${alerts['failedRefunds']} · ${l.failedNotifications}: ${alerts['failedNotifications']}',
                          ),
                          onTap: () => context.push('/admin/payments'),
                        ),
                      ),
                    NavTile(Icons.room_service, l.frontDesk, () => context.push('/admin/desk')),
                    NavTile(Icons.bed, l.roomsAndRates, () => context.push('/admin/rooms')),
                    NavTile(Icons.local_laundry_service, l.services, () => context.push('/admin/services')),
                    NavTile(Icons.restaurant_menu, l.restaurant, () => context.push('/admin/restaurant')),
                    NavTile(Icons.payments, l.payments, () => context.push('/admin/payments')),
                    NavTile(Icons.bar_chart, l.reports, () => context.push('/admin/reports')),
                    NavTile(Icons.badge, l.staffAndLeave, () => context.push('/admin/staff')),
                    NavTile(Icons.loyalty, l.loyalty, () => context.push('/admin/loyalty')),
                    NavTile(Icons.article, l.content, () => context.push('/admin/content')),
                    NavTile(Icons.tune, l.hotelSettings, () => context.push('/admin/hotel')),
                    NavTile(Icons.history, l.auditLog, () => context.push('/admin/audit')),
                  ],
          ),
        ),
      ),
    );
  }

  /// Wide layout: KPI grid and an attention card; the sidebar replaces the menu tiles.
  List<Widget> _wide(BuildContext context, AppLocalizations l, Map<String, dynamic> d, String cur, Map alerts) {
    void go(String p) => context.go(p);
    int n(Object? v) => (v as num?)?.toInt() ?? 0;
    return [
      KpiGrid([
        Kpi(l.occupancyTonight, '${d['occupancy'] ?? 0}%', sub: '${d['roomsSold'] ?? 0}/${d['rooms'] ?? 0}'),
        Kpi(l.collectedToday, money(num2(d['collectedToday']), cur), onTap: () => go('/admin/payments')),
        Kpi(l.refundedToday, money(num2(d['refundedToday']), cur), onTap: () => go('/admin/payments')),
        Kpi(l.netToday, money(num2(d['netToday']), cur), onTap: () => go('/admin/payments')),
        Kpi(l.arrivals, '${d['arrivals'] ?? 0}', onTap: () => go('/admin/desk/reservations')),
        Kpi(l.departures, '${d['departures'] ?? 0}', onTap: () => go('/admin/desk/reservations')),
        Kpi(l.inHouse, '${d['inHouse'] ?? 0}', onTap: () => go('/admin/desk/reservations')),
        Kpi(l.openTasks, '${d['openTasks'] ?? 0}', onTap: () => go('/admin/desk/tasks')),
      ]),
      const SizedBox(height: 16),
      AttentionCard([
        (Icons.pending_actions, l.pendingApproval, n(d['pending']), () => go('/admin/desk/reservations')),
        (Icons.money_off, l.failedRefunds, n(alerts['failedRefunds']), () => go('/admin/payments')),
        // ponytail: no notifications screen yet, so this row is not tappable.
        (Icons.notifications_off_outlined, l.failedNotifications, n(alerts['failedNotifications']), null),
      ]),
    ];
  }
}

// ───────────── A9 payments & refunds ─────────────

class PaymentsScreen extends ConsumerWidget {
  const PaymentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    const path = '/admin/payments';
    num leftOf(J p) => num2(p['amount']) - num2(p['refundedAmount']);
    bool canRefund(J p) =>
        leftOf(p) > 0 && p['status'] != 'PENDING' && p['status'] != 'FAILED' && p['reservationId'] != null;
    Future<void> refund(BuildContext context, J p) async {
      final left = leftOf(p);
      final v = await prompt(
        context,
        l.refund,
        label: '${l.amount} (≤ ${left.toStringAsFixed(2)})',
        number: true,
        initial: left.toStringAsFixed(2),
      );
      final amount = double.tryParse(v ?? '');
      if (amount == null || !context.mounted) return;
      final reason = await prompt(context, l.refund, label: l.reason);
      if (reason == null || reason.length < 3 || !context.mounted) return;
      final ok = await act(
        context,
        () => ref.read(apiProvider).post('/admin/payments/${p['id']}/refunds', {'amount': amount, 'reason': reason}),
        done: l.refunded,
      );
      if (ok) ref.invalidate(getProvider(path));
    }

    return Scaffold(
      appBar: AppBar(title: Text(l.payments)),
      body: JsonList(
        path: path,
        table: JsonTable(
          columns: [l.amount, l.kind, l.status, l.dateLabel, l.refunded],
          cells: (context, p) => [
            money(num2(p['amount']), '${p['currency']}'),
            '${p['kind']}',
            '${p['status']}',
            date(context, DateTime.parse('${p['createdAt']}').toLocal()),
            '${num2(p['refundedAmount']) > 0 ? p['refundedAmount'] : ''}',
          ],
          onTap: (p) {
            if (canRefund(p)) refund(context, p);
          },
        ),
        item: (context, p) {
          final refunds = jsonList(p['refunds']);
          final failed = refunds.where((r) => r['status'] == 'failed').length;
          return ListTile(
            title: Text('${money(num2(p['amount']), '${p['currency']}')} · ${p['kind']} · ${p['status']}'),
            subtitle: Text(
              '${date(context, DateTime.parse('${p['createdAt']}').toLocal())}'
              '${num2(p['refundedAmount']) > 0 ? ' · ${l.refunded}: ${p['refundedAmount']}' : ''}'
              '${failed > 0 ? ' · ${l.failedRefunds}: $failed' : ''}',
            ),
            trailing: canRefund(p) ? TextButton(onPressed: () => refund(context, p), child: Text(l.refund)) : null,
          );
        },
      ),
    );
  }
}

// ───────────── A20 audit ─────────────

class AuditScreen extends StatelessWidget {
  const AuditScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(AppLocalizations.of(context).auditLog)),
    body: JsonList(
      path: '/admin/audit',
      table: JsonTable(
        columns: [
          AppLocalizations.of(context).action,
          AppLocalizations.of(context).entity,
          AppLocalizations.of(context).dateLabel,
          AppLocalizations.of(context).actor,
        ],
        cells: (context, a) => [
          '${a['action']}',
          '${a['entityType']}',
          date(context, DateTime.parse('${a['at']}').toLocal()),
          '${a['actorId'] ?? ''}',
        ],
      ),
      item: (context, a) => ListTile(
        dense: true,
        title: Text('${a['action']} · ${a['entityType']}'),
        subtitle: Text('${date(context, DateTime.parse('${a['at']}').toLocal())} · ${a['actorId'] ?? ''}'),
      ),
    ),
  );
}

// ───────────── A18 reports ─────────────

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});
  @override
  ConsumerState<ReportsScreen> createState() => _ReportsState();
}

class _ReportsState extends ConsumerState<ReportsScreen> {
  String _name = 'occupancy';
  late DateTimeRange _range = () {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return DateTimeRange(start: today.subtract(const Duration(days: 30)), end: today.add(const Duration(days: 1)));
  }();

  String _d(DateTime x) => x.toIso8601String().substring(0, 10);

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final path = '/admin/reports/$_name?from=${_d(_range.start)}&to=${_d(_range.end)}';
    final names = {
      'occupancy': l.reportOccupancy,
      'revenue': l.reportRevenue,
      'bookings': l.reservations,
      'services': l.services,
      'restaurant': l.restaurant,
      'loyalty': l.loyalty,
      'feedback': l.feedback,
    };
    return Scaffold(
      appBar: AppBar(
        title: Text(l.reports),
        actions: [
          IconButton(
            tooltip: l.copyCsv,
            icon: const Icon(Icons.copy_all),
            onPressed: () => act(context, () async {
              final csv = await ref.read(apiProvider).get('$path&format=csv');
              await Clipboard.setData(ClipboardData(text: '$csv'));
            }, done: l.copied),
          ),
        ],
      ),
      body: Column(
        children: [
          Wrap(
            spacing: 8,
            children: [
              for (final e in names.entries)
                ChoiceChip(
                  label: Text(e.value),
                  selected: _name == e.key,
                  onSelected: (_) => setState(() => _name = e.key),
                ),
            ],
          ),
          TextButton.icon(
            icon: const Icon(Icons.date_range),
            label: Text(dateRange(context, _range.start, _range.end)),
            onPressed: () async {
              final r = await showDateRangePicker(
                context: context,
                firstDate: DateTime(2024),
                lastDate: DateTime.now().add(const Duration(days: 365)),
                initialDateRange: _range,
              );
              if (r != null) setState(() => _range = r);
            },
          ),
          Expanded(
            child: AsyncBody(
              value: ref.watch(getProvider(path)),
              onRetry: () => ref.invalidate(getProvider(path)),
              builder: (data) {
                final rows = jsonList(data);
                if (rows.isEmpty) return Center(child: Text(l.nothingHere));
                final cols = rows.first.keys.toList();
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    child: DataTable(
                      columns: [for (final c in cols) DataColumn(label: Text(c))],
                      rows: [
                        for (final r in rows) DataRow(cells: [for (final c in cols) DataCell(Text('${r[c]}'))]),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ───────────── A17 content (guides, promotions) ─────────────

class ContentScreen extends ConsumerWidget {
  const ContentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    return Scaffold(
      appBar: AppBar(title: Text(l.content)),
      floatingActionButton: FloatingActionButton(
        tooltip: l.add,
        onPressed: () => context.push('/admin/content/new'),
        child: const Icon(Icons.add),
      ),
      body: JsonList(
        path: '/admin/content',
        item: (context, c) => ListTile(
          title: Text('${(c['title'] as Map)[lang] ?? (c['title'] as Map)['en']}'),
          subtitle: Text('${c['kind']} · ${c['publishedAt'] == null ? l.draft : l.published}'),
          onTap: () => context.push('/admin/content/${c['id']}'),
        ),
      ),
    );
  }
}

class ContentEditScreen extends ConsumerStatefulWidget {
  const ContentEditScreen({super.key, this.item});
  final J? item;
  @override
  ConsumerState<ContentEditScreen> createState() => _ContentEditState();
}

class _ContentEditState extends ConsumerState<ContentEditScreen> {
  late final _title = Tr(widget.item?['title'] as Map?);
  late final _body = Tr(widget.item?['body'] as Map?);
  late String _kind = '${widget.item?['kind'] ?? 'guide'}';
  late bool _published = widget.item?['publishedAt'] != null || widget.item == null;

  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final api = ref.read(apiProvider);
    final id = widget.item?['id'];
    return Scaffold(
      appBar: AppBar(
        title: Text(l.content),
        actions: [
          if (id != null)
            IconButton(
              tooltip: l.delete,
              icon: const Icon(Icons.delete_outline),
              onPressed: () async {
                if (!await confirm(context, l.delete) || !context.mounted) return;
                if (await act(context, () => api.delete('/admin/content/$id'))) {
                  ref.invalidate(getProvider('/admin/content'));
                  if (context.mounted) popOr(context, '/admin/content');
                }
              },
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          DropdownButtonFormField<String>(
            value: _kind,
            decoration: InputDecoration(labelText: l.kind),
            items: [
              for (final k in ['guide', 'promotion', 'banner']) DropdownMenuItem(value: k, child: Text(k)),
            ],
            onChanged: (v) => setState(() => _kind = v!),
          ),
          const SizedBox(height: 8),
          ..._title.fields(l.title),
          ..._body.fields(l.body, maxLines: 4),
          SwitchListTile(title: Text(l.published), value: _published, onChanged: (v) => setState(() => _published = v)),
          BusyButton(
            label: l.save,
            onPressed: () async {
              final body = {
                'kind': _kind,
                'title': _title.value,
                'body': _body.value,
                'publishedAt': _published
                    ? (widget.item?['publishedAt'] ?? DateTime.now().toUtc().toIso8601String())
                    : null,
              };
              final ok = await act(
                context,
                () => id == null ? api.post('/admin/content', body) : api.patch('/admin/content/$id', body),
                done: l.saved,
              );
              if (ok) {
                ref.invalidate(getProvider('/admin/content'));
                if (context.mounted) popOr(context, '/admin/content');
              }
            },
          ),
        ],
      ),
    );
  }
}

// ───────────── A2 hotel settings ─────────────

class HotelSettingsScreen extends ConsumerStatefulWidget {
  const HotelSettingsScreen({super.key});
  @override
  ConsumerState<HotelSettingsScreen> createState() => _HotelSettingsState();
}

class _HotelSettingsState extends ConsumerState<HotelSettingsScreen> {
  J? _h;
  final _c = <String, TextEditingController>{};
  Tr? _cancellation;
  bool _approval = false;

  TextEditingController c(String k) => _c.putIfAbsent(k, TextEditingController.new);

  @override
  void initState() {
    super.initState();
    ref
        .read(apiProvider)
        .get('/admin/hotels/$hotelId')
        .then((v) {
          if (!mounted) return;
          final h = (v as Map).cast<String, dynamic>();
          final p = ((h['policies'] as Map?) ?? {}).cast<String, dynamic>();
          final wifi = (((h['integrations'] as Map?) ?? {})['wifi'] as Map?) ?? {};
          setState(() {
            _h = h;
            c('name').text = '${h['name']}';
            c('taxRate').text = '${num2(h['taxRate']) * 100}';
            c('serviceCharge').text = '${num2(h['serviceCharge']) * 100}';
            c('checkIn').text = '${p['checkIn'] ?? '14:00'}';
            c('checkOut').text = '${p['checkOut'] ?? '12:00'}';
            c('depositPercent').text = '${p['depositPercent'] ?? 100}';
            c('freeCancelHours').text = '${p['freeCancelHours'] ?? 48}';
            c('lateCancelRefundPercent').text = '${p['lateCancelRefundPercent'] ?? 0}';
            c('earnPer100').text = '${(p['loyalty'] as Map?)?['earnPer100'] ?? 1}';
            c('ssid').text = '${wifi['ssid'] ?? ''}';
            c('wifiMode').text = '${wifi['mode'] ?? 'portal'}';
            c('psk').text = '${wifi['psk'] ?? ''}';
            _approval = p['requireApproval'] == true;
            _cancellation = Tr(p['cancellation'] as Map?);
          });
        })
        .catchError((Object e) {
          if (mounted) snack(context, failureText(context, e));
        });
  }

  @override
  void dispose() {
    for (final x in _c.values) {
      x.dispose();
    }
    _cancellation?.dispose();
    super.dispose();
  }

  Widget _f(String key, String label, {bool number = false}) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: TextField(
      controller: c(key),
      keyboardType: number ? const TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
      decoration: InputDecoration(labelText: label),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    if (_h == null)
      return Scaffold(
        appBar: AppBar(title: Text(l.hotelSettings)),
        body: const Center(child: CircularProgressIndicator()),
      );
    double n(String k) => double.tryParse(c(k).text) ?? 0;
    final p = ((_h!['policies'] as Map?) ?? {}).cast<String, dynamic>();
    return Scaffold(
      appBar: AppBar(title: Text(l.hotelSettings)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _f('name', l.hotelName),
          _f('checkIn', l.checkInTime('HH:mm')),
          _f('checkOut', l.checkOutTime('HH:mm')),
          _f('taxRate', '${l.vat} %', number: true),
          _f('serviceCharge', '${l.serviceCharge} %', number: true),
          _f('depositPercent', l.depositPercent, number: true),
          _f('freeCancelHours', l.freeCancelHours, number: true),
          _f('lateCancelRefundPercent', l.lateRefundPercent, number: true),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l.requireApproval),
            value: _approval,
            onChanged: (v) => setState(() => _approval = v),
          ),
          ..._cancellation!.fields(l.cancellationPolicy, maxLines: 3),
          _f('earnPer100', l.earnPer100, number: true),
          const Divider(),
          Text(l.wifi, style: Theme.of(context).textTheme.titleMedium),
          _f('ssid', l.network),
          _f('wifiMode', l.wifiMode),
          _f('psk', l.wifiSharedPassword),
          BusyButton(
            label: l.save,
            onPressed: () => act(
              context,
              () => ref.read(apiProvider).patch('/admin/hotels/$hotelId', {
                'name': c('name').text.trim(),
                'taxRate': n('taxRate') / 100,
                'serviceCharge': n('serviceCharge') / 100,
                'policies': {
                  ...p,
                  'checkIn': c('checkIn').text.trim(),
                  'checkOut': c('checkOut').text.trim(),
                  'depositPercent': n('depositPercent'),
                  'freeCancelHours': n('freeCancelHours'),
                  'lateCancelRefundPercent': n('lateCancelRefundPercent'),
                  'requireApproval': _approval,
                  'cancellation': _cancellation!.value,
                  'loyalty': {...((p['loyalty'] as Map?) ?? {}), 'earnPer100': n('earnPer100')},
                },
                'integrations': {
                  ...(((_h!['integrations'] as Map?) ?? {}).cast<String, dynamic>()),
                  'wifi': {
                    'ssid': c('ssid').text.trim(),
                    'mode': c('wifiMode').text.trim() == 'psk' ? 'psk' : 'portal',
                    if (c('psk').text.trim().isNotEmpty) 'psk': c('psk').text.trim(),
                  },
                },
              }),
              done: l.saved,
            ),
          ),
        ],
      ),
    );
  }
}
