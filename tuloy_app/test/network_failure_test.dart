import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tuloy_app/core/failure.dart';
import 'package:tuloy_app/core/ui.dart';
import 'package:tuloy_app/features/auth/presentation/widgets.dart' show isWebPlatform;
import 'package:tuloy_app/l10n/app_localizations.dart';

void main() {
  Future<void> pump(WidgetTester t, Object error, {required bool web}) async {
    final saved = isWebPlatform;
    isWebPlatform = web;
    addTearDown(() => isWebPlatform = saved);
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

  const unreachable =
      "Can't reach the server. Check your connection, or ask your administrator to allow this website.";
  const generic = "Can't reach the server. Check your connection.";

  testWidgets('web: NETWORK failure shows the localized unreachable message', (t) async {
    await pump(t, const Failure('NETWORK'), web: true);
    expect(find.text(unreachable), findsOneWidget);
    expect(find.textContaining('NETWORK'), findsNothing);
    expect(find.textContaining('Failure'), findsNothing);
  });

  testWidgets('mobile: NETWORK failure keeps the generic offline message', (t) async {
    await pump(t, const Failure('NETWORK'), web: false);
    expect(find.text(generic), findsOneWidget);
    expect(find.text(unreachable), findsNothing);
  });

  testWidgets('other failures keep the server message', (t) async {
    await pump(t, const Failure('ROOM_TAKEN', 'Room is taken.'), web: true);
    expect(find.text('Room is taken.'), findsOneWidget);
    expect(find.text(unreachable), findsNothing);
  });
}
