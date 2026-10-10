import 'dart:math';

import 'package:dio/dio.dart';

import '../../../core/api.dart';
import '../../../core/config.dart';
import '../domain/booking.dart';

String _day(DateTime d) => d.toIso8601String().substring(0, 10);
DateTime _parseDay(Object? s) => DateTime.parse(s as String); // 'YYYY-MM-DD' → local midnight
double _num(Object? v) => v is num ? v.toDouble() : double.parse('$v');

/// Random key per user action, so a retried request can't create a second booking or payment.
String _idempotencyKey() {
  final r = Random.secure();
  return List.generate(16, (_) => r.nextInt(256).toRadixString(16).padLeft(2, '0')).join();
}

class BookingRepositoryImpl implements BookingRepository {
  BookingRepositoryImpl(this._dio);
  final Dio _dio;

  Future<T> _call<T>(Future<Response> request, T Function(dynamic data) map) async {
    try {
      return map((await request).data);
    } catch (e) {
      throw toFailure(e);
    }
  }

  Options _once() => Options(headers: {'Idempotency-Key': _idempotencyKey()});

  @override
  Future<Hotel> hotel() => _call(_dio.get('/hotels/$hotelId'), (j) {
    final p = j['policies'] as Map;
    return Hotel(
      id: j['id'] as String,
      name: j['name'] as String,
      currency: j['currency'] as String,
      checkInTime: '${p['checkIn'] ?? '14:00'}',
      checkOutTime: '${p['checkOut'] ?? '12:00'}',
      cancellation: '${p['cancellation'] ?? ''}',
      address: j['address'] as String?,
      latitude: (j['latitude'] as num?)?.toDouble(),
      longitude: (j['longitude'] as num?)?.toDouble(),
    );
  });

  @override
  Future<List<RoomOffer>> search(StayQuery q) => _call(
    _dio.get(
      '/hotels/$hotelId/availability',
      queryParameters: {
        'checkIn': _day(q.checkIn),
        'checkOut': _day(q.checkOut),
        'adults': q.adults,
        'children': q.children,
      },
    ),
    (j) => [
      for (final o in (j as List).cast<Map>())
        RoomOffer(
          id: o['id'] as String,
          name: o['name'] as String,
          description: o['description'] as String,
          amenities: (o['amenities'] as List).cast<String>(),
          maxGuests: o['maxGuests'] as int,
          roomsLeft: o['roomsLeft'] as int,
          nights: o['nights'] as int,
          perNight: _num(o['perNight']),
          total: _num(o['total']),
          currency: o['currency'] as String,
        ),
    ],
  );

  @override
  Future<Reservation> hold(StayQuery q, String roomTypeId, {String? specialRequests}) => _call(
    _dio.post(
      '/holds',
      options: _once(),
      data: {
        'hotelId': hotelId,
        'roomTypeId': roomTypeId,
        'checkIn': _day(q.checkIn),
        'checkOut': _day(q.checkOut),
        'adults': q.adults,
        'children': q.children,
        if (specialRequests != null && specialRequests.trim().isNotEmpty) 'specialRequests': specialRequests.trim(),
      },
    ),
    _reservation,
  );

  @override
  Future<String> pay(String reservationId, {required bool deposit}) => _call(
    _dio.post('/reservations/$reservationId/pay', options: _once(), data: {'type': deposit ? 'DEPOSIT' : 'FULL'}),
    (j) => j['checkoutUrl'] as String,
  );

  @override
  Future<Reservation> reservation(String id) => _call(_dio.get('/reservations/$id'), _reservation);

  @override
  Future<List<ReservationSummary>> mine() => _call(
    _dio.get('/me/reservations'),
    (j) => [
      for (final r in (j as List).cast<Map>())
        ReservationSummary(
          id: r['id'] as String,
          code: r['code'] as String,
          status: parseStatus(r['status'] as String),
          checkIn: _parseDay(r['checkIn']),
          checkOut: _parseDay(r['checkOut']),
          roomTypeName: r['roomType']['name'] as String,
          total: _num(r['total']),
          currency: r['currency'] as String,
        ),
    ],
  );

  @override
  Future<CancelQuote> cancelQuote(String id) => _call(
    _dio.get('/reservations/$id/cancel-quote'),
    (j) => CancelQuote(paid: _num(j['paid']), refund: _num(j['refund']), currency: j['currency'] as String),
  );

  @override
  Future<Reservation> cancel(String id) => _call(_dio.post('/reservations/$id/cancel', data: {}), _reservation);

  @override
  Future<Invoice> invoice(String id) => _call(
    _dio.get('/reservations/$id/invoice'),
    (j) => Invoice(
      code: j['code'] as String,
      hotelName: j['hotel']['name'] as String,
      currency: j['currency'] as String,
      lines: [
        for (final l in (j['lines'] as List).cast<Map>())
          InvoiceLine(l['kind'] as String, l['description'] as String, _num(l['amount'])),
      ],
      charges: _num(j['charges']),
      paid: _num(j['paid']),
      balance: _num(j['balance']),
    ),
  );

  @override
  Future<List<GuideItem>> guide() => _call(
    _dio.get('/hotels/$hotelId/content', queryParameters: {'kind': 'guide'}),
    (j) => [for (final g in (j as List).cast<Map>()) GuideItem(g['title'] as String, g['body'] as String)],
  );

  @override
  Future<void> feedback(String reservationId, int rating, String? comment) => _call(
    _dio.post(
      '/feedback',
      data: {
        'reservationId': reservationId,
        'rating': rating,
        if (comment != null && comment.trim().isNotEmpty) 'comment': comment.trim(),
      },
    ),
    (_) {},
  );

  static Reservation _reservation(dynamic j) {
    final price = j['price'] as Map;
    final policy = j['policy'] as Map;
    return Reservation(
      id: j['id'] as String,
      code: j['code'] as String,
      status: parseStatus(j['status'] as String),
      checkIn: _parseDay(j['checkIn']),
      checkOut: _parseDay(j['checkOut']),
      adults: j['adults'] as int,
      children: j['children'] as int,
      roomTypeName: j['roomType']['name'] as String,
      room: j['room'] as String?,
      holdExpiresAt: j['holdExpiresAt'] == null ? null : DateTime.parse(j['holdExpiresAt'] as String).toLocal(),
      nights: [
        for (final n in (price['nights'] as List).cast<Map>()) NightPrice(_parseDay(n['date']), _num(n['price'])),
      ],
      subtotal: _num(price['subtotal']),
      serviceCharge: _num(price['serviceCharge']),
      tax: _num(price['tax']),
      total: _num(price['total']),
      currency: j['currency'] as String,
      paid: _num(j['paid']),
      balance: _num(j['balance']),
      depositAmount: _num(j['depositAmount']),
      canCancel: j['canCancel'] as bool,
      checkInTime: policy['checkIn'] as String,
      checkOutTime: policy['checkOut'] as String,
      cancellation: policy['cancellation'] as String,
    );
  }
}
