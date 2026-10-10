import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/format.dart';
import '../../core/http.dart';
import '../../core/ui.dart';
import '../../l10n/app_localizations.dart';
import '../auth/domain/auth.dart';
import '../auth/presentation/auth_controller.dart';
import '../booking/domain/booking.dart';
import '../booking/presentation/booking_providers.dart';
import '../services/services_screens.dart' show paymentMethodLabel, stepLabel;

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
    return Scaffold(
      appBar: AppBar(
        title: Text(l.staffHome),
        actions: [
          if (base == '/staff')
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
            children: [
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
              NavTile(Icons.event_note, l.reservations, () => context.push('$base/reservations'), badge: n('pending')),
              NavTile(Icons.task_alt, l.tasks, () => context.push('$base/tasks'), badge: n('myTasks')),
              NavTile(Icons.restaurant, l.restaurantOrders, () => context.push('$base/orders'), badge: n('openOrders')),
              NavTile(Icons.chat_bubble_outline, l.chat, () => context.push('$base/inbox'), badge: n('unreadChats')),
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
  const ReservationsQueueScreen({super.key, required this.base});
  final String base;
  @override
  ConsumerState<ReservationsQueueScreen> createState() => _QueueState();
}

class _QueueState extends ConsumerState<ReservationsQueueScreen> {
  String _view = 'upcoming';
  String _q = '';

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
    return Scaffold(
      appBar: AppBar(title: Text(l.reservations)),
      body: Column(
        children: [
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
                columns: [l.name, l.codeLabel, l.roomTypeLabel, l.roomLabel, l.dates, l.status],
                cells: (context, r) => [
                  '${r['guestName']}',
                  '${r['code']}',
                  '${r['roomType']}',
                  '${r['room'] ?? ''}',
                  dateRange(context, DateTime.parse('${r['checkIn']}'), DateTime.parse('${r['checkOut']}')),
                  statusLabel(l, parseStatus('${r['status']}')),
                ],
                onTap: (r) => context.push('${widget.base}/reservations/${r['id']}'),
              ),
              item: (context, r) => ListTile(
                title: Text('${r['guestName']} · ${r['code']}'),
                subtitle: Text(
                  '${r['roomType']}${r['room'] != null ? ' · ${l.roomNumber('${r['room']}')}' : ''}\n'
                  '${dateRange(context, DateTime.parse('${r['checkIn']}'), DateTime.parse('${r['checkOut']}'))}',
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
  const StaffReservationScreen({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final path = '/staff/reservations/$id';
    final api = ref.read(apiProvider);
    Future<void> run(String action, [Object? body]) async {
      if (await act(context, () => api.post('$path/$action', body))) ref.invalidate(getProvider(path));
    }

    return Scaffold(
      appBar: AppBar(title: Text(l.reservation)),
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
                  if (await act(context, () => api.patch('$path/notes', {'internalNotes': v})))
                    ref.invalidate(getProvider(path));
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
      appBar: AppBar(title: Text(l.tasks)),
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
      if (await act(context, () => api.post('$path/$id/status', {'to': to, if (reason != null) 'reason': reason})))
        ref.invalidate(getProvider(path));
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
  const InboxScreen({super.key, required this.base});
  final String base;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    const path = '/staff/conversations';
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
          final now = DateTime.now();
          final range = await showDateRangePicker(
            context: context,
            firstDate: now,
            lastDate: now.add(const Duration(days: 365)),
          );
          if (range == null || !context.mounted) return;
          final reason = await prompt(context, l.applyLeave, label: l.reason);
          if (reason == null || !context.mounted) return;
          String d(DateTime x) => x.toIso8601String().substring(0, 10);
          final ok = await act(
            context,
            () => ref.read(apiProvider).post(path, {
              'from': d(range.start),
              'to': d(range.end),
              'type': 'vacation',
              if (reason.isNotEmpty) 'reason': reason,
            }),
          );
          if (ok) ref.invalidate(getProvider(path));
        },
      ),
      body: JsonList(
        path: path,
        item: (context, r) => ListTile(
          title: Text(dateRange(context, DateTime.parse('${r['from']}'), DateTime.parse('${r['to']}'))),
          subtitle: Text('${r['reason'] ?? ''}'),
          trailing: Chip(label: Text(leaveStatus(l, '${r['status']}'))),
        ),
      ),
    );
  }
}

String leaveStatus(AppLocalizations l, String s) => switch (s) {
  'approved' => l.approved,
  'rejected' => l.rejected,
  _ => l.statusPending,
};
