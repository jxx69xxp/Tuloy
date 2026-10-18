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

  Future<void> size(WidgetTester t, double w) async {
    t.view.devicePixelRatio = 1;
    t.view.physicalSize = Size(w, 800);
    addTearDown(t.view.reset);
  }

  testWidgets('sidebar collapses to an icon rail and expands again', (t) async {
    await size(t, 1400);
    addTearDown(() => sidebarCollapsed.value = false);
    await t.pumpWidget(_app(_router()));
    await t.pumpAndSettle();
    expect(find.widgetWithText(ListTile, 'Rooms'), findsOneWidget);

    await t.tap(find.byTooltip('Collapse menu'));
    await t.pumpAndSettle();
    expect(find.widgetWithText(ListTile, 'Rooms'), findsNothing); // labels hidden
    expect(find.byTooltip('Rooms'), findsOneWidget); // still reachable by icon

    await t.tap(find.byTooltip('Rooms'));
    await t.pumpAndSettle();
    expect(find.text('page-rooms'), findsOneWidget);

    await t.tap(find.byTooltip('Expand menu'));
    await t.pumpAndSettle();
    expect(find.widgetWithText(ListTile, 'Rooms'), findsOneWidget);
  });

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
