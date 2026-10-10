// Pure Dart entities and the repository contract for booking (Phase 2).

class StayQuery {
  const StayQuery({required this.checkIn, required this.checkOut, this.adults = 2, this.children = 0});
  final DateTime checkIn; // date only (local midnight)
  final DateTime checkOut;
  final int adults;
  final int children;

  int get nights => checkOut.difference(checkIn).inDays;
  int get guests => adults + children;

  StayQuery copyWith({DateTime? checkIn, DateTime? checkOut, int? adults, int? children}) => StayQuery(
    checkIn: checkIn ?? this.checkIn,
    checkOut: checkOut ?? this.checkOut,
    adults: adults ?? this.adults,
    children: children ?? this.children,
  );

  /// Tomorrow for one night, 2 adults.
  factory StayQuery.initial(DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    return StayQuery(checkIn: today.add(const Duration(days: 1)), checkOut: today.add(const Duration(days: 2)));
  }
}

class Hotel {
  const Hotel({
    required this.id,
    required this.name,
    required this.currency,
    required this.checkInTime,
    required this.checkOutTime,
    required this.cancellation,
    this.address,
    this.latitude,
    this.longitude,
  });
  final String id;
  final String name;
  final String currency;
  final String checkInTime;
  final String checkOutTime;
  final String cancellation;
  final String? address;
  final double? latitude;
  final double? longitude;
}

class RoomOffer {
  const RoomOffer({
    required this.id,
    required this.name,
    required this.description,
    required this.amenities,
    required this.maxGuests,
    required this.roomsLeft,
    required this.nights,
    required this.perNight,
    required this.total,
    required this.currency,
  });
  final String id;
  final String name;
  final String description;
  final List<String> amenities;
  final int maxGuests;
  final int roomsLeft;
  final int nights;
  final double perNight;
  final double total;
  final String currency;
}

enum BookingStatus { hold, pending, confirmed, checkedIn, checkedOut, cancelled, noShow, declined, expired }

/// 'CHECKED_IN' → BookingStatus.checkedIn
BookingStatus parseStatus(String s) {
  final camel = s.toLowerCase().replaceAllMapped(RegExp(r'_([a-z])'), (m) => m[1]!.toUpperCase());
  return BookingStatus.values.byName(camel);
}

class NightPrice {
  const NightPrice(this.date, this.price);
  final DateTime date;
  final double price;
}

class Reservation {
  const Reservation({
    required this.id,
    required this.code,
    required this.status,
    required this.checkIn,
    required this.checkOut,
    required this.adults,
    required this.children,
    required this.roomTypeName,
    required this.nights,
    required this.subtotal,
    required this.serviceCharge,
    required this.tax,
    required this.total,
    required this.currency,
    required this.paid,
    required this.balance,
    required this.depositAmount,
    required this.canCancel,
    required this.checkInTime,
    required this.checkOutTime,
    required this.cancellation,
    this.holdExpiresAt,
    this.room,
  });
  final String id;
  final String code;
  final BookingStatus status;
  final DateTime checkIn;
  final DateTime checkOut;
  final int adults;
  final int children;
  final String roomTypeName;
  final String? room;
  final DateTime? holdExpiresAt;
  final List<NightPrice> nights;
  final double subtotal;
  final double serviceCharge;
  final double tax;
  final double total;
  final String currency;
  final double paid;
  final double balance;
  final double depositAmount;
  final bool canCancel;
  final String checkInTime;
  final String checkOutTime;
  final String cancellation;

  bool get isConfirmed => status == BookingStatus.confirmed || status == BookingStatus.checkedIn;
  bool get offersDeposit => depositAmount < total;
}

class ReservationSummary {
  const ReservationSummary({
    required this.id,
    required this.code,
    required this.status,
    required this.checkIn,
    required this.checkOut,
    required this.roomTypeName,
    required this.total,
    required this.currency,
  });
  final String id;
  final String code;
  final BookingStatus status;
  final DateTime checkIn;
  final DateTime checkOut;
  final String roomTypeName;
  final double total;
  final String currency;
}

/// The booking to show on Home: confirmed/in-house and not yet past check-out.
ReservationSummary? currentStay(List<ReservationSummary> all, DateTime today) {
  final active =
      all
          .where(
            (r) =>
                (r.status == BookingStatus.confirmed || r.status == BookingStatus.checkedIn) &&
                !r.checkOut.isBefore(today),
          )
          .toList()
        ..sort((a, b) => a.checkIn.compareTo(b.checkIn));
  return active.isEmpty ? null : active.first;
}

class CancelQuote {
  const CancelQuote({required this.paid, required this.refund, required this.currency});
  final double paid;
  final double refund;
  final String currency;
}

class InvoiceLine {
  const InvoiceLine(this.kind, this.description, this.amount);
  final String kind;
  final String description;
  final double amount;
}

class Invoice {
  const Invoice({
    required this.code,
    required this.hotelName,
    required this.currency,
    required this.lines,
    required this.charges,
    required this.paid,
    required this.balance,
  });
  final String code;
  final String hotelName;
  final String currency;
  final List<InvoiceLine> lines;
  final double charges;
  final double paid;
  final double balance;
}

class GuideItem {
  const GuideItem(this.title, this.body);
  final String title;
  final String body;
}

abstract interface class BookingRepository {
  Future<Hotel> hotel();
  Future<List<RoomOffer>> search(StayQuery q);
  Future<Reservation> hold(StayQuery q, String roomTypeId, {String? specialRequests});

  /// Returns the hosted checkout URL.
  Future<String> pay(String reservationId, {required bool deposit});
  Future<Reservation> reservation(String id);
  Future<List<ReservationSummary>> mine();
  Future<CancelQuote> cancelQuote(String id);
  Future<Reservation> cancel(String id);
  Future<Invoice> invoice(String id);
  Future<List<GuideItem>> guide();
  Future<void> feedback(String reservationId, int rating, String? comment);
}
