import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../../auth/presentation/auth_controller.dart';
import '../../auth/presentation/widgets.dart';
import '../data/booking_repository_impl.dart';
import '../domain/booking.dart';

final bookingRepositoryProvider = Provider<BookingRepository>((ref) => BookingRepositoryImpl(ref.read(dioProvider)));

/// Re-fetches when the language changes, since the API returns translated text.
final hotelProvider = FutureProvider<Hotel>((ref) {
  ref.watch(languageProvider);
  return ref.read(bookingRepositoryProvider).hotel();
});

final stayQueryProvider = StateProvider<StayQuery>((_) => StayQuery.initial(DateTime.now()));

final searchProvider = FutureProvider.autoDispose<List<RoomOffer>>((ref) {
  ref.watch(languageProvider);
  return ref.read(bookingRepositoryProvider).search(ref.watch(stayQueryProvider));
});

final reservationProvider = FutureProvider.autoDispose.family<Reservation, String>((ref, id) {
  ref.watch(languageProvider);
  return ref.read(bookingRepositoryProvider).reservation(id);
});

final myBookingsProvider = FutureProvider.autoDispose<List<ReservationSummary>>((ref) {
  ref.watch(languageProvider);
  return ref.read(bookingRepositoryProvider).mine();
});

final invoiceProvider = FutureProvider.autoDispose.family<Invoice, String>((ref, id) {
  ref.watch(languageProvider);
  return ref.read(bookingRepositoryProvider).invoice(id);
});

final guideProvider = FutureProvider.autoDispose<List<GuideItem>>((ref) {
  ref.watch(languageProvider);
  return ref.read(bookingRepositoryProvider).guide();
});

String statusLabel(AppLocalizations l, BookingStatus s) => switch (s) {
  BookingStatus.hold => l.statusHold,
  BookingStatus.pending => l.statusPending,
  BookingStatus.confirmed => l.statusConfirmed,
  BookingStatus.checkedIn => l.statusCheckedIn,
  BookingStatus.checkedOut => l.statusCheckedOut,
  BookingStatus.cancelled => l.statusCancelled,
  BookingStatus.noShow => l.statusNoShow,
  BookingStatus.declined => l.statusDeclined,
  BookingStatus.expired => l.statusExpired,
};

/// Payment state from the API ('paid' | 'deposit' | 'partial' | 'unpaid') as staff read it.
String paymentLabel(AppLocalizations l, String? state) => switch (state) {
  'paid' => l.paymentPaid,
  'deposit' => l.paymentDeposit,
  'partial' => l.paymentPartial,
  _ => l.paymentUnpaid,
};

/// Paid (teal), deposit or partly paid (amber: money still due), not paid (red).
class PaymentChip extends StatelessWidget {
  const PaymentChip(this.state, {super.key});
  final String? state;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    final (bg, fg) = switch (state) {
      'paid' => (c.primaryContainer, c.onPrimaryContainer),
      'deposit' || 'partial' => (c.tertiaryContainer, c.onTertiaryContainer),
      _ => (c.errorContainer, c.onErrorContainer),
    };
    return Chip(
      label: Text(paymentLabel(AppLocalizations.of(context), state)),
      backgroundColor: bg,
      labelStyle: TextStyle(color: fg),
      side: BorderSide.none,
      visualDensity: VisualDensity.compact,
    );
  }
}

class StatusChip extends StatelessWidget {
  const StatusChip(this.status, {super.key});
  final BookingStatus status;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final good = status == BookingStatus.confirmed || status == BookingStatus.checkedIn;
    return Chip(
      label: Text(statusLabel(AppLocalizations.of(context), status)),
      backgroundColor: good ? scheme.primaryContainer : scheme.surfaceContainerHighest,
      visualDensity: VisualDensity.compact,
    );
  }
}

/// Spinner / error-with-retry / data, for any AsyncValue.
class AsyncBody<T> extends StatelessWidget {
  const AsyncBody({super.key, required this.value, required this.onRetry, required this.builder});
  final AsyncValue<T> value;
  final VoidCallback onRetry;
  final Widget Function(T data) builder;

  @override
  Widget build(BuildContext context) => value.when(
    data: builder,
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (e, _) => Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(failureText(context, e), textAlign: TextAlign.center),
            const SizedBox(height: 12),
            OutlinedButton(onPressed: onRetry, child: Text(AppLocalizations.of(context).retry)),
          ],
        ),
      ),
    ),
  );
}
