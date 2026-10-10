import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tuloy_app/core/failure.dart';
import 'package:tuloy_app/core/ui.dart';
import 'package:tuloy_app/l10n/app_localizations.dart';

void main() {
  Future<void> pump(WidgetTester t, Object error) async {
    await t.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [...AppLocalizations.localizationsDelegates, DefaultMaterialLocalizations.delegate],
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: AsyncBody<String>(
            value: AsyncValue<String>.error(error, StackTrace.empty),
            onRetry: () {},
            builder: (d) => Text(d),
          ),
        ),
      ),
    );
  }

  const expected =
      "Can't reach the server. Check your connection, or ask your administrator to allow this website.";

  testWidgets('NETWORK failure shows the localized unreachable message', (t) async {
    await pump(t, const Failure('NETWORK'));
    expect(find.text(expected), findsOneWidget);
    expect(find.textContaining('NETWORK'), findsNothing);
    expect(find.textContaining('Failure'), findsNothing);
  });

  testWidgets('other failures keep the server message', (t) async {
    await pump(t, const Failure('ROOM_TAKEN', 'Room is taken.'));
    expect(find.text('Room is taken.'), findsOneWidget);
    expect(find.text(expected), findsNothing);
  });
}
