import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tuloy_app/features/staff/desk_screens.dart';
import 'package:tuloy_app/l10n/app_localizations.dart';

Future<void> _open(WidgetTester t) async {
  await t.pumpWidget(
    const ProviderScope(
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: DeskBookDialog(room: {'id': 'r1', 'number': '205', 'roomType': 'Standard Double'})),
      ),
    ),
  );
  await t.pumpAndSettle();
}

void main() {
  testWidgets('book a room: name and an email or phone are required; arriving today can check in', (t) async {
    await _open(t);
    expect(find.text('Book room 205 · Standard Double'), findsOneWidget);
    expect(find.text('Book and check in'), findsOneWidget); // arrival defaults to today

    await t.tap(find.text('Reserve'));
    await t.pump();
    expect(find.text('Required'), findsOneWidget); // full name
    expect(find.text('Enter an email or phone number'), findsNWidgets(2));

    // A valid form goes to the API; booking itself is covered by tuloy-api/test/desk.spec.ts.
  });
}
