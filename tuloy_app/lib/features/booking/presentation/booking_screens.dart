import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/format.dart';
import '../../../app/theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../auth/presentation/widgets.dart';
import '../domain/booking.dart';
import 'booking_providers.dart';

void _snack(BuildContext context, String text) =>
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

// ───────────── G2 + G3: search and results ─────────────

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final q = ref.watch(stayQueryProvider);
    final results = ref.watch(searchProvider);
    void update(StayQuery next) => ref.read(stayQueryProvider.notifier).state = next;

    return Scaffold(
      appBar: AppBar(title: Text(l.findRoom)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Column(
              children: [
                OutlinedButton.icon(
                  icon: const Icon(Icons.calendar_month),
                  label: Text('${dateRange(context, q.checkIn, q.checkOut)} · ${l.nightsCount('${q.nights}')}'),
                  onPressed: () async {
                    final now = DateTime.now();
                    final picked = await showDateRangePicker(
                      context: context,
                      firstDate: DateTime(now.year, now.month, now.day),
                      lastDate: now.add(const Duration(days: 365)),
                      initialDateRange: DateTimeRange(start: q.checkIn, end: q.checkOut),
                    );
                    if (picked != null && picked.duration.inDays > 0) {
                      update(q.copyWith(checkIn: picked.start, checkOut: picked.end));
                    }
                  },
                ),
                _Stepper(
                  label: l.adults,
                  value: q.adults,
                  min: 1,
                  onChanged: (v) => update(q.copyWith(adults: v)),
                ),
                _Stepper(
                  label: l.children,
                  value: q.children,
                  min: 0,
                  onChanged: (v) => update(q.copyWith(children: v)),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: AsyncBody(
              value: results,
              onRetry: () => ref.invalidate(searchProvider),
              builder: (offers) => offers.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(l.noRooms, textAlign: TextAlign.center),
                      ),
                    )
                  : ListView.builder(itemCount: offers.length, itemBuilder: (_, i) => _OfferCard(offers[i])),
            ),
          ),
        ],
      ),
    );
  }
}

class _Stepper extends StatelessWidget {
  const _Stepper({required this.label, required this.value, required this.min, required this.onChanged});
  final String label;
  final int value;
  final int min;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(child: Text(label)),
      IconButton(
        tooltip: '−',
        onPressed: value > min ? () => onChanged(value - 1) : null,
        icon: const Icon(Icons.remove_circle_outline),
      ),
      Text('$value', style: Theme.of(context).textTheme.titleMedium),
      IconButton(
        tooltip: '+',
        onPressed: value < 10 ? () => onChanged(value + 1) : null,
        icon: const Icon(Icons.add_circle_outline),
      ),
    ],
  );
}

class _OfferCard extends StatelessWidget {
  const _OfferCard(this.o);
  final RoomOffer o;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        onTap: () => context.push('/guest/room', extra: o),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            RoomArt(name: o.name, height: 150),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(o.name, style: text.titleMedium),
                  const SizedBox(height: 4),
                  Text(l.perNight(money(o.perNight, o.currency)), style: text.bodyLarge),
                  Text(
                    '${l.totalLabel}: ${money(o.total, o.currency)} · ${l.nightsCount('${o.nights}')}',
                    style: text.bodySmall,
                  ),
                  if (o.roomsLeft <= 3)
                    Text(
                      l.roomsLeft('${o.roomsLeft}'),
                      style: text.bodySmall?.copyWith(color: Theme.of(context).colorScheme.error),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ───────────── G4: room detail → hold ─────────────

class RoomScreen extends ConsumerStatefulWidget {
  const RoomScreen({super.key, required this.offer});
  final RoomOffer offer;
  @override
  ConsumerState<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends ConsumerState<RoomScreen> {
  final _requests = TextEditingController();

  @override
  void dispose() {
    _requests.dispose();
    super.dispose();
  }

  Future<void> _reserve() async {
    try {
      final r = await ref
          .read(bookingRepositoryProvider)
          .hold(ref.read(stayQueryProvider), widget.offer.id, specialRequests: _requests.text);
      if (mounted) context.push('/guest/review/${r.id}');
    } catch (e) {
      if (mounted) _snack(context, failureText(context, e));
      ref.invalidate(searchProvider); // availability changed
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final o = widget.offer;
    final q = ref.watch(stayQueryProvider);
    final hotel = ref.watch(hotelProvider).valueOrNull;
    final text = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: Text(o.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (o.description.isNotEmpty) Text(o.description),
          const SizedBox(height: 16),
          Text(l.amenities, style: text.titleSmall),
          Wrap(spacing: 8, children: [for (final a in o.amenities) Chip(label: Text(a))]),
          const SizedBox(height: 16),
          Text(dateRange(context, q.checkIn, q.checkOut), style: text.titleMedium),
          Text('${l.guests}: ${q.guests} · ${l.nightsCount('${o.nights}')}'),
          Text('${l.totalLabel}: ${money(o.total, o.currency)}', style: text.titleLarge),
          if (hotel != null) ...[
            const SizedBox(height: 16),
            Text(l.policies, style: text.titleSmall),
            Text(l.checkInTime(hotel.checkInTime)),
            Text(l.checkOutTime(hotel.checkOutTime)),
            if (hotel.cancellation.isNotEmpty) Text(hotel.cancellation),
          ],
          const SizedBox(height: 16),
          TextField(
            controller: _requests,
            maxLength: 500,
            maxLines: 3,
            decoration: InputDecoration(labelText: l.specialRequests),
          ),
          const SizedBox(height: 8),
          BusyButton(label: l.reserve, onPressed: _reserve),
        ],
      ),
    );
  }
}

// ───────────── G7: review and pay ─────────────

class ReviewScreen extends ConsumerWidget {
  const ReviewScreen({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l.review)),
      body: AsyncBody(
        value: ref.watch(reservationProvider(id)),
        onRetry: () => ref.invalidate(reservationProvider(id)),
        builder: (r) {
          if (r.status != BookingStatus.hold) {
            return Center(child: Text(statusLabel(l, r.status)));
          }
          Future<void> pay(bool deposit) async {
            try {
              final url = await ref.read(bookingRepositoryProvider).pay(id, deposit: deposit);
              await launchUrl(Uri.parse(url), mode: LaunchMode.inAppBrowserView);
              if (context.mounted) context.pushReplacement('/guest/payment/$id', extra: url);
            } catch (e) {
              if (context.mounted) _snack(context, failureText(context, e));
              ref.invalidate(reservationProvider(id));
            }
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (r.holdExpiresAt != null) HoldTimer(until: r.holdExpiresAt!),
              const SizedBox(height: 8),
              PriceBreakdown(r),
              const SizedBox(height: 8),
              Text(l.checkInTime(r.checkInTime)),
              Text(l.checkOutTime(r.checkOutTime)),
              if (r.cancellation.isNotEmpty) Text(r.cancellation),
              const SizedBox(height: 24),
              if (r.offersDeposit) ...[
                BusyButton(label: l.payDeposit(money(r.depositAmount, r.currency)), onPressed: () => pay(true)),
                const SizedBox(height: 8),
                OutlinedButton(onPressed: () => pay(false), child: Text(l.payFull(money(r.total, r.currency)))),
              ] else
                BusyButton(label: l.payFull(money(r.total, r.currency)), onPressed: () => pay(false)),
            ],
          );
        },
      ),
    );
  }
}

/// "We're holding this room for 12:34". Turns into an expiry notice at zero.
class HoldTimer extends StatefulWidget {
  const HoldTimer({super.key, required this.until});
  final DateTime until;
  @override
  State<HoldTimer> createState() => _HoldTimerState();
}

class _HoldTimerState extends State<HoldTimer> {
  late final Timer _tick;

  @override
  void initState() {
    super.initState();
    _tick = Timer.periodic(const Duration(seconds: 1), (_) => setState(() {}));
  }

  @override
  void dispose() {
    _tick.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final left = widget.until.difference(DateTime.now());
    final scheme = Theme.of(context).colorScheme;
    if (left.isNegative) {
      _tick.cancel();
      return Text(l.holdExpired, style: TextStyle(color: scheme.error));
    }
    final mmss = '${left.inMinutes}:${(left.inSeconds % 60).toString().padLeft(2, '0')}';
    return Text(l.holdTimer(mmss), style: TextStyle(color: scheme.primary));
  }
}

class PriceBreakdown extends StatelessWidget {
  const PriceBreakdown(this.r, {super.key});
  final Reservation r;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    Widget row(String label, double amount, {bool bold = false}) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(child: Text(label, style: bold ? text.titleMedium : null)),
          Text(money(amount, r.currency), style: bold ? text.titleMedium : null),
        ],
      ),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(r.roomTypeName, style: text.titleLarge),
        Text('${dateRange(context, r.checkIn, r.checkOut)} · ${l.guests}: ${r.adults + r.children}'),
        const SizedBox(height: 8),
        for (final n in r.nights) row(date(context, n.date), n.price),
        if (r.serviceCharge > 0) row(l.serviceCharge, r.serviceCharge),
        if (r.tax > 0) row(l.vat, r.tax),
        const Divider(),
        row(l.totalLabel, r.total, bold: true),
      ],
    );
  }
}

// ───────────── G8: waiting for payment → confirmation ─────────────

/// Polls the reservation while the guest pays in the browser.
/// ponytail: polling every 3 s; Phase 3 adds the WebSocket `reservation.updated` event.
class PaymentStatusScreen extends ConsumerStatefulWidget {
  const PaymentStatusScreen({super.key, required this.id, this.checkoutUrl});
  final String id;
  final String? checkoutUrl;
  @override
  ConsumerState<PaymentStatusScreen> createState() => _PaymentStatusState();
}

class _PaymentStatusState extends ConsumerState<PaymentStatusScreen> {
  Timer? _poll;

  @override
  void initState() {
    super.initState();
    _poll = Timer.periodic(const Duration(seconds: 3), (_) => ref.invalidate(reservationProvider(widget.id)));
  }

  @override
  void dispose() {
    _poll?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final r = ref.watch(reservationProvider(widget.id)).valueOrNull;
    final done = r != null && r.status != BookingStatus.hold;
    if (done) _poll?.cancel();

    final Widget body;
    if (r == null || r.status == BookingStatus.hold) {
      body = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(l.waitingPayment, style: text.titleMedium),
          Text(l.waitingPaymentHint, textAlign: TextAlign.center),
          if (widget.checkoutUrl != null)
            TextButton(
              onPressed: () => launchUrl(Uri.parse(widget.checkoutUrl!), mode: LaunchMode.inAppBrowserView),
              child: Text(l.openPaymentAgain),
            ),
        ],
      );
    } else if (r.isConfirmed) {
      body = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle, size: 72, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 8),
          Text(l.bookingConfirmed, style: text.headlineSmall),
          Text(l.bookingCode(r.code), style: text.titleMedium),
          if (r.room != null) Text(l.roomNumber(r.room!)),
          Text(dateRange(context, r.checkIn, r.checkOut)),
          const SizedBox(height: 24),
          FilledButton(onPressed: () => context.go('/guest/bookings/${r.id}'), child: Text(l.viewBooking)),
          TextButton(onPressed: () => context.go('/guest'), child: Text(l.backHome)),
        ],
      );
    } else {
      body = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, size: 72, color: Theme.of(context).colorScheme.error),
          const SizedBox(height: 8),
          Text(l.paymentFailed, textAlign: TextAlign.center),
          const SizedBox(height: 24),
          FilledButton(onPressed: () => context.go('/guest/search'), child: Text(l.findRoom)),
        ],
      );
    }
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: !done),
      body: Center(
        child: Padding(padding: const EdgeInsets.all(24), child: body),
      ),
    );
  }
}
