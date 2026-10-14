import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/config.dart';
import '../../core/format.dart';
import '../../core/http.dart';
import '../../core/map.dart';
import '../../core/ui.dart';
import '../../l10n/app_localizations.dart';
import '../booking/domain/booking.dart';
import '../booking/presentation/booking_providers.dart';

/// Guest's current stay (for room charge and context), or null.
ReservationSummary? currentStayOf(WidgetRef ref) {
  final now = DateTime.now();
  return currentStay(ref.watch(myBookingsProvider).valueOrNull ?? const [], DateTime(now.year, now.month, now.day));
}

String priceLabel(AppLocalizations l, J s) {
  final cur = '${s['currency'] ?? 'PHP'}';
  return switch (s['priceModel']) {
    'QUOTE' => l.priceOnQuote,
    'PER_ITEM' => l.pricePerItem(money(num2(s['basePrice']), cur)),
    'PER_PERSON' => l.pricePerPerson(money(num2(s['basePrice']), cur)),
    'PER_NIGHT' => l.pricePerNight2(money(num2(s['basePrice']), cur)),
    _ => money(num2(s['basePrice']), cur),
  };
}

// ───────────── G14 catalog ─────────────

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l.services),
        actions: [TextButton(onPressed: () => context.push('/guest/requests'), child: Text(l.myRequests))],
      ),
      body: JsonList(
        path: '/hotels/$hotelId/services',
        item: (context, s) => Card(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
          child: ListTile(
            title: Text('${s['name']}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${s['description']}', maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 6),
                Text(
                  priceLabel(l, s),
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Theme.of(context).colorScheme.primary),
                ),
              ],
            ),
            isThreeLine: true,
            onTap: () => context.push('/guest/services/${s['id']}'),
          ),
        ),
      ),
    );
  }
}

// ───────────── G15 detail + dynamic form ─────────────

class ServiceRequestScreen extends ConsumerStatefulWidget {
  const ServiceRequestScreen({super.key, required this.id});
  final String id;
  @override
  ConsumerState<ServiceRequestScreen> createState() => _ServiceRequestState();
}

class _ServiceRequestState extends ConsumerState<ServiceRequestScreen> {
  final _answers = <String, dynamic>{};
  final _options = <String>{};
  DateTime? _when;
  String? _method;

  Future<void> _pickWhen() async {
    final now = DateTime.now();
    final d = await showDatePicker(
      context: context,
      firstDate: now,
      lastDate: now.add(const Duration(days: 60)),
      initialDate: now,
    );
    if (d == null || !mounted) return;
    final t = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(now.add(const Duration(hours: 1))),
    );
    if (t == null) return;
    setState(() => _when = DateTime(d.year, d.month, d.day, t.hour, t.minute));
  }

  Future<void> _submit(J s, ReservationSummary? stay) async {
    final l = AppLocalizations.of(context);
    for (final f in jsonList(s['fields'])) {
      if (f['required'] == true && (_answers[f['key']] == null || _answers[f['key']] == '')) {
        snack(context, '${l.required}: ${f['label']}');
        return;
      }
    }
    try {
      final r =
          await ref.read(apiProvider).post('/service-requests', {
                'serviceId': widget.id,
                if (stay != null) 'reservationId': stay.id,
                'optionIds': _options.toList(),
                'answers': _answers,
                if (_when != null) 'scheduledFor': _when!.toUtc().toIso8601String(),
                'paymentMethod': _method,
              }, true)
              as Map;
      if (mounted) context.pushReplacement('/guest/requests/${r['id']}');
    } catch (e) {
      if (mounted) snack(context, failureText(context, e));
    }
  }

  Widget _field(J f) {
    final key = '${f['key']}';
    final label = '${f['label']}${f['required'] == true ? ' *' : ''}';
    switch (f['type']) {
      case 'number':
        return TextField(
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(labelText: label),
          onChanged: (v) => _answers[key] = num.tryParse(v),
        );
      case 'checkbox':
        return SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(label),
          value: _answers[key] == true,
          onChanged: (v) => setState(() => _answers[key] = v),
        );
      case 'select':
        return DropdownButtonFormField<String>(
          decoration: InputDecoration(labelText: label),
          items: [
            for (final o in jsonList(f['options']))
              DropdownMenuItem(value: '${o['value']}', child: Text('${o['label']}')),
          ],
          onChanged: (v) => _answers[key] = v,
        );
      case 'datetime':
        final v = _answers[key] as String?;
        return _PickerField(
          label: label,
          value: v == null
              ? null
              : '${date(context, DateTime.parse(v))} ${TimeOfDay.fromDateTime(DateTime.parse(v).toLocal()).format(context)}',
          icon: Icons.event,
          onTap: () async {
            await _pickWhen();
            if (_when != null) setState(() => _answers[key] = _when!.toUtc().toIso8601String());
          },
        );
      default: // text, location; file uploads arrive with guest photo support
        return TextField(
          decoration: InputDecoration(labelText: label),
          minLines: 1,
          maxLines: f['type'] == 'text' ? 3 : 1,
          onChanged: (v) => _answers[key] = v,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final stay = currentStayOf(ref);
    final hotel = ref.watch(hotelProvider).valueOrNull;
    return Scaffold(
      appBar: AppBar(title: Text(l.services)),
      body: AsyncBody(
        value: ref.watch(getProvider('/services/${widget.id}')),
        onRetry: () => ref.invalidate(getProvider('/services/${widget.id}')),
        builder: (data) {
          final s = (data as Map).cast<String, dynamic>();
          final methods = (s['paymentMethods'] as List)
              .cast<String>()
              .where((m) => m != 'ROOM_CHARGE' || stay?.status == BookingStatus.checkedIn)
              .toList();
          _method ??= methods.isEmpty ? null : methods.first;
          final t = Theme.of(context);
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            children: [
              Text('${s['name']}', style: t.textTheme.titleLarge),
              const SizedBox(height: 4),
              Text(priceLabel(l, s), style: t.textTheme.titleSmall?.copyWith(color: t.colorScheme.primary)),
              if (s['etaMin'] != null)
                Text(
                  l.etaMinutes('${s['etaMin']}'),
                  style: t.textTheme.bodyMedium?.copyWith(color: t.colorScheme.onSurfaceVariant),
                ),
              const SizedBox(height: 12),
              Text('${s['description']}'),
              if (s['instructions'] != null) Text('${s['instructions']}', style: Theme.of(context).textTheme.bodySmall),
              if (const {'airport', 'transport'}.contains(s['category']) && hotel?.latitude != null) ...[
                const SizedBox(height: 12),
                Card(
                  margin: EdgeInsets.zero,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      MapPreview(
                        lat: hotel!.latitude!,
                        lng: hotel.longitude!,
                        label: hotel.name,
                        height: 150,
                        zoom: 12,
                      ),
                      ListTile(
                        leading: const Icon(Icons.flight_takeoff),
                        title: Text(l.airportRoute),
                        trailing: const Icon(Icons.open_in_new),
                        // ponytail: "airport" lets the maps app pick the nearest one; store the airport per hotel if that guesses wrong.
                        onTap: () => openDirections(hotel.latitude!, hotel.longitude!, 'airport'),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 24),
              for (final o in jsonList(s['options']))
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('${o['name']}'),
                  subtitle: Text('+ ${money(num2(o['priceDelta']), '${s['currency']}')}'),
                  value: _options.contains(o['id']),
                  onChanged: (v) => setState(() => v == true ? _options.add('${o['id']}') : _options.remove(o['id'])),
                ),
              for (final f in jsonList(s['fields']))
                Padding(padding: const EdgeInsets.only(bottom: 12), child: _field(f)),
              _PickerField(
                label: l.preferredTime,
                value: _when == null
                    ? l.asSoonAsPossible
                    : '${date(context, _when!)} ${TimeOfDay.fromDateTime(_when!).format(context)}',
                icon: Icons.schedule,
                onTap: _pickWhen,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _method,
                decoration: InputDecoration(labelText: l.paymentMethod),
                items: [for (final m in methods) DropdownMenuItem(value: m, child: Text(paymentMethodLabel(l, m)))],
                onChanged: (v) => setState(() => _method = v),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 8, 4, 24),
                child: Text(
                  '${s['cancellationPolicy']}',
                  style: t.textTheme.bodySmall?.copyWith(color: t.colorScheme.onSurfaceVariant),
                ),
              ),
              if (_method != null) BusyButton(label: l.sendRequest, onPressed: () => _submit(s, stay)),
            ],
          );
        },
      ),
    );
  }
}

/// Tappable field that opens a picker; looks like the text fields around it.
class _PickerField extends StatelessWidget {
  const _PickerField({required this.label, required this.value, required this.icon, required this.onTap});
  final String label;
  final String? value;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(14),
    child: InputDecorator(
      isEmpty: value == null,
      decoration: InputDecoration(labelText: label, suffixIcon: Icon(icon)),
      child: Text(value ?? ''),
    ),
  );
}

String paymentMethodLabel(AppLocalizations l, String m) => switch (m) {
  'ONLINE' => l.payOnline,
  'ROOM_CHARGE' => l.chargeToRoom,
  'PAY_AT_OUTLET' => l.payAtOutlet,
  _ => l.free,
};

/// Steps like "picked_up" → "Picked up". Hotel-defined, so not translated here.
String stepLabel(String s) => s.isEmpty ? s : s[0].toUpperCase() + s.substring(1).replaceAll('_', ' ');

// ───────────── my requests + G16 status ─────────────

class MyRequestsScreen extends StatelessWidget {
  const MyRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(AppLocalizations.of(context).myRequests)),
    body: JsonList(
      path: '/me/service-requests',
      item: (context, r) => ListTile(
        title: Text('${r['name']}'),
        subtitle: Text(stepLabel('${r['status']}')),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => context.push('/guest/requests/${r['id']}'),
      ),
    ),
  );
}

class RequestStatusScreen extends ConsumerWidget {
  const RequestStatusScreen({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final path = '/service-requests/$id';
    final api = ref.read(apiProvider);
    final cur = ref.watch(hotelProvider).valueOrNull?.currency ?? 'PHP';
    void refresh() => ref.invalidate(getProvider(path));
    return Scaffold(
      appBar: AppBar(title: Text(l.requestStatus)),
      body: Poller(
        every: const Duration(seconds: 5),
        onTick: refresh,
        child: AsyncBody(
          value: ref.watch(getProvider(path)),
          onRetry: refresh,
          builder: (data) {
            final r = (data as Map).cast<String, dynamic>();
            final steps = (r['steps'] as List).cast<String>();
            final cancelled = r['status'] == 'cancelled';
            final at = steps.indexOf('${r['status']}');
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text('${r['name']}', style: Theme.of(context).textTheme.titleLarge),
                if ((r['options'] as List).isNotEmpty) Text((r['options'] as List).join(', ')),
                if (r['total'] != null) KV(l.totalLabel, money(num2(r['total']), cur)),
                KV(l.paymentMethod, paymentMethodLabel(l, '${r['paymentMethod']}')),
                if (r['paid'] == true) KV(l.paid, '✓'),
                const Divider(),
                if (cancelled) ListTile(leading: const Icon(Icons.cancel), title: Text(l.statusCancelled)),
                for (var i = 0; i < steps.length; i++)
                  ListTile(
                    dense: true,
                    leading: Icon(
                      i <= at ? Icons.check_circle : Icons.radio_button_unchecked,
                      color: i <= at ? Theme.of(context).colorScheme.primary : null,
                    ),
                    title: Text(stepLabel(steps[i])),
                  ),
                const SizedBox(height: 16),
                if (r['needsQuoteAcceptance'] == true)
                  BusyButton(
                    label: l.acceptQuote(money(num2(r['total']), cur)),
                    onPressed: () async {
                      if (await act(context, () => api.post('$path/accept-quote'))) refresh();
                    },
                  ),
                if (r['paymentMethod'] == 'ONLINE' && r['paid'] != true && r['total'] != null && !cancelled)
                  BusyButton(
                    label: l.payFull(money(num2(r['total']), cur)),
                    onPressed: () => act(context, () async {
                      final p = await api.post('$path/pay', null, true) as Map;
                      await launchUrl(Uri.parse('${p['checkoutUrl']}'), mode: LaunchMode.inAppBrowserView);
                    }),
                  ),
                if (!cancelled && at <= 1)
                  TextButton(
                    onPressed: () async {
                      if (await confirm(context, l.cancelRequest, '${r['cancellationPolicy']}') && context.mounted) {
                        if (await act(context, () => api.post('$path/cancel'))) refresh();
                      }
                    },
                    child: Text(l.cancelRequest),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
