import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tuloy_app/core/http.dart';
import 'package:tuloy_app/core/web/web_table.dart';
import 'package:tuloy_app/l10n/app_localizations.dart';

/// Rows "n0".."n{count-1}" with amount = (i * 7) % count, so text and numeric order differ.
List<J> _rows(int count) => [
  for (var i = 0; i < count; i++) {'id': '$i', 'name': 'n$i', 'amount': (i * 7) % count},
];

Future<void> _pump(WidgetTester t, List<J> rows, {void Function(J)? onTap}) async {
  t.view.devicePixelRatio = 1;
  t.view.physicalSize = const Size(1200, 900);
  addTearDown(t.view.reset);
  await t.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: WebTable(
          value: AsyncData<dynamic>(rows),
          onRetry: () {},
          table: JsonTable(
            columns: const ['Name', 'Amount'],
            cells: (_, r) => ['${r['name']}', '${r['amount']}'],
            sortKeys: [(r) => '${r['name']}', (r) => r['amount'] as num],
            onTap: onTap,
            actions: (_, r) => [
              IconButton(tooltip: 'Delete ${r['name']}', icon: const Icon(Icons.delete), onPressed: () {}),
            ],
          ),
        ),
      ),
    ),
  );
  await t.pumpAndSettle();
}

/// Cell texts of the given column, top to bottom, among the rows built on screen.
List<String> _column(WidgetTester t, String prefix) => [
  for (final e
      in find.descendant(of: find.byType(ListView), matching: find.textContaining(RegExp('^$prefix'))).evaluate())
    (e.widget as Text).data!,
];

double _y(WidgetTester t, String text) => t.getTopLeft(find.text(text)).dy;

void main() {
  testWidgets('sorting toggles order, numbers by value', (t) async {
    await _pump(t, [
      {'id': 'a', 'name': 'b', 'amount': 10},
      {'id': 'b', 'name': 'a', 'amount': 9},
      {'id': 'c', 'name': 'c', 'amount': 100},
    ]);
    await t.tap(find.text('Amount'));
    await t.pumpAndSettle();
    expect(_y(t, '9') < _y(t, '10') && _y(t, '10') < _y(t, '100'), isTrue); // not "10" < "100" < "9"
    expect(find.byWidgetPredicate((w) => w is Icon && w.semanticLabel == 'Sorted ascending'), findsOneWidget);
    await t.tap(find.text('Amount'));
    await t.pumpAndSettle();
    expect(_y(t, '100') < _y(t, '10') && _y(t, '10') < _y(t, '9'), isTrue);
    await t.tap(find.text('Name'));
    await t.pumpAndSettle();
    expect(_y(t, 'a') < _y(t, 'b') && _y(t, 'b') < _y(t, 'c'), isTrue);
    expect(find.byTooltip('Sort by Name'), findsOneWidget);
  });

  testWidgets('search filters rows after a short pause', (t) async {
    await _pump(t, _rows(12));
    await t.enterText(find.byType(TextField), 'n1');
    await t.pump(const Duration(milliseconds: 300));
    expect(_column(t, 'n'), ['n1', 'n10', 'n11']);
    await t.enterText(find.byType(TextField), 'zzz');
    await t.pump(const Duration(milliseconds: 300));
    expect(find.text('Nothing here yet.'), findsOneWidget);
  });

  testWidgets('shows 50 rows, then the next page on Show more', (t) async {
    await _pump(t, _rows(60));
    final more = find.textContaining('Show more');
    await t.scrollUntilVisible(more, 300, scrollable: find.byType(Scrollable).last);
    expect(find.textContaining('50 of 60'), findsOneWidget);
    await t.tap(more);
    await t.pumpAndSettle();
    expect(more, findsNothing);
    await t.scrollUntilVisible(find.text('n59'), 300, scrollable: find.byType(Scrollable).last);
    expect(find.text('n59'), findsOneWidget);
  });

  testWidgets('row tap and Enter call the handler; row actions show', (t) async {
    final taps = <String>[];
    await _pump(t, _rows(3), onTap: (r) => taps.add('${r['id']}'));
    expect(find.byTooltip('Delete n1'), findsOneWidget);
    await t.tap(find.text('n1'));
    await t.pumpAndSettle();
    expect(taps, ['1']);
    Focus.of(t.element(find.text('n1'))).requestFocus(); // as if reached with Tab
    await t.pump();
    await t.sendKeyEvent(LogicalKeyboardKey.enter);
    await t.pumpAndSettle();
    expect(taps, ['1', '1']);
  });
}
