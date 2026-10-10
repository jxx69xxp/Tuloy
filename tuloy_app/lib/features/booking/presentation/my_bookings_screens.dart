import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/format.dart';
import '../../../l10n/app_localizations.dart';
import '../../auth/presentation/widgets.dart';
import '../domain/booking.dart';
import 'booking_providers.dart';
import 'booking_screens.dart';

// ───────────── G9: my bookings ─────────────

class MyBookingsScreen extends ConsumerWidget {
  const MyBookingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l.myBookings)),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(myBookingsProvider.future),
        child: AsyncBody(
          value: ref.watch(myBookingsProvider),
          onRetry: () => ref.invalidate(myBookingsProvider),
          builder: (list) => list.isEmpty
              ? ListView(
                  children: [Padding(padding: const EdgeInsets.all(24), child: Text(l.noBookings))],
                )
              : ListView(
                  children: [
                    for (final r in list)
                      ListTile(
                        title: Text(r.roomTypeName),
                        subtitle: Text('${dateRange(context, r.checkIn, r.checkOut)}\n${r.code}'),
                        isThreeLine: true,
                        trailing: StatusChip(r.status),
                        onTap: () => r.status == BookingStatus.hold
                            ? context.push('/guest/review/${r.id}')
                            : context.push('/guest/bookings/${r.id}'),
                      ),
                  ],
                ),
        ),
      ),
    );
  }
}

// ───────────── G10: booking detail, cancel, pay balance ─────────────

class BookingDetailScreen extends ConsumerWidget {
  const BookingDetailScreen({super.key, required this.id});
  final String id;

  Future<void> _cancel(BuildContext context, WidgetRef ref) async {
    final l = AppLocalizations.of(context);
    final repo = ref.read(bookingRepositoryProvider);
    try {
      final q = await repo.cancelQuote(id);
      if (!context.mounted) return;
      final yes = await showDialog<bool>(
        context: context,
        builder: (c) => AlertDialog(
          title: Text(l.cancelBooking),
          content: Text(l.cancelConfirm(money(q.refund, q.currency))),
          actions: [
            TextButton(onPressed: () => Navigator.pop(c, false), child: Text(l.keepBooking)),
            FilledButton(onPressed: () => Navigator.pop(c, true), child: Text(l.cancelBooking)),
          ],
        ),
      );
      if (yes != true) return;
      await repo.cancel(id);
      ref.invalidate(reservationProvider(id));
      ref.invalidate(myBookingsProvider);
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l.cancelled)));
    } catch (e) {
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(failureText(context, e))));
    }
  }

  Future<void> _payBalance(BuildContext context, WidgetRef ref) async {
    try {
      final url = await ref.read(bookingRepositoryProvider).pay(id, deposit: false);
      await launchUrl(Uri.parse(url), mode: LaunchMode.inAppBrowserView);
      ref.invalidate(reservationProvider(id));
    } catch (e) {
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(failureText(context, e))));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l.myBookings)),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(reservationProvider(id).future),
        child: AsyncBody(
          value: ref.watch(reservationProvider(id)),
          onRetry: () => ref.invalidate(reservationProvider(id)),
          builder: (r) => ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                children: [
                  Expanded(child: Text(l.bookingCode(r.code), style: Theme.of(context).textTheme.titleMedium)),
                  StatusChip(r.status),
                ],
              ),
              if (r.room != null) Text(l.roomNumber(r.room!)),
              const SizedBox(height: 8),
              PriceBreakdown(r),
              const SizedBox(height: 8),
              _Line(l.paid, money(r.paid, r.currency)),
              _Line(l.balance, money(r.balance, r.currency)),
              const SizedBox(height: 8),
              Text(l.checkInTime(r.checkInTime)),
              Text(l.checkOutTime(r.checkOutTime)),
              if (r.cancellation.isNotEmpty) Text(r.cancellation),
              const SizedBox(height: 16),
              if (r.isConfirmed) ...[
                FilledButton.icon(
                  icon: const Icon(Icons.hotel),
                  label: Text(l.myStay),
                  onPressed: () => context.push('/guest/stay/${r.id}'),
                ),
                if (r.balance > 0)
                  BusyButton(
                    label: l.payBalance(money(r.balance, r.currency)),
                    onPressed: () => _payBalance(context, ref),
                  ),
              ],
              OutlinedButton.icon(
                icon: const Icon(Icons.receipt_long),
                label: Text(l.invoice),
                onPressed: () => context.push('/guest/bookings/${r.id}/invoice'),
              ),
              if (r.canCancel)
                TextButton(
                  style: TextButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.error),
                  onPressed: () => _cancel(context, ref),
                  child: Text(l.cancelBooking),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Line extends StatelessWidget {
  const _Line(this.label, this.value);
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(child: Text(label)),
      Text(value),
    ],
  );
}

// ───────────── G21: invoice ─────────────

class InvoiceScreen extends ConsumerWidget {
  const InvoiceScreen({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l.invoice)),
      body: AsyncBody(
        value: ref.watch(invoiceProvider(id)),
        onRetry: () => ref.invalidate(invoiceProvider(id)),
        builder: (inv) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(inv.hotelName, style: Theme.of(context).textTheme.titleLarge),
            Text(l.bookingCode(inv.code)),
            const Divider(),
            for (final line in inv.lines) _Line(line.description, money(line.amount, inv.currency)),
            const Divider(),
            _Line(l.charges, money(inv.charges, inv.currency)),
            _Line(l.paid, money(inv.paid, inv.currency)),
            _Line(l.balance, money(inv.balance, inv.currency)),
          ],
        ),
      ),
    );
  }
}
