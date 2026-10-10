import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tuloy_app/core/find_by_id.dart';
import 'package:tuloy_app/core/http.dart';
import 'package:tuloy_app/l10n/app_localizations.dart';

void main() {
  Future<void> pump(WidgetTester t, Future<dynamic> Function() load, {String id = 'b'}) async {
    await t.pumpWidget(
      ProviderScope(
        overrides: [getProvider('/admin/room-types').overrideWith((ref) => load())],
        child: MaterialApp(
          localizationsDelegates: const [...AppLocalizations.localizationsDelegates, DefaultMaterialLocalizations.delegate],
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: FindById(
              listPath: '/admin/room-types',
              id: id,
              builder: (_, item) => Text('found ${item['name']}'),
            ),
          ),
        ),
      ),
    );
  }

  final rows = [
    {'id': 'a', 'name': 'Alpha'},
    {'id': 'b', 'name': 'Beta'},
  ];

  testWidgets('builds with the matching item', (t) async {
    await pump(t, () async => rows);
    await t.pumpAndSettle();
    expect(find.text('found Beta'), findsOneWidget);
  });

  testWidgets('shows not found when the id is absent', (t) async {
    await pump(t, () async => rows, id: 'zzz');
    await t.pumpAndSettle();
    expect(find.text('Not found.'), findsOneWidget);
    expect(find.textContaining('found Beta'), findsNothing);
  });

  testWidgets('shows an error with retry when loading fails', (t) async {
    await pump(t, () async => throw Exception('boom'));
    await t.pumpAndSettle();
    expect(find.text('Try again'), findsOneWidget);
  });

  testWidgets('shows a progress indicator while loading', (t) async {
    final never = Completer<dynamic>();
    await pump(t, () => never.future);
    await t.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
