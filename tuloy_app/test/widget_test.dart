// Named widget_test.dart so `flutter create .` keeps this file instead of adding its counter demo.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tuloy_app/app/router.dart';
import 'package:tuloy_app/core/config.dart';
import 'package:tuloy_app/features/auth/domain/auth.dart';
import 'package:tuloy_app/features/booking/domain/booking.dart';

User _user(List<Membership> m) => User(id: 'u', fullName: 'U', language: 'en', memberships: m);

void main() {
  test('roleAt picks the highest role at this hotel only', () {
    final u = _user(const [
      Membership(hotelId: 'other', role: Role.admin),
      Membership(hotelId: hotelId, role: Role.staff),
    ]);
    expect(u.roleAt(hotelId), Role.staff);
    expect(_user(const []).roleAt(hotelId), Role.guest);
  });

  test('redirects', () {
    String? go(String loc, {bool lang = true, AsyncValue<User?> auth = const AsyncData(null)}) =>
        redirectFor(location: loc, languageChosen: lang, auth: auth);
    final staff = AsyncData<User?>(_user(const [Membership(hotelId: hotelId, role: Role.staff)]));

    expect(go('/signin', lang: false), '/language');
    expect(go('/guest', auth: const AsyncLoading()), '/splash');
    expect(go('/admin'), '/signin');
    expect(go('/reset'), isNull);
    expect(go('/signin', auth: staff), '/staff');
    expect(go('/admin', auth: staff), '/staff'); // staff can't open the admin area
    expect(go('/settings', auth: staff), isNull);
  });

  test('status parsing covers every API value', () {
    expect(parseStatus('CHECKED_IN'), BookingStatus.checkedIn);
    expect(parseStatus('NO_SHOW'), BookingStatus.noShow);
    expect(parseStatus('EXPIRED'), BookingStatus.expired);
  });

  test('current stay: earliest confirmed or in-house booking not yet checked out', () {
    ReservationSummary r(String id, BookingStatus s, int inDay, int outDay) => ReservationSummary(
        id: id, code: id, status: s, checkIn: DateTime(2026, 10, inDay), checkOut: DateTime(2026, 10, outDay),
        roomTypeName: 'R', total: 1, currency: 'PHP');
    final today = DateTime(2026, 10, 10);
    expect(currentStay([
      r('old', BookingStatus.confirmed, 1, 3),
      r('cancelled', BookingStatus.cancelled, 10, 12),
      r('later', BookingStatus.confirmed, 20, 22),
      r('now', BookingStatus.checkedIn, 9, 11),
    ], today)?.id, 'now');
    expect(currentStay([r('old', BookingStatus.confirmed, 1, 3)], today), isNull);
  });

  test('stay query nights', () {
    final q = StayQuery.initial(DateTime(2026, 10, 31, 22));
    expect(q.checkIn, DateTime(2026, 11, 1));
    expect(q.nights, 1);
  });
}
