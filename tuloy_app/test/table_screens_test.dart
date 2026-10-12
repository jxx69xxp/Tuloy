import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tuloy_app/core/http.dart';
import 'package:tuloy_app/core/web/web_table.dart';
import 'package:tuloy_app/features/admin/admin_catalog_screens.dart';
import 'package:tuloy_app/features/admin/admin_screens.dart';
import 'package:tuloy_app/features/staff/staff_screens.dart';
import 'package:tuloy_app/l10n/app_localizations.dart';

void main() {
  Future<void> pump(WidgetTester t, double w) async {
    t.view.devicePixelRatio = 1;
    t.view.physicalSize = Size(w, 800);
    addTearDown(t.view.reset);
    await t.pumpWidget(
      ProviderScope(
        overrides: [
          getProvider('/admin/audit').overrideWith(
            (ref) async => [
              {'action': 'REFUND', 'entityType': 'Payment', 'at': '2026-10-01T10:00:00Z', 'actorId': 'actor-1'},
            ],
          ),
        ],
        child: const MaterialApp(
          localizationsDelegates: [...AppLocalizations.localizationsDelegates, DefaultMaterialLocalizations.delegate],
          supportedLocales: AppLocalizations.supportedLocales,
          home: AuditScreen(),
        ),
      ),
    );
    await t.pumpAndSettle();
  }

  testWidgets('audit log is a table on wide screens', (t) async {
    await pump(t, 1200);
    expect(find.byType(WebTable), findsOneWidget);
    expect(find.text('Action'), findsOneWidget);
    expect(find.text('REFUND'), findsOneWidget);
    expect(find.text('actor-1'), findsOneWidget);
  });

  testWidgets('audit log stays a list on narrow screens', (t) async {
    await pump(t, 400);
    expect(find.byType(WebTable), findsNothing);
    expect(find.byType(ListTile), findsOneWidget);
    expect(find.text('REFUND · Payment'), findsOneWidget);
  });

  Future<void> queue(WidgetTester t, double w) async {
    t.view.devicePixelRatio = 1;
    t.view.physicalSize = Size(w, 800);
    addTearDown(t.view.reset);
    await t.pumpWidget(
      ProviderScope(
        overrides: [
          getProvider('/staff/reservations?view=upcoming').overrideWith(
            (ref) async => [
              {
                'id': 'r1',
                'guestName': 'Ana Cruz',
                'code': 'TL-1',
                'roomType': 'Deluxe',
                'room': '101',
                'checkIn': '2026-10-20',
                'checkOut': '2026-10-22',
                'status': 'CONFIRMED',
              },
            ],
          ),
        ],
        child: const MaterialApp(
          localizationsDelegates: [...AppLocalizations.localizationsDelegates, DefaultMaterialLocalizations.delegate],
          supportedLocales: AppLocalizations.supportedLocales,
          home: ReservationsQueueScreen(base: '/staff'),
        ),
      ),
    );
    await t.pumpAndSettle();
  }

  testWidgets('reservations queue is a table with a view dropdown on wide screens', (t) async {
    await queue(t, 1200);
    expect(find.byType(WebTable), findsOneWidget);
    expect(find.byType(DropdownButton<String>), findsOneWidget);
    expect(find.byType(ChoiceChip), findsNothing);
    expect(find.text('Ana Cruz'), findsOneWidget);
  });

  testWidgets('reservations queue keeps chips and list on narrow screens', (t) async {
    await queue(t, 400);
    expect(find.byType(WebTable), findsNothing);
    expect(find.byType(ChoiceChip), findsWidgets);
    expect(find.text('Ana Cruz · TL-1'), findsOneWidget);
  });

  Future<void> screen(WidgetTester t, double w, String path, Object data, Widget home) async {
    t.view.devicePixelRatio = 1;
    t.view.physicalSize = Size(w, 800);
    addTearDown(t.view.reset);
    await t.pumpWidget(
      ProviderScope(
        overrides: [getProvider(path).overrideWith((ref) async => data)],
        child: MaterialApp(
          localizationsDelegates: const [
            ...AppLocalizations.localizationsDelegates,
            DefaultMaterialLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: home,
        ),
      ),
    );
    await t.pumpAndSettle();
  }

  const roomTypes = [
    {
      'id': 'rt1',
      'name': {'en': 'Deluxe'},
      'maxGuests': 2,
      'basePrice': 3500,
      'active': true,
      'rooms': [
        {'id': 'r1', 'number': '101', 'active': true},
      ],
    },
  ];

  testWidgets('rooms: wide table, expanding shows the room chips', (t) async {
    await screen(t, 1200, '/admin/room-types', roomTypes, const RoomsAdminScreen());
    expect(find.byType(WebTable), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsNothing);
    expect(find.widgetWithText(FilledButton, 'Add'), findsOneWidget);
    expect(find.byTooltip('Room blocks'), findsOneWidget);
    expect(find.widgetWithText(InputChip, '101'), findsNothing);
    await t.tap(find.byTooltip('Show details'));
    await t.pumpAndSettle();
    expect(find.widgetWithText(InputChip, '101'), findsOneWidget);
    expect(find.text('Add room'), findsOneWidget);
  });

  testWidgets('rooms: narrow keeps the cards', (t) async {
    await screen(t, 400, '/admin/room-types', roomTypes, const RoomsAdminScreen());
    expect(find.byType(WebTable), findsNothing);
    expect(find.byType(FloatingActionButton), findsOneWidget);
    expect(find.widgetWithText(InputChip, '101'), findsOneWidget);
  });

  const outlets = [
    {
      'id': 'o1',
      'name': {'en': 'Cafe'},
      'schedule': {'from': '06:00', 'to': '22:00'},
      'tables': [
        {'id': 't1', 'label': 'T1'},
      ],
    },
  ];

  testWidgets('restaurant: wide table, expanding shows the table chips', (t) async {
    await screen(t, 1200, '/admin/outlets', outlets, const RestaurantAdminScreen());
    expect(find.byType(WebTable), findsOneWidget);
    expect(find.text('06:00–22:00'), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsNothing);
    expect(find.widgetWithText(ActionChip, 'T1'), findsNothing);
    await t.tap(find.byTooltip('Show details'));
    await t.pumpAndSettle();
    expect(find.widgetWithText(ActionChip, 'T1'), findsOneWidget);
    expect(find.text('Add table'), findsOneWidget);
  });

  testWidgets('restaurant: narrow keeps the cards', (t) async {
    await screen(t, 400, '/admin/outlets', outlets, const RestaurantAdminScreen());
    expect(find.byType(WebTable), findsNothing);
    expect(find.byType(FloatingActionButton), findsOneWidget);
    expect(find.widgetWithText(ActionChip, 'T1'), findsOneWidget);
  });
}
