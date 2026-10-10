import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/config.dart';
import '../features/auth/domain/auth.dart';
import '../features/auth/presentation/auth_controller.dart';
import '../features/auth/presentation/auth_screens.dart';
import '../features/auth/presentation/widgets.dart' show SplashScreen;
import '../features/booking/domain/booking.dart';
import '../features/booking/presentation/booking_screens.dart';
import '../features/booking/presentation/my_bookings_screens.dart';
import '../features/booking/presentation/stay_screens.dart';
import '../core/http.dart' show J;
import '../features/admin/admin_catalog_screens.dart';
import '../features/admin/admin_people_screens.dart';
import '../features/admin/admin_screens.dart';
import '../features/chat/chat_screen.dart';
import '../features/loyalty/loyalty_wifi_screens.dart';
import '../features/restaurant/restaurant_screens.dart';
import '../features/services/services_screens.dart';
import '../features/staff/staff_screens.dart';
import '../features/settings/presentation/profile_screen.dart';
import '../features/settings/presentation/settings_screen.dart';
import '../features/settings/presentation/web_guest_screen.dart';

const _public = {'/language', '/signin', '/signup', '/reset'};

/// Chat thread; the title (guest name / hotel) rides along as `extra`.
final _chat = GoRoute(
  path: 'chat/:id',
  builder: (_, s) => ChatScreen(id: s.pathParameters['id']!, title: s.extra as String?),
);

/// Front-desk screens, mounted under /staff and under /admin/desk.
List<RouteBase> _deskRoutes(String base) => [
  GoRoute(
    path: 'reservations',
    builder: (_, __) => ReservationsQueueScreen(base: base),
  ),
  GoRoute(
    path: 'reservations/:id',
    builder: (_, s) => StaffReservationScreen(id: s.pathParameters['id']!),
  ),
  GoRoute(path: 'tasks', builder: (_, __) => const TasksScreen()),
  GoRoute(path: 'orders', builder: (_, __) => const OrdersQueueScreen()),
  GoRoute(
    path: 'inbox',
    builder: (_, __) => InboxScreen(base: base),
  ),
  GoRoute(path: 'leave', builder: (_, __) => const LeaveScreen()),
  GoRoute(
    path: 'chat/:id',
    builder: (_, s) => ChatScreen(id: s.pathParameters['id']!, title: s.extra as String?),
  ),
];

/// Where a signed-in user belongs. Each role only sees its own area (plus /settings).
/// UI guard only — the API enforces roles and permissions on every call.
String homeFor(Role role) => switch (role) {
  Role.guest => '/guest',
  Role.staff => '/staff',
  Role.admin => '/admin',
};

/// Pure so it can be unit-tested: decides the redirect for a location.
String? redirectFor({
  required String location,
  required bool languageChosen,
  required AsyncValue<User?> auth,
  bool isWeb = kIsWeb,
}) {
  if (!languageChosen) return location == '/language' ? null : '/language';
  if (auth.isLoading && !auth.hasValue) return location == '/splash' ? null : '/splash';
  final user = auth.valueOrNull;
  if (user == null) return _public.contains(location) ? null : '/signin';
  final role = user.roleAt(hotelId);
  final home = homeFor(role);
  // Web is Staff/Admin only: guests get a placeholder pointing at the mobile app.
  if (isWeb && role == Role.guest) return location == '/web-guest' || location == '/settings' ? null : '/web-guest';
  if (location == '/settings' || location.startsWith(home)) return null;
  return home;
}

final routerProvider = Provider<GoRouter>((ref) {
  final refresh = ValueNotifier(0);
  ref.listen(authProvider, (_, __) => refresh.value++);
  ref.listen(languageProvider, (_, __) => refresh.value++);
  ref.onDispose(refresh.dispose);

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: refresh,
    redirect: (_, state) => redirectFor(
      location: state.matchedLocation,
      languageChosen: ref.read(languageProvider) != null,
      auth: ref.read(authProvider),
    ),
    routes: [
      GoRoute(path: '/splash', builder: (_, __) => const SplashScreen()),
      GoRoute(path: '/language', builder: (_, __) => const LanguageScreen()),
      GoRoute(path: '/signin', builder: (_, __) => const SignInScreen()),
      GoRoute(path: '/signup', builder: (_, __) => const SignUpScreen()),
      GoRoute(path: '/reset', builder: (_, __) => const ResetScreen()),
      GoRoute(path: '/settings', builder: (_, __) => const SettingsScreen()),
      GoRoute(path: '/web-guest', builder: (_, __) => const WebGuestScreen()),
      GoRoute(
        path: '/guest',
        builder: (_, __) => const GuestHomeScreen(),
        routes: [
          GoRoute(path: 'profile', builder: (_, __) => const ProfileScreen()),
          GoRoute(path: 'search', builder: (_, __) => const SearchScreen()),
          GoRoute(
            path: 'room',
            redirect: (_, s) => s.extra is RoomOffer ? null : '/guest/search', // offer lost (e.g. app restored)
            builder: (_, s) => RoomScreen(offer: s.extra! as RoomOffer),
          ),
          GoRoute(
            path: 'review/:id',
            builder: (_, s) => ReviewScreen(id: s.pathParameters['id']!),
          ),
          GoRoute(
            path: 'payment/:id',
            builder: (_, s) => PaymentStatusScreen(id: s.pathParameters['id']!, checkoutUrl: s.extra as String?),
          ),
          GoRoute(path: 'bookings', builder: (_, __) => const MyBookingsScreen()),
          GoRoute(
            path: 'bookings/:id',
            builder: (_, s) => BookingDetailScreen(id: s.pathParameters['id']!),
          ),
          GoRoute(
            path: 'bookings/:id/invoice',
            builder: (_, s) => InvoiceScreen(id: s.pathParameters['id']!),
          ),
          GoRoute(
            path: 'stay/:id',
            builder: (_, s) => MyStayScreen(id: s.pathParameters['id']!),
          ),
          GoRoute(path: 'guide', builder: (_, __) => const GuideScreen()),
          GoRoute(
            path: 'feedback/:id',
            builder: (_, s) => FeedbackScreen(id: s.pathParameters['id']!),
          ),
          GoRoute(path: 'services', builder: (_, __) => const ServicesScreen()),
          GoRoute(
            path: 'services/:id',
            builder: (_, s) => ServiceRequestScreen(id: s.pathParameters['id']!),
          ),
          GoRoute(path: 'requests', builder: (_, __) => const MyRequestsScreen()),
          GoRoute(
            path: 'requests/:id',
            builder: (_, s) => RequestStatusScreen(id: s.pathParameters['id']!),
          ),
          GoRoute(path: 'scan', builder: (_, __) => const ScanScreen()),
          GoRoute(
            path: 'menu/:token',
            builder: (_, s) => MenuScreen(token: s.pathParameters['token']!),
          ),
          GoRoute(
            path: 'orders/:id',
            builder: (_, s) => OrderStatusScreen(id: s.pathParameters['id']!),
          ),
          GoRoute(path: 'loyalty', builder: (_, __) => const LoyaltyScreen()),
          GoRoute(
            path: 'wifi/:id',
            builder: (_, s) => WifiScreen(reservationId: s.pathParameters['id']!),
          ),
          _chat,
        ],
      ),
      GoRoute(path: '/staff', builder: (_, __) => const StaffHomeScreen(), routes: _deskRoutes('/staff')),
      GoRoute(
        path: '/admin',
        builder: (_, __) => const AdminHomeScreen(),
        routes: [
          GoRoute(
            path: 'desk',
            builder: (_, __) => const StaffHomeScreen(base: '/admin/desk'),
            routes: _deskRoutes('/admin/desk'),
          ),
          GoRoute(path: 'rooms', builder: (_, __) => const RoomsAdminScreen()),
          GoRoute(
            path: 'rooms/type',
            builder: (_, s) => RoomTypeEditScreen(type: s.extra as J?),
          ),
          GoRoute(
            path: 'rooms/rates',
            redirect: (_, s) => s.extra is Map ? null : '/admin/rooms',
            builder: (_, s) => RatesScreen(type: s.extra! as J),
          ),
          GoRoute(path: 'rooms/blocks', builder: (_, __) => const BlocksScreen()),
          GoRoute(path: 'services', builder: (_, __) => const ServicesAdminScreen()),
          GoRoute(
            path: 'services/edit',
            builder: (_, s) => ServiceEditScreen(id: s.extra as String?),
          ),
          GoRoute(path: 'restaurant', builder: (_, __) => const RestaurantAdminScreen()),
          GoRoute(
            path: 'restaurant/menu',
            redirect: (_, s) => s.extra is Map ? null : '/admin/restaurant',
            builder: (_, s) => MenuAdminScreen(outlet: s.extra! as J),
          ),
          GoRoute(path: 'payments', builder: (_, __) => const PaymentsScreen()),
          GoRoute(path: 'reports', builder: (_, __) => const ReportsScreen()),
          GoRoute(path: 'staff', builder: (_, __) => const StaffAdminScreen()),
          GoRoute(path: 'loyalty', builder: (_, __) => const LoyaltyAdminScreen()),
          GoRoute(path: 'content', builder: (_, __) => const ContentScreen()),
          GoRoute(
            path: 'content/edit',
            builder: (_, s) => ContentEditScreen(item: s.extra as J?),
          ),
          GoRoute(path: 'hotel', builder: (_, __) => const HotelSettingsScreen()),
          GoRoute(path: 'audit', builder: (_, __) => const AuditScreen()),
        ],
      ),
    ],
  );
});
