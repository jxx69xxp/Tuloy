import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tuloy_app/core/http.dart';
import 'package:tuloy_app/features/staff/desk_screens.dart';
import 'package:tuloy_app/l10n/app_localizations.dart';

const _rooms = [
  {
    'number': '201',
    'floor': '2',
    'roomTypeId': 'std',
    'roomType': 'Standard Double',
    'status': 'occupied',
    'guestName': 'Gina Guest',
    'reservationId': 'r1',
  },
  {
    'number': '202',
    'floor': '2',
    'roomTypeId': 'std',
    'roomType': 'Standard Double',
    'status': 'free',
    'guestName': null,
    'reservationId': null,
  },
  {
    'number': '301',
    'floor': '3',
    'roomTypeId': 'fam',
    'roomType': 'Family Suite',
    'status': 'free',
    'guestName': null,
    'reservationId': null,
  },
];

Future<void> _pump(WidgetTester t, double width) async {
  t.view.physicalSize = Size(width, 900);
  t.view.devicePixelRatio = 1;
  addTearDown(t.view.reset);
  await t.pumpWidget(
    ProviderScope(
      overrides: [
        getProvider('/staff/board').overrideWith(
          (ref) async => const {
            'rooms': _rooms,
            'types': [
              {'roomTypeId': 'std', 'roomType': 'Standard Double', 'photoUrl': null, 'total': 2, 'free': 1},
              {'roomTypeId': 'fam', 'roomType': 'Family Suite', 'photoUrl': null, 'total': 1, 'free': 1},
            ],
          },
        ),
      ],
      child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: RoomsScreen(base: '/staff'),
      ),
    ),
  );
  await t.pumpAndSettle();
}

void main() {
  for (final width in [1400.0, 400.0]) {
    testWidgets('rooms page: grouped by type; available only and search filter (${width.toInt()} wide)', (t) async {
      await _pump(t, width);
      expect(find.textContaining('Family Suite'), findsWidgets);
      expect(find.textContaining('201'), findsWidgets);

      await t.tap(find.text('Available only'));
      await t.pumpAndSettle();
      expect(find.text('201'), findsNothing);
      expect(find.text('202'), findsOneWidget);

      // Search narrows to matching rooms; the Standard Double group disappears.
      await t.enterText(find.byType(TextField), 'family');
      await t.pumpAndSettle();
      expect(find.text('202'), findsNothing);
      expect(find.text('301'), findsOneWidget);
    });
  }
}
