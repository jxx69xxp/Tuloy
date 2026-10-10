import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../core/format.dart';
import '../../core/http.dart';
import '../../core/ui.dart';
import '../../l10n/app_localizations.dart';
import '../auth/presentation/auth_controller.dart';
import '../booking/domain/booking.dart';
import '../services/services_screens.dart' show currentStayOf, stepLabel;

const _qrPrefix = 'tuloy://table/';

// ───────────── G17 scan ─────────────

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});
  @override
  State<ScanScreen> createState() => _ScanState();
}

class _ScanState extends State<ScanScreen> {
  bool _done = false;

  void _open(String raw) {
    if (_done) return;
    final token = raw.startsWith(_qrPrefix) ? raw.substring(_qrPrefix.length) : raw;
    if (!RegExp(r'^[A-Za-z0-9_-]{20,100}$').hasMatch(token)) return;
    _done = true;
    context.pushReplacement('/guest/menu/$token');
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l.scanTable)),
      body: Column(
        children: [
          Expanded(
            child: MobileScanner(
              onDetect: (capture) {
                for (final b in capture.barcodes) {
                  if (b.rawValue != null) _open(b.rawValue!);
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(l.scanTableHint, textAlign: TextAlign.center),
          ),
          TextButton(
            onPressed: () async {
              final v = await prompt(context, l.enterCode);
              if (v != null && v.isNotEmpty) _open(v);
            },
            child: Text(l.enterCode),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

// ───────────── G18/G19 menu, cart, explicit submit ─────────────

class MenuScreen extends ConsumerStatefulWidget {
  const MenuScreen({super.key, required this.token});
  final String token;
  @override
  ConsumerState<MenuScreen> createState() => _MenuState();
}

class _MenuState extends ConsumerState<MenuScreen> {
  final _cart = <String, int>{};

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return AsyncBody(
      value: ref.watch(getProvider('/qr/${widget.token}')),
      onRetry: () => ref.invalidate(getProvider('/qr/${widget.token}')),
      builder: (data) {
        final m = (data as Map).cast<String, dynamic>();
        final items = jsonList(m['items']);
        final cur = '${m['currency']}';
        final count = _cart.values.fold(0, (a, b) => a + b);
        final subtotal = items.fold(0.0, (s, i) => s + num2(i['price']) * (_cart[i['id']] ?? 0));
        final byCategory = <String, List<J>>{};
        for (final i in items) {
          byCategory.putIfAbsent('${i['category']}', () => []).add(i);
        }
        return Scaffold(
          appBar: AppBar(title: Text('${m['outlet']['name']}')),
          body: ListView(
            children: [
              // Table shown big so a wrong scan is obvious before ordering.
              Container(
                padding: const EdgeInsets.all(12),
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Text(
                  l.tableLabel('${m['table']['label']}'),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              for (final e in byCategory.entries) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                  child: Text(e.key, style: Theme.of(context).textTheme.titleMedium),
                ),
                for (final i in e.value)
                  ListTile(
                    title: Text('${i['name']}'),
                    subtitle: Text(
                      [
                        money(num2(i['price']), cur),
                        if ((i['allergens'] as List).isNotEmpty)
                          '${l.allergens}: ${(i['allergens'] as List).join(', ')}',
                      ].join(' · '),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if ((_cart[i['id']] ?? 0) > 0) ...[
                          IconButton(
                            tooltip: '−',
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed: () => setState(() => _cart.update('${i['id']}', (q) => q - 1)),
                          ),
                          Text('${_cart[i['id']]}'),
                        ],
                        IconButton(
                          tooltip: '+',
                          icon: const Icon(Icons.add_circle_outline),
                          onPressed: () => setState(() => _cart.update('${i['id']}', (q) => q + 1, ifAbsent: () => 1)),
                        ),
                      ],
                    ),
                  ),
              ],
              const SizedBox(height: 80),
            ],
          ),
          bottomNavigationBar: count == 0
              ? null
              : SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: FilledButton(
                      onPressed: () => showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (_) => _CartSheet(
                          token: widget.token,
                          menu: m,
                          cart: Map.of(_cart)..removeWhere((_, q) => q <= 0),
                        ),
                      ),
                      child: Text(l.reviewOrder('$count', money(subtotal, cur))),
                    ),
                  ),
                ),
        );
      },
    );
  }
}

class _CartSheet extends ConsumerStatefulWidget {
  const _CartSheet({required this.token, required this.menu, required this.cart});
  final String token;
  final J menu;
  final Map<String, int> cart;
  @override
  ConsumerState<_CartSheet> createState() => _CartSheetState();
}

class _CartSheetState extends ConsumerState<_CartSheet> {
  final _allergy = TextEditingController();
  String _method = 'PAY_AT_OUTLET';

  @override
  void dispose() {
    _allergy.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final stay = currentStayOf(ref);
    final inHouse = stay?.status == BookingStatus.checkedIn;
    final items = jsonList(widget.menu['items']);
    final cur = '${widget.menu['currency']}';
    final subtotal = items.fold(0.0, (s, i) => s + num2(i['price']) * (widget.cart[i['id']] ?? 0));
    final sc = (subtotal * num2(widget.menu['serviceChargeRate']) * 100).round() / 100;
    final tax = ((subtotal + sc) * num2(widget.menu['taxRate']) * 100).round() / 100;
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l.tableLabel('${widget.menu['table']['label']}'), style: Theme.of(context).textTheme.titleLarge),
            for (final i in items.where((i) => widget.cart.containsKey(i['id'])))
              KV('${widget.cart[i['id']]} × ${i['name']}', money(num2(i['price']) * widget.cart[i['id']]!, cur)),
            const Divider(),
            if (sc > 0) KV(l.serviceCharge, money(sc, cur)),
            if (tax > 0) KV(l.vat, money(tax, cur)),
            KV(l.totalLabel, money(subtotal + sc + tax, cur)),
            const SizedBox(height: 8),
            TextField(
              controller: _allergy,
              maxLength: 500,
              decoration: InputDecoration(labelText: l.allergyNotes),
            ),
            RadioGroupFallback(
              value: _method,
              options: {'PAY_AT_OUTLET': l.payAtOutlet, if (inHouse) 'ROOM_CHARGE': l.chargeToRoom},
              onChanged: (v) => setState(() => _method = v),
            ),
            const SizedBox(height: 8),
            // Explicit submit: nothing reaches the kitchen until this is tapped.
            BusyButton(
              label: l.submitOrder,
              onPressed: () async {
                try {
                  final o =
                      await ref.read(apiProvider).post('/restaurant-orders', {
                            'token': widget.token,
                            'items': [
                              for (final e in widget.cart.entries) {'menuItemId': e.key, 'qty': e.value},
                            ],
                            if (_allergy.text.trim().isNotEmpty) 'allergyNotes': _allergy.text.trim(),
                            'paymentMethod': _method,
                            if (_method == 'ROOM_CHARGE') 'reservationId': stay!.id,
                          }, true)
                          as Map;
                  if (!context.mounted) return;
                  Navigator.pop(context);
                  context.pushReplacement('/guest/orders/${o['id']}');
                } catch (e) {
                  if (context.mounted) snack(context, failureText(context, e));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Simple choice list (avoids Radio APIs that changed across Flutter versions).
class RadioGroupFallback extends StatelessWidget {
  const RadioGroupFallback({super.key, required this.value, required this.options, required this.onChanged});
  final String value;
  final Map<String, String> options;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      for (final e in options.entries)
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(e.key == value ? Icons.radio_button_checked : Icons.radio_button_unchecked),
          title: Text(e.value),
          onTap: () => onChanged(e.key),
        ),
    ],
  );
}

// ───────────── G20 order status ─────────────

class OrderStatusScreen extends ConsumerWidget {
  const OrderStatusScreen({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final path = '/restaurant-orders/$id';
    const steps = ['submitted', 'accepted', 'preparing', 'served'];
    final lang = ref.watch(languageProvider) ?? 'en';
    return Scaffold(
      appBar: AppBar(title: Text(l.orderStatus)),
      body: Poller(
        every: const Duration(seconds: 5),
        onTick: () => ref.invalidate(getProvider(path)),
        child: AsyncBody(
          value: ref.watch(getProvider(path)),
          onRetry: () => ref.invalidate(getProvider(path)),
          builder: (data) {
            final o = (data as Map).cast<String, dynamic>();
            final at = steps.indexOf('${o['status']}');
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                for (final i in jsonList(o['items']))
                  KV('${i['qty']} × ${(i['name'] as Map)[lang] ?? (i['name'] as Map)['en']}', ''),
                KV(l.totalLabel, '${o['total']}'),
                const Divider(),
                if (o['status'] == 'cancelled')
                  ListTile(leading: const Icon(Icons.cancel), title: Text(l.statusCancelled)),
                for (var i = 0; i < steps.length; i++)
                  ListTile(
                    dense: true,
                    leading: Icon(
                      i <= at ? Icons.check_circle : Icons.radio_button_unchecked,
                      color: i <= at ? Theme.of(context).colorScheme.primary : null,
                    ),
                    title: Text(stepLabel(steps[i])),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
