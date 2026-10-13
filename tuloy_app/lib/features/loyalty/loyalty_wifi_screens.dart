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
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(l.pointsBalance('${d['balance']}'), style: text.headlineMedium),
              Text(l.tier(stepLabelOf('${d['tier']}'))),
              if (next != null) Text(l.nextTier('${next['pointsNeeded']}', stepLabelOf('${next['name']}'))),
              Text(l.earnRate('${d['earnPer100']}'), style: text.bodySmall),
              const Divider(),
              Text(l.rewards, style: text.titleMedium),
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
              if (!canRedeem) Text(l.redeemNeedsStay, style: text.bodySmall),
              const Divider(),
              Text(l.history, style: text.titleMedium),
              for (final h in jsonList(d['history']))
                KV(
                  '${stepLabelOf('${h['kind']}')} · ${date(context, DateTime.parse('${h['createdAt']}').toLocal())}',
                  '${h['points']}',
                ),
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
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (w['ssid'] != null) CopyRow(l.network, '${w['ssid']}'),
              if (w['username'] != null) CopyRow(l.username, '${w['username']}'),
              CopyRow(l.password, '${w['password']}'),
              KV(
                l.validUntil,
                '${date(context, DateTime.parse('${w['validUntil']}').toLocal())} '
                '${TimeOfDay.fromDateTime(DateTime.parse('${w['validUntil']}').toLocal()).format(context)}',
              ),
              const SizedBox(height: 16),
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
