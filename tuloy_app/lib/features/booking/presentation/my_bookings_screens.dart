import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/format.dart';
import '../../../core/ui.dart' show EmptyState, Section;
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
              ? ListView(children: [EmptyState(l.noBookings, icon: Icons.event_note)])
              : ListView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                  children: [
                    for (final r in list)
                      Card(
                        child: ListTile(
                          title: Text(r.roomTypeName),
                          subtitle: Text('${dateRange(context, r.checkIn, r.checkOut)}\n${r.code}'),
                          isThreeLine: true,
                          trailing: StatusChip(r.status),
                          onTap: () => r.status == BookingStatus.hold
                              ? context.push('/guest/review/${r.id}')
                              : context.push('/guest/bookings/${r.id}'),
                        ),
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
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      [l.bookingCode(r.code), if (r.room != null) l.roomNumber(r.room!)].join(' · '),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  StatusChip(r.status),
                ],
              ),
              const SizedBox(height: 8),
              PriceBreakdown(r, payments: true),
              const SizedBox(height: 12),
              StayTerms(r),
              const SizedBox(height: 24),
              if (r.isConfirmed) ...[
                FilledButton.icon(
                  icon: const Icon(Icons.hotel),
                  label: Text(l.myStay),
                  onPressed: () => context.push('/guest/stay/${r.id}'),
                ),
                const SizedBox(height: 12),
                if (r.balance > 0) ...[
                  BusyButton(
                    label: l.payBalance(money(r.balance, r.currency)),
                    onPressed: () => _payBalance(context, ref),
                  ),
                  const SizedBox(height: 12),
                ],
              ],
              OutlinedButton.icon(
                icon: const Icon(Icons.receipt_long),
                label: Text(l.invoice),
                onPressed: () => context.push('/guest/bookings/${r.id}/invoice'),
              ),
              if (r.canCancel) ...[
                const SizedBox(height: 8),
                TextButton(
                  style: TextButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.error),
                  onPressed: () => _cancel(context, ref),
                  child: Text(l.cancelBooking),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _Line extends StatelessWidget {
  const _Line(this.label, this.value, {this.bold = false});
  final String label;
  final String value;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    final style = bold ? Theme.of(context).textTheme.titleMedium : null;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(label, style: style)),
          Text(value, style: style),
        ],
      ),
    );
  }
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
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          children: [
            Text(inv.hotelName, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 4),
            Text(
              l.bookingCode(inv.code),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            Section(gutter: 0, [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                child: Column(
                  children: [
                    for (final line in inv.lines) _Line(line.description, money(line.amount, inv.currency)),
                    const Divider(height: 17),
                    _Line(l.charges, money(inv.charges, inv.currency)),
                    _Line(l.paid, money(inv.paid, inv.currency)),
                    _Line(l.balance, money(inv.balance, inv.currency), bold: true),
                  ],
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
