import 'dart:async';

import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:tuloy_app/app/router.dart';
import 'package:tuloy_app/core/config.dart';
import 'package:tuloy_app/core/http.dart';
import 'package:tuloy_app/features/admin/admin_catalog_screens.dart';
import 'package:tuloy_app/features/auth/domain/auth.dart';
import 'package:tuloy_app/features/auth/presentation/auth_controller.dart';
import 'package:tuloy_app/l10n/app_localizations.dart';

class _Admin extends AuthController {
  @override
  Future<User?> build() async => User(
    id: 'u',
    fullName: 'U',
    language: 'en',
    memberships: const [Membership(hotelId: hotelId, role: Role.admin)],
  );
}

/// Restores the session only when [restored] completes, like the real async restore().
class _SlowAdmin extends _Admin {
  _SlowAdmin(this.restored);
  final Completer<void> restored;
  @override
  Future<User?> build() async {
    await restored.future;
    return super.build();
  }
}

void main() {
  Future<GoRouter> start(WidgetTester t, AuthController Function() auth, {List<Override> extra = const []}) async {
    t.view.devicePixelRatio = 1;
    t.view.physicalSize = const Size(1200, 900);
    addTearDown(t.view.reset);
    final container = ProviderContainer(
      overrides: [
        ...extra,
        authProvider.overrideWith(auth),
        languageProvider.overrideWith((_) => 'en'),
        // The shell's notifications bell and chat button.
        getProvider('/staff/notifications').overrideWith((ref) async => const []),
        getProvider('/staff/dashboard').overrideWith((ref) async => const <String, dynamic>{}),
        getProvider('/admin/room-types').overrideWith(
          (ref) async => [
            {'id': 'a', 'name': {'en': 'Alpha'}, 'maxGuests': 2, 'basePrice': 100, 'rooms': []},
            {'id': 'b', 'name': {'en': 'Beta'}, 'maxGuests': 3, 'basePrice': 200, 'rooms': []},
          ],
        ),
      ],
    );
    addTearDown(container.dispose);
    final router = container.read(routerProvider);
    await t.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(
          routerConfig: router,
          localizationsDelegates: const [...AppLocalizations.localizationsDelegates, DefaultMaterialLocalizations.delegate],
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );
    return router;
  }

  /// In-app navigation once signed in (auth already loaded). A real browser refresh is
  /// covered by the 'refresh on a deep link' test below.
  Future<void> open(WidgetTester t, String location) async {
    final router = await start(t, _Admin.new);
    await t.pumpAndSettle();
    router.go(location);
    await t.pumpAndSettle();
  }

  testWidgets('refresh on a deep link reopens it once the session is restored', (t) async {
    // The browser URL is the platform's initial route; auth is still loading on the first frame.
    t.platformDispatcher.defaultRouteNameTestValue = '/admin/rooms/type/b';
    addTearDown(t.platformDispatcher.clearDefaultRouteNameTestValue);
    final restored = Completer<void>();
    await start(t, () => _SlowAdmin(restored));
    await t.pump();
    expect(find.byType(RoomTypeEditScreen), findsNothing); // splash while restoring
    restored.complete();
    await t.pumpAndSettle();
    expect(find.byType(RoomTypeEditScreen), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Beta'), findsOneWidget);
  });

  testWidgets('room type edit URL reopens the item from the list endpoint', (t) async {
    await open(t, '/admin/rooms/type/b');
    expect(find.byType(RoomTypeEditScreen), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Beta'), findsOneWidget);
  });

  testWidgets('/new is not read as an id', (t) async {
    await open(t, '/admin/rooms/type/new');
    expect(find.byType(RoomTypeEditScreen), findsOneWidget);
    expect(find.text('Not found.'), findsNothing);
  });

  testWidgets('unknown id shows not found', (t) async {
    await open(t, '/admin/rooms/type/zzz');
    expect(find.text('Not found.'), findsOneWidget);
  });

  group('room type editor is a dialog over the Rooms list on wide screens', () {
    String path(GoRouter r) => r.routerDelegate.currentConfiguration.uri.path;

    testWidgets('Cancel and Esc close it back to the list', (t) async {
      final router = await start(t, _Admin.new);
      await t.pumpAndSettle();
      router.go('/admin/rooms/type/b');
      await t.pumpAndSettle();
      expect(find.byType(RoomsAdminScreen), findsOneWidget); // list stays underneath
      expect(find.widgetWithText(TextField, 'Beta'), findsOneWidget);
      await t.tap(find.text('Cancel'));
      await t.pumpAndSettle();
      expect(find.byType(RoomTypeEditScreen), findsNothing);
      expect(path(router), '/admin/rooms');

      router.go('/admin/rooms/type/b');
      await t.pumpAndSettle();
      await t.sendKeyEvent(LogicalKeyboardKey.escape);
      await t.pumpAndSettle();
      expect(find.byType(RoomTypeEditScreen), findsNothing);
      expect(path(router), '/admin/rooms');
    });

    testWidgets('Save in the footer sends the edit and closes', (t) async {
      final seen = <RequestOptions>[];
      final dio = Dio(BaseOptions(baseUrl: 'http://api.test'))
        ..interceptors.add(
          InterceptorsWrapper(
            onRequest: (o, h) {
              seen.add(o);
              h.resolve(Response(requestOptions: o, data: {'id': 'b'}));
            },
          ),
        );
      final router = await start(t, _Admin.new, extra: [apiProvider.overrideWithValue(Api(dio))]);
      await t.pumpAndSettle();
      router.go('/admin/rooms/type/b');
      await t.pumpAndSettle();
      await t.tap(find.widgetWithText(FilledButton, 'Save'));
      await t.pumpAndSettle();
      final saves = seen.where((o) => o.method != 'GET').toList(); // the admin home behind also loads
      expect(saves.single.method, 'PATCH');
      expect(saves.single.path, '/admin/room-types/b');
      expect((saves.single.data as Map)['maxGuests'], 3);
      expect(find.byType(RoomTypeEditScreen), findsNothing);
      expect(path(router), '/admin/rooms');
    });
  });
}
