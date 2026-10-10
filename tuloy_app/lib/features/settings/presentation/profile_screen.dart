import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme.dart';
import '../../../core/config.dart';
import '../../../core/format.dart';
import '../../../core/http.dart';
import '../../../core/map.dart';
import '../../../l10n/app_localizations.dart';
import '../../auth/presentation/auth_controller.dart';
import '../../booking/presentation/booking_providers.dart';
import '../../loyalty/loyalty_wifi_screens.dart' show stepLabelOf;
import '../../services/services_screens.dart' show stepLabel;

/// Guest profile: who you are, points, stays, services, payments, getting here, language, sign out.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  static const _loyalty = '/me/loyalty?hotelId=$hotelId';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final c = Theme.of(context).colorScheme;
    final user = ref.watch(authProvider).valueOrNull;
    final hotel = ref.watch(hotelProvider).valueOrNull;
    final loyalty = (ref.watch(getProvider(_loyalty)).valueOrNull as Map?)?.cast<String, dynamic>();
    final requests = ref.watch(getProvider('/me/service-requests')).valueOrNull as List? ?? const [];
    final payments = ref.watch(getProvider('/me/payments')).valueOrNull as List? ?? const [];
    final stays = ref.watch(myBookingsProvider).valueOrNull?.length ?? 0;
    final language = ref.watch(languageProvider);
    final top = MediaQuery.paddingOf(context).top + kToolbarHeight;
    final name = user?.fullName ?? '';
    final initials = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .take(2)
        .map((w) => w[0].toUpperCase())
        .join();

    Future<void> refresh() async {
      ref.invalidate(getProvider(_loyalty));
      ref.invalidate(getProvider('/me/service-requests'));
      ref.invalidate(getProvider('/me/payments'));
      ref.invalidate(myBookingsProvider);
      await ref.read(myBookingsProvider.future);
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: WidgetStateColor.resolveWith(
          (st) => st.contains(WidgetState.scrolledUnder) ? const Color(0xFF0F6E6E) : Colors.transparent,
        ),
        foregroundColor: Colors.white,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: text.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
        title: Text(l.profile),
      ),
      body: RefreshIndicator(
        onRefresh: refresh,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Header: avatar, name, contact on the dusk backdrop; points card overlaps it.
            Stack(
              children: [
                Positioned(top: 0, left: 0, right: 0, height: top + 150, child: const DuskBackdrop()),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, top + 4, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 34,
                            backgroundColor: c.tertiary,
                            foregroundColor: c.onTertiary,
                            child: Text(initials, style: text.titleLarge?.copyWith(color: c.onTertiary)),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(name, style: text.headlineSmall?.copyWith(color: Colors.white)),
                                if (user?.email != null)
                                  Text(user!.email!, style: const TextStyle(color: Colors.white70)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),
                      _PointsCard(loyalty: loyalty, onTap: () => context.push('/guest/loyalty')),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Row(
                children: [
                  _Stat(Icons.hotel_outlined, '$stays', l.stays, () => context.push('/guest/bookings')),
                  const SizedBox(width: 12),
                  _Stat(
                    Icons.room_service_outlined,
                    '${requests.length}',
                    l.servicesUsed,
                    () => context.push('/guest/requests'),
                  ),
                ],
              ),
            ),

            _Header(l.personalDetails),
            _Group([
              ListTile(leading: const Icon(Icons.person_outline), title: Text(name)),
              if (user?.email != null) ListTile(leading: const Icon(Icons.mail_outline), title: Text(user!.email!)),
              if (user?.phone != null) ListTile(leading: const Icon(Icons.phone_outlined), title: Text(user!.phone!)),
            ]),

            _Header(l.paymentHistory),
            _Group([
              if (payments.isEmpty) ListTile(title: Text(l.noneYet)),
              for (final p in payments.take(5).cast<Map>())
                ListTile(
                  leading: const Icon(Icons.credit_card),
                  title: Text(
                    '${money(num2(p['amount']), '${p['currency']}')}'
                    '${p['reservationCode'] != null ? ' · ${p['reservationCode']}' : ''}',
                  ),
                  subtitle: Text(
                    '${p['provider'] == 'mock' ? l.testPayment : l.cardOrEwallet} · '
                    '${date(context, DateTime.parse('${p['createdAt']}').toLocal())}',
                  ),
                  trailing: Text(_paymentStatus(l, '${p['status']}'), style: text.labelMedium),
                ),
            ]),

            _Header(l.servicesUsed, onMore: requests.isEmpty ? null : () => context.push('/guest/requests')),
            _Group([
              if (requests.isEmpty) ListTile(title: Text(l.noneYet)),
              for (final r in requests.take(5).cast<Map>())
                ListTile(
                  leading: const Icon(Icons.room_service_outlined),
                  title: Text('${r['name']}'),
                  subtitle: Text(stepLabel('${r['status']}')),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/guest/requests/${r['id']}'),
                ),
            ]),

            if (hotel?.latitude != null && hotel?.longitude != null) ...[
              _Header(l.gettingHere),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Card(
                  margin: EdgeInsets.zero,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      MapPreview(lat: hotel!.latitude!, lng: hotel.longitude!, label: hotel.name, height: 160),
                      ListTile(
                        leading: const Icon(Icons.place_outlined),
                        title: Text(hotel.name),
                        subtitle: hotel.address == null ? null : Text(hotel.address!),
                        trailing: TextButton(
                          onPressed: () => openMap(hotel.latitude!, hotel.longitude!, hotel.name),
                          child: Text(l.openInMaps),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            _Header(l.language),
            _Group([
              for (final e in supportedLanguages.entries)
                ListTile(
                  title: Text(e.value),
                  trailing: e.key == language ? const Icon(Icons.check) : null,
                  selected: e.key == language,
                  onTap: () => ref.read(authProvider.notifier).setLanguage(e.key),
                ),
            ]),
            const SizedBox(height: 12),
            _Group([
              ListTile(
                leading: Icon(Icons.logout, color: c.error),
                title: Text(l.signOut, style: TextStyle(color: c.error)),
                onTap: () => ref.read(authProvider.notifier).signOut(),
              ),
            ]),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

String _paymentStatus(AppLocalizations l, String s) => switch (s) {
  'SUCCEEDED' => l.paid,
  'PENDING' => l.statusPending,
  'REFUNDED' || 'PARTIALLY_REFUNDED' => l.refunded,
  _ => stepLabel(s.toLowerCase()),
};

class _PointsCard extends StatelessWidget {
  const _PointsCard({required this.loyalty, required this.onTap});
  final Map<String, dynamic>? loyalty;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final c = Theme.of(context).colorScheme;
    final next = loyalty?['next'] as Map?;
    return Material(
      color: c.tertiary,
      elevation: 8,
      shadowColor: c.primary.withValues(alpha: .25),
      shape: const RoundedRectangleBorder(borderRadius: archRadius),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Icon(Icons.loyalty, color: c.onTertiary, size: 32),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l.pointsBalance('${loyalty?['balance'] ?? 0}'),
                      style: text.headlineSmall?.copyWith(color: c.onTertiary),
                    ),
                    if (loyalty != null)
                      Text(l.tier(stepLabelOf('${loyalty!['tier']}')), style: TextStyle(color: c.onTertiary)),
                    if (next != null)
                      Text(
                        l.nextTier('${next['pointsNeeded']}', stepLabelOf('${next['name']}')),
                        style: text.bodySmall?.copyWith(color: c.onTertiary.withValues(alpha: .8)),
                      ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: c.onTertiary),
            ],
          ),
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat(this.icon, this.value, this.label, this.onTap);
  final IconData icon;
  final String value;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Expanded(
      child: Card(
        margin: EdgeInsets.zero,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(value, style: text.titleLarge),
                      Text(label, style: text.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header(this.title, {this.onMore});
  final String title;
  final VoidCallback? onMore;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(24, 24, 8, 8),
    child: Row(
      children: [
        Expanded(child: Text(title, style: Theme.of(context).textTheme.titleMedium)),
        if (onMore != null) IconButton(tooltip: title, icon: const Icon(Icons.arrow_forward), onPressed: onMore),
      ],
    ),
  );
}

/// Rounded white group of list rows.
class _Group extends StatelessWidget {
  const _Group(this.children);
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Card(
      margin: EdgeInsets.zero,
      child: Column(children: children),
    ),
  );
}
