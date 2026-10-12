import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:tuloy_app/core/adaptive.dart';
import 'package:tuloy_app/l10n/app_localizations.dart';

const _items = [
  RailItem(Icons.home, 'Home', '/admin', section: 'Overview'),
  RailItem(Icons.bed, 'Rooms', '/admin/rooms', section: 'Catalog'),
  RailItem(Icons.list, 'Reports', '/admin/reports', section: 'Finance'),
];

Widget _app(GoRouter router) => MaterialApp.router(
  routerConfig: router,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
);

/// The sidebar entry for [label].
ListTile _tile(WidgetTester t, String label) => t.widget<ListTile>(find.widgetWithText(ListTile, label));

GoRouter _router({String initial = '/admin'}) => GoRouter(
  initialLocation: initial,
  routes: [
    ShellRoute(
      builder: (c, s, child) => AdaptiveShell(items: _items, location: s.uri.path, child: child),
      routes: [
        GoRoute(path: '/admin', builder: (_, __) => const Text('page-home')),
        GoRoute(path: '/admin/rooms', builder: (_, __) => const Text('page-rooms')),
        GoRoute(path: '/admin/rooms/type', builder: (_, __) => const Text('page-type')),
        GoRoute(path: '/admin/reports', builder: (_, __) => const Text('page-reports')),
      ],
    ),
  ],
);

void main() {
  _rails();
  _tables();

  Future<void> size(WidgetTester t, double w) async {
    t.view.devicePixelRatio = 1;
    t.view.physicalSize = Size(w, 800);
    addTearDown(t.view.reset);
  }

  testWidgets('narrow shows only the child', (t) async {
    await size(t, 400);
    await t.pumpWidget(_app(_router()));
    await t.pumpAndSettle();
    expect(find.byType(ListTile), findsNothing);
    expect(find.text('OVERVIEW'), findsNothing);
    expect(find.text('page-home'), findsOneWidget);
  });

  testWidgets('wide shows sidebar sections, breadcrumbs and navigates on tap', (t) async {
    t.view.devicePixelRatio = 1;
    t.view.physicalSize = const Size(1400, 900);
    addTearDown(t.view.reset);
    await t.pumpWidget(_app(_router(initial: '/admin/rooms/type')));
    await t.pumpAndSettle();
    for (final s in ['OVERVIEW', 'CATALOG', 'FINANCE']) {
      expect(find.text(s), findsOneWidget);
    }
    // Breadcrumbs: Home > Rooms > Details (unlabelled tail).
    expect(find.widgetWithText(TextButton, 'Home'), findsOneWidget);
    expect(find.widgetWithText(TextButton, 'Rooms'), findsOneWidget);
    expect(find.text('Details'), findsOneWidget);
    expect(find.byTooltip('Settings'), findsWidgets);
    await t.tap(find.widgetWithText(ListTile, 'Reports'));
    await t.pumpAndSettle();
    expect(find.text('page-reports'), findsOneWidget);
    await t.tap(find.widgetWithText(ListTile, 'Rooms'));
    await t.pumpAndSettle();
    expect(find.text('page-rooms'), findsOneWidget);
  });

  testWidgets('longest prefix selects the item', (t) async {
    await size(t, 1200);
    await t.pumpWidget(_app(_router(initial: '/admin/rooms/type')));
    await t.pumpAndSettle();
    expect(_tile(t, 'Rooms').selected, isTrue);
    expect(_tile(t, 'Home').selected, isFalse);
  });

  testWidgets('resizing keeps the location', (t) async {
    await size(t, 1200);
    await t.pumpWidget(_app(_router(initial: '/admin/reports')));
    await t.pumpAndSettle();
    await size(t, 400);
    await t.pumpAndSettle();
    expect(find.byType(ListTile), findsNothing);
    expect(find.text('page-reports'), findsOneWidget);
    await size(t, 1200);
    await t.pumpAndSettle();
    expect(_tile(t, 'Reports').selected, isTrue);
    expect(find.text('page-reports'), findsOneWidget);
  });
}

void _rails() {
  testWidgets('rail scrolls on short screens with many items', (t) async {
    t.view.devicePixelRatio = 1;
    t.view.physicalSize = const Size(1200, 500);
    addTearDown(t.view.reset);
    final items = [for (var i = 0; i < 12; i++) RailItem(Icons.circle, 'Item $i', '/p$i')];
    final router = GoRouter(
      initialLocation: '/p0',
      routes: [
        ShellRoute(
          builder: (c, s, child) => AdaptiveShell(items: items, location: s.uri.path, child: child),
          routes: [for (var i = 0; i < 12; i++) GoRoute(path: '/p$i', builder: (_, __) => Text('page-$i'))],
        ),
      ],
    );
    await t.pumpWidget(_app(router));
    await t.pumpAndSettle();
    expect(t.takeException(), isNull);
    await t.scrollUntilVisible(
      find.text('Item 11'),
      100,
      scrollable: find.descendant(of: find.byType(ListView), matching: find.byType(Scrollable)),
    );
    await t.pumpAndSettle();
    await t.tap(find.widgetWithText(ListTile, 'Item 11'));
    await t.pumpAndSettle();
    expect(find.text('page-11'), findsOneWidget);
  });
}

void _tables() {
  Widget host(Widget child) => MaterialApp(home: Scaffold(body: child));

  testWidgets('DataTableView shows headers and cells', (t) async {
    await t.pumpWidget(
      host(
        const DataTableView(
          columns: ['Name', 'Role'],
          rows: [
            ['Ana', 'Admin'],
            ['Ben', 'Staff'],
          ],
        ),
      ),
    );
    for (final s in ['Name', 'Role', 'Ana', 'Admin', 'Ben', 'Staff']) {
      expect(find.text(s), findsOneWidget);
    }
  });

  testWidgets('DataTableView tap reports the row index', (t) async {
    final taps = <int>[];
    await t.pumpWidget(
      host(
        DataTableView(
          columns: const ['Name'],
          rows: const [
            ['Ana'],
            ['Ben'],
          ],
          onTap: taps.add,
        ),
      ),
    );
    await t.tap(find.text('Ben'));
    expect(taps, [1]);
  });

  testWidgets('DataTableView with no rows renders headers only', (t) async {
    await t.pumpWidget(host(const DataTableView(columns: ['Name', 'Role'], rows: [])));
    expect(find.text('Name'), findsOneWidget);
    expect(find.text('Role'), findsOneWidget);
    expect(t.takeException(), isNull);
  });

  testWidgets('DataTableView does not overflow with long cells', (t) async {
    t.view.devicePixelRatio = 1;
    t.view.physicalSize = const Size(400, 800);
    addTearDown(t.view.reset);
    await t.pumpWidget(
      host(
        DataTableView(
          columns: const ['A', 'B', 'C'],
          rows: [
            for (var i = 0; i < 3; i++) ['x' * 300, 'y' * 300, 'z'],
          ],
        ),
      ),
    );
    expect(t.takeException(), isNull);
  });
}
