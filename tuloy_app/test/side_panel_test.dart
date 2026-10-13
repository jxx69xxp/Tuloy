import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:tuloy_app/app/router.dart';
import 'package:tuloy_app/core/config.dart';
import 'package:tuloy_app/core/http.dart';
import 'package:tuloy_app/core/web/web_table.dart';
import 'package:tuloy_app/features/auth/domain/auth.dart';
import 'package:tuloy_app/features/auth/presentation/auth_controller.dart';
import 'package:tuloy_app/features/staff/staff_screens.dart';
import 'package:tuloy_app/l10n/app_localizations.dart';

class _Staff extends AuthController {
  @override
  Future<User?> build() async => User(
    id: 'u',
    fullName: 'Sam',
    language: 'en',
    memberships: const [Membership(hotelId: hotelId, role: Role.staff)],
  );
}

const _row = {
  'id': 'r1',
  'guestName': 'Ana Cruz',
  'code': 'TL-1',
  'roomType': 'Deluxe',
  'room': '101',
  'checkIn': '2026-10-20',
  'checkOut': '2026-10-22',
  'status': 'CONFIRMED',
};

const _detail = {
  'id': 'r1',
  'code': 'TL-1',
  'status': 'CONFIRMED',
  'guest': {'fullName': 'Ana Cruz', 'email': 'ana@example.test'},
  'roomType': {'name': 'Deluxe'},
  'room': '101',
  'checkIn': '2026-10-20',
  'checkOut': '2026-10-22',
  'adults': 2,
  'children': 0,
  'price': {'total': 5000},
  'paid': 0,
  'balance': 5000,
  'currency': 'PHP',
  'history': [],
};

Future<GoRouter> _start(WidgetTester t, double width, String location) async {
  t.view.devicePixelRatio = 1;
  t.view.physicalSize = Size(width, 900);
  addTearDown(t.view.reset);
  final container = ProviderContainer(
    overrides: [
      authProvider.overrideWith(_Staff.new),
      languageProvider.overrideWith((_) => 'en'),
      getProvider('/staff/dashboard').overrideWith((ref) async => const <String, dynamic>{}),
      getProvider('/staff/reservations?view=upcoming').overrideWith((ref) async => [_row]),
      getProvider('/staff/reservations/r1').overrideWith((ref) async => _detail),
    ],
  );
  addTearDown(container.dispose);
  final router = container.read(routerProvider);
  await t.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp.router(
        routerConfig: router,
        localizationsDelegates: const [
          ...AppLocalizations.localizationsDelegates,
          DefaultMaterialLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    ),
  );
  await t.pumpAndSettle();
  router.go(location);
  await t.pumpAndSettle();
  return router;
}

String _path(GoRouter r) => r.routerDelegate.currentConfiguration.uri.path;

void main() {
  testWidgets('wide: a row opens the detail as a side panel over the queue', (t) async {
    final router = await _start(t, 1400, '/staff/reservations');
    await t.tap(find.text('Ana Cruz'));
    await t.pumpAndSettle();
    expect(_path(router), '/staff/reservations/r1');
    expect(find.byType(StaffReservationScreen), findsOneWidget);
    expect(find.byType(WebTable), findsOneWidget); // queue still underneath
    expect(find.text('ana@example.test'), findsOneWidget);
  });

  testWidgets('wide: deep link shows queue + panel; Esc closes back to the queue', (t) async {
    final router = await _start(t, 1400, '/staff/reservations/r1');
    expect(find.byType(StaffReservationScreen), findsOneWidget);
    expect(find.byType(WebTable), findsOneWidget);
    await t.sendKeyEvent(LogicalKeyboardKey.escape);
    await t.pumpAndSettle();
    expect(find.byType(StaffReservationScreen), findsNothing);
    expect(find.byType(WebTable), findsOneWidget);
    expect(_path(router), '/staff/reservations');
  });

  testWidgets('wide: close button closes the panel', (t) async {
    final router = await _start(t, 1400, '/staff/reservations/r1');
    await t.tap(find.byTooltip('Close'));
    await t.pumpAndSettle();
    expect(find.byType(StaffReservationScreen), findsNothing);
    expect(_path(router), '/staff/reservations');
  });

  testWidgets('narrow: a row opens the full detail screen', (t) async {
    final router = await _start(t, 400, '/staff/reservations');
    await t.tap(find.text('Ana Cruz · TL-1'));
    await t.pumpAndSettle();
    expect(find.byType(StaffReservationScreen), findsOneWidget);
    expect(find.byType(ReservationsQueueScreen).hitTestable(), findsNothing); // covered by the opaque page
    expect(find.byTooltip('Back'), findsOneWidget);
    await t.tap(find.byTooltip('Back'));
    await t.pumpAndSettle();
    expect(find.text('Ana Cruz · TL-1'), findsOneWidget);
    expect(_path(router), '/staff/reservations');
  });
}
