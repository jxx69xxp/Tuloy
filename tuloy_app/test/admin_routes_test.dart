import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
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

void main() {
  Future<void> open(WidgetTester t, String location) async {
    t.view.devicePixelRatio = 1;
    t.view.physicalSize = const Size(1200, 900);
    addTearDown(t.view.reset);
    final container = ProviderContainer(
      overrides: [
        authProvider.overrideWith(_Admin.new),
        languageProvider.overrideWith((_) => 'en'),
        getProvider('/admin/room-types').overrideWith(
          (ref) async => [
            {'id': 'a', 'name': {'en': 'Alpha'}, 'maxGuests': 2, 'basePrice': 100},
            {'id': 'b', 'name': {'en': 'Beta'}, 'maxGuests': 3, 'basePrice': 200},
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
    await t.pumpAndSettle();
    router.go(location); // what a browser refresh on this URL amounts to
    await t.pumpAndSettle();
  }

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
}
