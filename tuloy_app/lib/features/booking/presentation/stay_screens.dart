import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config.dart';
import '../../../core/format.dart';
import '../../../core/http.dart';
import '../../../core/map.dart';
import '../../../core/ui.dart' show act;
import '../../../app/theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../services/services_screens.dart' show priceLabel;
import '../../auth/presentation/auth_controller.dart';
import '../../auth/presentation/widgets.dart';
import '../domain/booking.dart';
import 'booking_providers.dart';

/// Opens (or reuses) the guest's conversation with the hotel and shows it.
Future<void> openHotelChat(BuildContext context, WidgetRef ref, {String? reservationId}) => act(context, () async {
  final c =
      await ref.read(apiProvider).post('/conversations', {
            'hotelId': hotelId,
            if (reservationId != null) 'reservationId': reservationId,
          })
          as Map;
  if (context.mounted) await context.push('/guest/chat/${c['id']}', extra: ref.read(hotelProvider).valueOrNull?.name);
});

// ───────────── G1: guest home ─────────────

class GuestHomeScreen extends ConsumerWidget {
  const GuestHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final c = Theme.of(context).colorScheme;
    final user = ref.watch(authProvider).valueOrNull;
    final hotel = ref.watch(hotelProvider).valueOrNull;
    final q = ref.watch(stayQueryProvider);
    final offers = ref.watch(searchProvider).valueOrNull ?? const <RoomOffer>[];
    final services = ref.watch(getProvider('/hotels/$hotelId/services')).valueOrNull as List? ?? const [];
    final now = DateTime.now();
    final stay = currentStay(
      ref.watch(myBookingsProvider).valueOrNull ?? const [],
      DateTime(now.year, now.month, now.day),
    );
    final top = MediaQuery.paddingOf(context).top + kToolbarHeight;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        // Clear over the header, solid teal once content scrolls under it.
        backgroundColor: WidgetStateColor.resolveWith(
          (st) => st.contains(WidgetState.scrolledUnder) ? const Color(0xFF0F6E6E) : Colors.transparent,
        ),
        foregroundColor: Colors.white,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: text.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
        title: Text(hotel?.name ?? l.appTitle),
        actions: [
          IconButton(
            tooltip: l.profile,
            icon: const Icon(Icons.account_circle_outlined, size: 28),
            onPressed: () => context.push('/guest/profile'),
          ),
        ],
      ),
      // Concierge button: icon only; the tooltip doubles as the screen-reader label.
      floatingActionButton: FloatingActionButton(
        tooltip: l.howCanWeHelp,
        onPressed: () => _helpSheet(context, ref, stay?.id),
        child: const Icon(Icons.support_agent),
      ),
      body: RefreshIndicator(
        onRefresh: () => Future.wait([ref.refresh(myBookingsProvider.future), ref.refresh(searchProvider.future)]),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Stack(
              children: [
                Positioned(top: 0, left: 0, right: 0, height: top + 170, child: const DuskBackdrop()),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, top + 8, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(l.hello(user?.fullName ?? ''), style: text.headlineMedium?.copyWith(color: Colors.white)),
                      const SizedBox(height: 80),
                      _SearchCard(
                        dates: '${dateRange(context, q.checkIn, q.checkOut)} · ${l.nightsCount('${q.nights}')}',
                        guests: '${q.guests} ${l.guests}',
                        action: l.findRoom,
                        onTap: () => context.push('/guest/search'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (stay != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Material(
                  color: c.primary,
                  shape: const RoundedRectangleBorder(borderRadius: archRadius),
                  clipBehavior: Clip.antiAlias,
                  child: ListTile(
                    contentPadding: const EdgeInsets.fromLTRB(20, 12, 16, 12),
                    leading: Icon(Icons.hotel, color: c.onPrimary),
                    title: Text(l.currentStay, style: text.titleMedium?.copyWith(color: c.onPrimary)),
                    subtitle: Text(
                      '${stay.roomTypeName} · ${dateRange(context, stay.checkIn, stay.checkOut)}',
                      style: TextStyle(color: c.onPrimary.withValues(alpha: .8)),
                    ),
                    trailing: Icon(Icons.arrow_forward, color: c.onPrimary),
                    onTap: () => context.push('/guest/stay/${stay.id}'),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 24, 12, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Category(Icons.event_note, l.myBookings, () => context.push('/guest/bookings')),
                  _Category(Icons.room_service, l.services, () => context.push('/guest/services')),
                  _Category(Icons.qr_code_scanner, l.scanTable, () => context.push('/guest/scan')),
                  _Category(Icons.menu_book, l.hotelGuide, () => context.push('/guest/guide')),
                  _Category(Icons.loyalty, l.loyalty, () => context.push('/guest/loyalty')),
                ],
              ),
            ),
            if (offers.isNotEmpty) ...[
              _Section(l.roomsAndRates, () => context.push('/guest/search')),
              SizedBox(
                height: 200,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: offers.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (_, i) => _RoomCard(offers[i]),
                ),
              ),
            ],
            if (services.isNotEmpty) ...[
              _Section(l.services, () => context.push('/guest/services')),
              SizedBox(
                height: 196,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: services.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (_, i) => _ServiceCard(services[i] as J),
                ),
              ),
            ],
            if (hotel?.latitude != null && hotel?.longitude != null) ...[
              _Section(l.gettingHere, () => openMap(hotel!.latitude!, hotel.longitude!, hotel.name)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Card(
                  margin: EdgeInsets.zero,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      MapPreview(lat: hotel!.latitude!, lng: hotel.longitude!, label: hotel.name),
                      ListTile(
                        leading: const Icon(Icons.place_outlined),
                        title: Text(hotel.name),
                        subtitle: hotel.address == null ? null : Text(hotel.address!),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 104), // clears the FAB
          ],
        ),
      ),
    );
  }
}

/// Concierge sheet: things a guest does mid-stay, chat first.
void _helpSheet(BuildContext context, WidgetRef ref, String? stayId) {
  final l = AppLocalizations.of(context);
  final c = Theme.of(context).colorScheme;
  showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (sheet) {
      Widget item(IconData icon, String label, VoidCallback go) => ListTile(
        leading: CircleAvatar(
          backgroundColor: c.tertiaryContainer,
          child: Icon(icon, color: c.onTertiaryContainer),
        ),
        title: Text(label),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          Navigator.pop(sheet);
          go();
        },
      );
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
              child: Text(l.howCanWeHelp, style: Theme.of(sheet).textTheme.titleLarge),
            ),
            item(Icons.chat_bubble_outline, l.chatWithHotel, () => openHotelChat(context, ref, reservationId: stayId)),
            item(Icons.room_service, l.services, () => context.push('/guest/services')),
            item(Icons.qr_code_scanner, l.scanTable, () => context.push('/guest/scan')),
            item(Icons.receipt_long, l.myRequests, () => context.push('/guest/requests')),
            const SizedBox(height: 8),
          ],
        ),
      );
    },
  );
}

class _Section extends StatelessWidget {
  const _Section(this.title, this.onMore);
  final String title;
  final VoidCallback onMore;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 28, 8, 8),
    child: Row(
      children: [
        Expanded(child: Text(title, style: Theme.of(context).textTheme.titleLarge)),
        IconButton(tooltip: title, icon: const Icon(Icons.arrow_forward), onPressed: onMore),
      ],
    ),
  );
}

class _ServiceCard extends StatelessWidget {
  const _ServiceCard(this.s);
  final J s;

  static IconData _icon(String? category) => switch (category) {
    'laundry' => Icons.local_laundry_service_outlined,
    'spa' || 'wellness' => Icons.spa_outlined,
    'transport' || 'airport' => Icons.airport_shuttle_outlined,
    'food' || 'dining' => Icons.restaurant_outlined,
    'housekeeping' => Icons.cleaning_services_outlined,
    'tour' || 'tours' => Icons.tour_outlined,
    _ => Icons.room_service_outlined,
  };

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    return SizedBox(
      width: 180,
      child: Card(
        margin: EdgeInsets.zero,
        child: InkWell(
          onTap: () => context.push('/guest/services/${s['id']}'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RoomArt(name: '${s['category']}', height: 110, icon: _icon(s['category'] as String?)),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
                child: Text('${s['name']}', style: text.titleSmall, maxLines: 2, overflow: TextOverflow.ellipsis),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 4, 14, 0),
                child: Text(
                  priceLabel(l, s),
                  style: text.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Trivago-style search box floating over the header.
class _SearchCard extends StatelessWidget {
  const _SearchCard({required this.dates, required this.guests, required this.action, required this.onTap});
  final String dates;
  final String guests;
  final String action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    Widget field(IconData icon, String value) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(color: c.surfaceContainerHigh, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          Icon(icon, color: c.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(value, style: Theme.of(context).textTheme.titleSmall)),
        ],
      ),
    );
    return Material(
      color: c.surfaceContainerLowest,
      elevation: 10,
      shadowColor: c.primary.withValues(alpha: .25),
      shape: const RoundedRectangleBorder(borderRadius: archRadius),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              field(Icons.calendar_month, dates),
              const SizedBox(height: 8),
              field(Icons.person_outline, guests),
              const SizedBox(height: 12),
              FilledButton.icon(onPressed: onTap, icon: const Icon(Icons.search), label: Text(action)),
            ],
          ),
        ),
      ),
    );
  }
}

class _Category extends StatelessWidget {
  const _Category(this.icon, this.label, this.onTap);
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
          child: Column(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(color: c.tertiaryContainer, borderRadius: BorderRadius.circular(18)),
                child: Icon(icon, color: c.onTertiaryContainer),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoomCard extends StatelessWidget {
  const _RoomCard(this.o);
  final RoomOffer o;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final c = Theme.of(context).colorScheme;
    return SizedBox(
      width: 220,
      child: Card(
        margin: EdgeInsets.zero,
        child: InkWell(
          onTap: () => context.push('/guest/room', extra: o),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RoomArt(
                name: o.name,
                height: 130,
                child: o.roomsLeft <= 3
                    ? Positioned(
                        left: 12,
                        top: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(color: c.errorContainer, borderRadius: BorderRadius.circular(20)),
                          child: Text(
                            l.roomsLeft('${o.roomsLeft}'),
                            style: text.labelSmall?.copyWith(color: c.onErrorContainer),
                          ),
                        ),
                      )
                    : null,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
                child: Text(o.name, style: text.titleMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 4, 14, 0),
                child: Text(
                  l.perNight(money(o.perNight, o.currency)),
                  style: text.titleSmall?.copyWith(color: c.primary, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ───────────── G11: my stay ─────────────

/// Phase 2 scope: dates, room, times, guide, invoice, feedback.
/// Wi-Fi (W-1), services (S-2) and chat (T-4) join this screen in later phases.
class MyStayScreen extends ConsumerWidget {
  const MyStayScreen({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: Text(l.myStay)),
      body: AsyncBody(
        value: ref.watch(reservationProvider(id)),
        onRetry: () => ref.invalidate(reservationProvider(id)),
        builder: (r) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(r.roomTypeName, style: text.titleLarge),
            if (r.room != null) Text(l.roomNumber(r.room!), style: text.titleMedium),
            Text(l.bookingCode(r.code)),
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.login),
              title: Text(date(context, r.checkIn)),
              subtitle: Text(l.checkInTime(r.checkInTime)),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: Text(date(context, r.checkOut)),
              subtitle: Text(l.checkOutTime(r.checkOutTime)),
            ),
            const Divider(),
            if (r.status == BookingStatus.checkedIn)
              ListTile(
                leading: const Icon(Icons.wifi),
                title: Text(l.wifi),
                onTap: () => context.push('/guest/wifi/${r.id}'),
              ),
            ListTile(
              leading: const Icon(Icons.room_service),
              title: Text(l.services),
              onTap: () => context.push('/guest/services'),
            ),
            ListTile(
              leading: const Icon(Icons.qr_code_scanner),
              title: Text(l.scanTable),
              onTap: () => context.push('/guest/scan'),
            ),
            ListTile(
              leading: const Icon(Icons.chat_bubble_outline),
              title: Text(l.chatWithHotel),
              onTap: () => openHotelChat(context, ref, reservationId: r.id),
            ),
            ListTile(
              leading: const Icon(Icons.menu_book),
              title: Text(l.hotelGuide),
              onTap: () => context.push('/guest/guide'),
            ),
            ListTile(
              leading: const Icon(Icons.receipt_long),
              title: Text(l.invoice),
              subtitle: r.balance > 0 ? Text('${l.balance}: ${money(r.balance, r.currency)}') : null,
              onTap: () => context.push('/guest/bookings/${r.id}/invoice'),
            ),
            ListTile(
              leading: const Icon(Icons.rate_review),
              title: Text(l.feedback),
              onTap: () => context.push('/guest/feedback/${r.id}'),
            ),
          ],
        ),
      ),
    );
  }
}

// ───────────── G13: hotel guide ─────────────

class GuideScreen extends ConsumerWidget {
  const GuideScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l.hotelGuide)),
      body: AsyncBody(
        value: ref.watch(guideProvider),
        onRetry: () => ref.invalidate(guideProvider),
        builder: (items) => ListView(
          children: [
            for (final g in items)
              ExpansionTile(
                title: Text(g.title),
                children: [Padding(padding: const EdgeInsets.fromLTRB(16, 0, 16, 16), child: Text(g.body))],
              ),
          ],
        ),
      ),
    );
  }
}

// ───────────── G23: feedback ─────────────

class FeedbackScreen extends ConsumerStatefulWidget {
  const FeedbackScreen({super.key, required this.id});
  final String id;
  @override
  ConsumerState<FeedbackScreen> createState() => _FeedbackState();
}

class _FeedbackState extends ConsumerState<FeedbackScreen> {
  int _rating = 0;
  final _comment = TextEditingController();

  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(bookingRepositoryProvider).feedback(widget.id, _rating, _comment.text);
      messenger.showSnackBar(SnackBar(content: Text(l.thanksFeedback)));
      if (mounted) context.pop();
    } catch (e) {
      if (mounted) messenger.showSnackBar(SnackBar(content: Text(failureText(context, e))));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l.feedback)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(l.rateStay, style: Theme.of(context).textTheme.titleMedium),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 1; i <= 5; i++)
                IconButton(
                  tooltip: '$i/5',
                  iconSize: 36,
                  icon: Icon(i <= _rating ? Icons.star : Icons.star_border),
                  onPressed: () => setState(() => _rating = i),
                ),
            ],
          ),
          TextField(
            controller: _comment,
            maxLines: 4,
            maxLength: 2000,
            decoration: InputDecoration(labelText: l.comment),
          ),
          const SizedBox(height: 8),
          if (_rating > 0) BusyButton(label: l.send, onPressed: _send),
        ],
      ),
    );
  }
}
