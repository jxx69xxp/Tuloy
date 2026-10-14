import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../core/config.dart';
import '../../core/format.dart';
import '../../core/http.dart';
import '../../core/ui.dart';
import '../../l10n/app_localizations.dart';
import '../booking/domain/booking.dart';
import '../services/services_screens.dart' show currentStayOf;

// ───────────── G22 loyalty ─────────────

class LoyaltyScreen extends ConsumerWidget {
  const LoyaltyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final path = '/me/loyalty?hotelId=$hotelId';
    final stay = currentStayOf(ref);
    final text = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: Text(l.loyalty)),
      body: AsyncBody(
        value: ref.watch(getProvider(path)),
        onRetry: () => ref.invalidate(getProvider(path)),
        builder: (data) {
          final d = (data as Map).cast<String, dynamic>();
          final next = d['next'] as Map?;
          final canRedeem =
              stay != null && (stay.status == BookingStatus.confirmed || stay.status == BookingStatus.checkedIn);
          final muted = text.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant);
          final history = jsonList(d['history']);
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            children: [
              Text(l.pointsBalance('${d['balance']}'), style: text.headlineMedium),
              const SizedBox(height: 4),
              Text(l.tier(stepLabelOf('${d['tier']}'))),
              if (next != null)
                Text(l.nextTier('${next['pointsNeeded']}', stepLabelOf('${next['name']}')), style: muted),
              Text(l.earnRate('${d['earnPer100']}'), style: muted),
              SectionHeader(l.rewards, gutter: 0),
              Section(gutter: 0, [
                for (final r in jsonList(d['rewards']))
                  ListTile(
                    title: Text('${r['name']}'),
                    subtitle: Text(l.pointsCost('${r['points']}')),
                    trailing: canRedeem && (d['balance'] as num) >= (r['points'] as num)
                        ? TextButton(
                            onPressed: () async {
                              if (!await confirm(context, l.redeem, '${r['name']}')) return;
                              if (!context.mounted) return;
                              final ok = await act(
                                context,
                                () => ref.read(apiProvider).post('/me/loyalty/redeem', {
                                  'rewardId': r['id'],
                                  'reservationId': stay.id,
                                }),
                                done: l.redeemed,
                              );
                              if (ok) ref.invalidate(getProvider(path));
                            },
                            child: Text(l.redeem),
                          )
                        : null,
                  ),
              ]),
              if (!canRedeem)
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 8, 4, 0),
                  child: Text(l.redeemNeedsStay, style: text.bodySmall),
                ),
              SectionHeader(l.history, gutter: 0),
              Section(gutter: 0, [
                if (history.isEmpty) ListTile(title: Text(l.nothingHere, style: muted)),
                for (final h in history)
                  ListTile(
                    title: Text(stepLabelOf('${h['kind']}')),
                    subtitle: Text(date(context, DateTime.parse('${h['createdAt']}').toLocal())),
                    trailing: Text('${h['points']}', style: text.titleMedium),
                  ),
              ]),
            ],
          );
        },
      ),
    );
  }
}

String stepLabelOf(String s) => s.isEmpty ? s : s[0].toUpperCase() + s.substring(1).replaceAll('_', ' ');

// ───────────── G12 Wi-Fi ─────────────

class WifiScreen extends ConsumerWidget {
  const WifiScreen({super.key, required this.reservationId});
  final String reservationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final path = '/reservations/$reservationId/wifi';
    return Scaffold(
      appBar: AppBar(title: Text(l.wifi)),
      body: AsyncBody(
        value: ref.watch(getProvider(path)),
        onRetry: () => ref.invalidate(getProvider(path)),
        builder: (data) {
          final w = (data as Map).cast<String, dynamic>();
          final until = DateTime.parse('${w['validUntil']}').toLocal();
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            children: [
              Section(gutter: 0, [
                if (w['ssid'] != null) CopyRow(l.network, '${w['ssid']}'),
                if (w['username'] != null) CopyRow(l.username, '${w['username']}'),
                CopyRow(l.password, '${w['password']}'),
                ListTile(
                  title: Text('${date(context, until)} ${TimeOfDay.fromDateTime(until).format(context)}'),
                  subtitle: Text(l.validUntil),
                ),
              ]),
              const SizedBox(height: 24),
              if (w['joinQr'] != null) ...[
                Center(
                  child: QrImageView(data: '${w['joinQr']}', size: 200, backgroundColor: Colors.white),
                ),
                Text(l.wifiQrHint, textAlign: TextAlign.center),
              ] else
                Text(l.wifiPortalHint, textAlign: TextAlign.center),
            ],
          );
        },
      ),
    );
  }
}
