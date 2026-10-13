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

  test('web redirects: guests get the placeholder, staff/admin unchanged', () {
    String? go(String loc, {AsyncValue<User?> auth = const AsyncData(null), bool isWeb = true}) =>
        redirectFor(location: loc, languageChosen: true, auth: auth, isWeb: isWeb);
    final guest = AsyncData<User?>(_user(const []));
    final staff = AsyncData<User?>(_user(const [Membership(hotelId: hotelId, role: Role.staff)]));

    expect(go('/guest', auth: guest), '/web-guest');
    expect(go('/staff', auth: guest), '/web-guest');
    expect(go('/admin', auth: guest), '/web-guest');
    expect(go('/web-guest', auth: guest), isNull);
    expect(go('/settings', auth: guest), isNull);
    expect(go('/web-guest', auth: guest, isWeb: false), '/guest');
    expect(go('/signin', auth: guest, isWeb: false), '/guest');
    expect(go('/signin', auth: staff), '/staff');
    expect(go('/web-guest', auth: staff), '/staff');
    expect(go('/guest'), '/signin');
  });

  test('deep links survive the splash and sign-in detours', () {
    String? go(String loc, {AsyncValue<User?> auth = const AsyncData(null), bool isWeb = false}) {
      final uri = Uri.parse(loc);
      return redirectFor(location: uri.path, uri: uri, languageChosen: true, auth: auth, isWeb: isWeb);
    }

    String splash(String from) => '/splash?from=${Uri.encodeComponent(from)}';
    String signin(String from) => '/signin?from=${Uri.encodeComponent(from)}';
    final admin = AsyncData<User?>(_user(const [Membership(hotelId: hotelId, role: Role.admin)]));
    final staff = AsyncData<User?>(_user(const [Membership(hotelId: hotelId, role: Role.staff)]));
    final guest = AsyncData<User?>(_user(const []));
    const deep = '/admin/rooms/type/abc';

    // While auth is restoring, remember where we were going.
    expect(go(deep, auth: const AsyncLoading()), splash(deep));
    expect(go('/admin/reports?tab=2', auth: const AsyncLoading()), splash('/admin/reports?tab=2'));
    expect(go(splash(deep), auth: const AsyncLoading()), isNull);
    expect(go('/splash', auth: const AsyncLoading()), isNull);

    // Resolved: go back to it when the role may open it.
    expect(go(splash(deep), auth: admin), deep);
    expect(go(splash('/settings'), auth: staff), '/settings');
    expect(go(splash('/admin/reports?tab=2'), auth: admin), '/admin/reports?tab=2');
    // Another role's area falls back to home.
    expect(go(splash(deep), auth: staff), '/staff');
    expect(go(splash('/staff/tasks'), auth: admin), '/admin');
    expect(go(splash('/adminx'), auth: admin), '/admin');
    // On web a guest still lands on the placeholder.
    expect(go(splash('/guest/bookings'), auth: guest, isWeb: true), '/web-guest');
    expect(go(splash('/guest/bookings'), auth: guest), '/guest/bookings');
    // Only internal paths are honoured.
    expect(go(splash('//evil.com/admin'), auth: admin), '/admin');
    expect(go(splash('https://evil.com/admin'), auth: admin), '/admin');
    expect(go(splash('admin'), auth: admin), '/admin');
    expect(go(splash(r'/\evil.com'), auth: admin), '/admin');

    // Signed out: keep the target through sign-in.
    expect(go(deep), signin(deep));
    expect(go(splash(deep)), signin(deep));
    expect(go(signin(deep)), isNull);
    expect(go(signin(deep), auth: admin), deep);
    expect(go(signin(deep), auth: staff), '/staff');
    expect(go('/splash'), '/signin');
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
