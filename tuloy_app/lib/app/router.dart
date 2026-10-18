import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/adaptive.dart';
import '../core/ui.dart' show ThemeMenuButton;
import '../core/config.dart';
import '../core/web/overlays.dart';
import '../features/auth/domain/auth.dart';
import '../features/auth/presentation/auth_controller.dart';
import '../features/auth/presentation/auth_screens.dart';
import '../features/auth/presentation/widgets.dart' show SplashScreen;
import '../features/booking/domain/booking.dart';
import '../features/booking/presentation/booking_screens.dart';
import '../features/booking/presentation/my_bookings_screens.dart';
import '../features/booking/presentation/stay_screens.dart';
import '../core/find_by_id.dart';
import '../features/admin/admin_catalog_screens.dart';
import '../features/admin/admin_people_screens.dart';
import '../features/admin/admin_screens.dart';
import '../features/chat/chat_screen.dart';
import '../features/loyalty/loyalty_wifi_screens.dart';
import '../features/restaurant/restaurant_screens.dart';
import '../features/services/services_screens.dart';
import '../features/staff/desk_screens.dart';
import '../features/staff/staff_screens.dart';
import '../features/settings/presentation/profile_screen.dart';
import '../features/settings/presentation/settings_screen.dart';
import '../l10n/app_localizations.dart';

const _public = {'/signin', '/signup', '/reset'};

/// Chat thread; the title (guest name / hotel) rides along as `extra`.
final _chat = GoRoute(
  path: 'chat/:id',
  builder: (_, s) => ChatScreen(id: s.pathParameters['id']!, title: s.extra as String?),
);

/// Front-desk screens, mounted under /staff and under /admin/desk.
List<RouteBase> _deskRoutes(String base) => [
  GoRoute(
    path: 'reservations',
    // ?q= arrives from the guest list: open with that search applied.
    builder: (_, s) => ReservationsQueueScreen(base: base, q: s.uri.queryParameters['q']),
    routes: [
      // Nested so that on wide screens the detail is a side panel over the queue (also on refresh/deep link).
      GoRoute(
        path: ':id',
        pageBuilder: (c, s) =>
            adaptivePage(c, s, StaffReservationScreen(id: s.pathParameters['id']!, panel: isWide(c)), panel: true),
      ),
    ],
  ),
  GoRoute(path: 'tasks', builder: (_, __) => const TasksScreen()),
  GoRoute(path: 'orders', builder: (_, __) => const OrdersQueueScreen()),
  // Wide: inbox and inbox/chat/:id share one page key, so the list keeps its state while threads switch.
  GoRoute(
    path: 'inbox',
    pageBuilder: (c, s) => _inboxPage(c, s, base, InboxScreen(base: base)),
  ),
  GoRoute(
    path: 'inbox/chat/:id',
    pageBuilder: (c, s) => _inboxPage(
      c,
      s,
      base,
      isWide(c)
          ? InboxScreen(base: base, openId: s.pathParameters['id'], openTitle: s.extra as String?)
          : ChatScreen(id: s.pathParameters['id']!, title: s.extra as String?),
    ),
  ),
  GoRoute(path: 'leave', builder: (_, __) => const LeaveScreen()),
  GoRoute(
    path: 'rooms',
    builder: (_, __) => RoomsScreen(base: base),
  ),
  GoRoute(
    path: 'guests',
    builder: (_, __) => GuestListScreen(base: base),
  ),
  GoRoute(path: 'team', builder: (_, __) => const TeamScreen()),
  GoRoute(
    path: 'chat/:id',
    builder: (_, s) => ChatScreen(id: s.pathParameters['id']!, title: s.extra as String?),
  ),
];

Page<void> _inboxPage(BuildContext c, GoRouterState s, String base, Widget child) => isWide(c)
    ? NoTransitionPage(key: ValueKey('$base/inbox'), child: child)
    : MaterialPage(key: s.pageKey, restorationId: s.pageKey.value, child: child);

List<RailItem> _staffItems(AppLocalizations l) => [
  RailItem(Icons.support_agent, l.frontDesk, '/staff', section: l.frontDesk),
  RailItem(Icons.book_online_outlined, l.reservations, '/staff/reservations', section: l.frontDesk),
  RailItem(Icons.bed_outlined, l.rooms, '/staff/rooms', section: l.frontDesk),
  RailItem(Icons.room_service_outlined, l.serviceRequests, '/staff/tasks', section: l.frontDesk),
  RailItem(Icons.restaurant, l.restaurant, '/staff/orders', section: l.frontDesk),
  RailItem(Icons.chat_bubble_outline, l.chat, '/staff/inbox', section: l.frontDesk),
  RailItem(Icons.people_outline, l.guestList, '/staff/guests', section: l.navPeople),
  RailItem(Icons.groups_outlined, l.team, '/staff/team', section: l.navPeople),
  RailItem(Icons.beach_access_outlined, l.leaveRequests, '/staff/leave', section: l.navPeople),
];

/// Breadcrumb labels for the desk screens mounted under /admin/desk.
Map<String, String> _deskLabels(AppLocalizations l) => {
  for (final i in _staffItems(l).skip(1)) i.path.replaceFirst('/staff', '/admin/desk'): i.label,
};

List<RailItem> _adminItems(AppLocalizations l) => [
  RailItem(Icons.dashboard_outlined, l.adminHome, '/admin', section: l.navOverview),
  RailItem(Icons.support_agent, l.frontDesk, '/admin/desk', section: l.navOverview),
  RailItem(Icons.bed_outlined, l.roomsAndRates, '/admin/rooms', section: l.navCatalog),
  RailItem(Icons.room_service_outlined, l.services, '/admin/services', section: l.navCatalog),
  RailItem(Icons.restaurant, l.restaurant, '/admin/restaurant', section: l.navCatalog),
  RailItem(Icons.loyalty_outlined, l.loyalty, '/admin/loyalty', section: l.navCatalog),
  RailItem(Icons.article_outlined, l.content, '/admin/content', section: l.navCatalog),
  RailItem(Icons.payments_outlined, l.payments, '/admin/payments', section: l.navFinance),
  RailItem(Icons.bar_chart, l.reports, '/admin/reports', section: l.navFinance),
  RailItem(Icons.people_outline, l.guestList, '/admin/desk/guests', section: l.navPeople),
  RailItem(Icons.badge_outlined, l.staff, '/admin/staff', section: l.navPeople),
  RailItem(Icons.hotel_outlined, l.hotelSettings, '/admin/hotel', section: l.navSystem),
  RailItem(Icons.history, l.auditLog, '/admin/audit', section: l.navSystem),
];

/// Area shell with the signed-in user's name and sign out for the wide sidebar.
/// [desk]: the front-desk base path ('/staff' or '/admin/desk') for notifications and the chat button;
/// null for areas without guest-facing work (restaurant).
Widget _shell(
  List<RailItem> Function(AppLocalizations) items,
  GoRouterState s,
  Widget child, {
  String? desk = '/staff',
  bool deskLabels = false,
}) => Consumer(
  builder: (c, ref, _) {
    final l = AppLocalizations.of(c);
    return AdaptiveShell(
      items: items(l),
      labels: deskLabels ? _deskLabels(l) : const {},
      location: s.uri.path,
      userName: ref.watch(authProvider).valueOrNull?.fullName,
      onSignOut: () => ref.read(authProvider.notifier).signOut(),
      topActions: [
        const ThemeMenuButton(),
        if (desk != null) DeskNotifications(base: desk),
      ],
      fab: desk == null || s.uri.path.contains('/inbox') ? null : DeskChatButton(base: desk),
      child: child,
    );
  },
);

List<RailItem> _guestItems(AppLocalizations l) => [
  RailItem(Icons.home_outlined, l.guestHome, '/guest', section: l.stays),
  RailItem(Icons.search, l.findRoom, '/guest/search', section: l.stays),
  RailItem(Icons.event_note_outlined, l.myBookings, '/guest/bookings', section: l.stays),
  RailItem(Icons.room_service_outlined, l.services, '/guest/services', section: l.services),
  RailItem(Icons.assignment_outlined, l.myRequests, '/guest/requests', section: l.services),
  RailItem(Icons.qr_code_scanner, l.scanTable, '/guest/scan', section: l.services),
  RailItem(Icons.menu_book_outlined, l.hotelGuide, '/guest/guide', section: l.services),
  RailItem(Icons.loyalty_outlined, l.loyalty, '/guest/loyalty', section: l.profile),
  RailItem(Icons.account_circle_outlined, l.profile, '/guest/profile', section: l.profile),
];

List<RailItem> _restaurantItems(AppLocalizations l) => [
  RailItem(Icons.receipt_long_outlined, l.restaurantOrders, '/restaurant', section: l.restaurant),
  RailItem(Icons.menu_book_outlined, l.menu, '/restaurant/menu', section: l.restaurant),
  RailItem(Icons.beach_access_outlined, l.leaveRequests, '/restaurant/leave', section: l.navPeople),
];

/// Where a signed-in user belongs. Each role only sees its own area (plus /settings).
/// UI guard only — the API enforces roles and permissions on every call.
String homeFor(Role role) => switch (role) {
  Role.guest => '/guest',
  Role.restaurant => '/restaurant',
  Role.staff => '/staff',
  Role.admin => '/admin',
};

/// Pure so it can be unit-tested: decides the redirect for a location.
///
/// [uri] is the full requested URI. When given, a deep link (e.g. a browser refresh while the
/// session is still restoring, or an expired session) rides through /splash and /signin as
/// `?from=` and is reopened afterwards if it is internal and the user's role may open it.
String? redirectFor({required String location, required AsyncValue<User?> auth, Uri? uri, bool isWeb = kIsWeb}) {
  final detour = location == '/splash' || _public.contains(location);
  // Where the user was heading: carried along while detouring, else the requested URI itself.
  final target = detour ? uri?.queryParameters['from'] : uri?.toString();
  String withFrom(String path) => target == null ? path : '$path?from=${Uri.encodeComponent(target)}';

  if (auth.isLoading && !auth.hasValue) return location == '/splash' ? null : withFrom('/splash');
  final user = auth.valueOrNull;
  if (user == null) return _public.contains(location) ? null : withFrom('/signin');
  final role = user.roleAt(hotelId);
  final home = homeFor(role);
  if (detour && target != null && _isInternal(target) && _allowed(Uri.parse(target).path, home)) return target;
  if (location == '/settings' || location.startsWith(home)) return null;
  return home;
}

/// An in-app path: no scheme or host, and not protocol-relative (`//x`, `/\x`).
bool _isInternal(String s) {
  if (!s.startsWith('/') || s.startsWith('//') || s.contains(r'\')) return false;
  final u = Uri.tryParse(s);
  return u != null && !u.hasScheme && !u.hasAuthority;
}

bool _allowed(String path, String home) =>
    path == '/settings' || path.startsWith('/settings/') || path == home || path.startsWith('$home/');

final routerProvider = Provider<GoRouter>((ref) {
  final refresh = ValueNotifier(0);
  ref.listen(authProvider, (_, __) => refresh.value++);
  ref.onDispose(refresh.dispose);

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: refresh,
    redirect: (_, state) => redirectFor(location: state.matchedLocation, uri: state.uri, auth: ref.read(authProvider)),
    routes: [
      GoRoute(path: '/splash', builder: (_, __) => const SplashScreen()),
      GoRoute(path: '/signin', builder: (_, __) => const SignInScreen()),
      GoRoute(path: '/signup', builder: (_, __) => const SignUpScreen()),
      GoRoute(path: '/reset', builder: (_, __) => const ResetScreen()),
      GoRoute(path: '/settings', builder: (_, __) => const SettingsScreen()),
      ShellRoute(
        builder: (_, s, child) => _shell(_guestItems, s, child, desk: null),
        routes: [
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
        ],
      ),
      ShellRoute(
        builder: (_, s, child) => _shell(_restaurantItems, s, child, desk: null),
        routes: [
          GoRoute(
            path: '/restaurant',
            builder: (_, __) => const OrdersQueueScreen(),
            routes: [
              GoRoute(path: 'menu', builder: (_, __) => const RestaurantMenuScreen()),
              GoRoute(path: 'leave', builder: (_, __) => const LeaveScreen()),
            ],
          ),
        ],
      ),
      ShellRoute(
        builder: (_, s, child) => _shell(_staffItems, s, child),
        routes: [GoRoute(path: '/staff', builder: (_, __) => const StaffHomeScreen(), routes: _deskRoutes('/staff'))],
      ),
      ShellRoute(
        builder: (_, s, child) => _shell(_adminItems, s, child, desk: '/admin/desk', deskLabels: true),
        routes: [
          GoRoute(
            path: '/admin',
            builder: (_, __) => const AdminHomeScreen(),
            routes: [
              GoRoute(
                path: 'desk',
                builder: (_, __) => const StaffHomeScreen(base: '/admin/desk'),
                routes: _deskRoutes('/admin/desk'),
              ),
              GoRoute(
                path: 'rooms',
                builder: (_, __) => const RoomsAdminScreen(),
                routes: [
                  // Nested so that on wide screens the editor is a dialog over the Rooms list.
                  GoRoute(path: 'type/new', pageBuilder: (c, s) => adaptivePage(c, s, const RoomTypeEditScreen())),
                  GoRoute(
                    path: 'type/:id',
                    pageBuilder: (c, s) => adaptivePage(
                      c,
                      s,
                      FindById(
                        listPath: '/admin/room-types',
                        id: s.pathParameters['id']!,
                        builder: (_, t) => RoomTypeEditScreen(type: t),
                      ),
                    ),
                  ),
                ],
              ),
              GoRoute(
                path: 'rooms/:id/rates',
                builder: (_, s) => FindById(
                  listPath: '/admin/room-types',
                  id: s.pathParameters['id']!,
                  builder: (_, t) => RatesScreen(type: t),
                ),
              ),
              GoRoute(path: 'rooms/blocks', builder: (_, __) => const BlocksScreen()),
              GoRoute(path: 'services', builder: (_, __) => const ServicesAdminScreen()),
              GoRoute(path: 'services/new', builder: (_, __) => const ServiceEditScreen()),
              GoRoute(
                path: 'services/:id',
                builder: (_, s) => ServiceEditScreen(id: s.pathParameters['id']),
              ),
              GoRoute(path: 'restaurant', builder: (_, __) => const RestaurantAdminScreen()),
              GoRoute(
                path: 'restaurant/:id/menu',
                builder: (_, s) => FindById(
                  listPath: '/admin/outlets',
                  id: s.pathParameters['id']!,
                  builder: (_, o) => MenuAdminScreen(outlet: o),
                ),
              ),
              GoRoute(path: 'payments', builder: (_, __) => const PaymentsScreen()),
              GoRoute(path: 'reports', builder: (_, __) => const ReportsScreen()),
              GoRoute(path: 'staff', builder: (_, __) => const StaffAdminScreen()),
              GoRoute(path: 'loyalty', builder: (_, __) => const LoyaltyAdminScreen()),
              GoRoute(
                path: 'content',
                builder: (_, __) => const ContentScreen(),
                routes: [
                  GoRoute(path: 'new', pageBuilder: (c, s) => adaptivePage(c, s, const ContentEditScreen())),
                  GoRoute(
                    path: ':id',
                    pageBuilder: (c, s) => adaptivePage(
                      c,
                      s,
                      FindById(
                        listPath: '/admin/content',
                        id: s.pathParameters['id']!,
                        builder: (_, c) => ContentEditScreen(item: c),
                      ),
                    ),
                  ),
                ],
              ),
              GoRoute(path: 'hotel', builder: (_, __) => const HotelSettingsScreen()),
              GoRoute(path: 'audit', builder: (_, __) => const AuditScreen()),
            ],
          ),
        ],
      ),
    ],
  );
});
