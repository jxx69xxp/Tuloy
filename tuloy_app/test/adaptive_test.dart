import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:tuloy_app/core/adaptive.dart';

const _items = [
  RailItem(Icons.home, 'Home', '/admin'),
  RailItem(Icons.bed, 'Rooms', '/admin/rooms'),
  RailItem(Icons.list, 'Reports', '/admin/reports'),
];

Widget _app(GoRouter router) => MaterialApp.router(routerConfig: router);

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
  Future<void> size(WidgetTester t, double w) async {
    t.view.devicePixelRatio = 1;
    t.view.physicalSize = Size(w, 800);
    addTearDown(t.view.reset);
  }

  testWidgets('narrow shows only the child', (t) async {
    await size(t, 400);
    await t.pumpWidget(_app(_router()));
    await t.pumpAndSettle();
    expect(find.byType(NavigationRail), findsNothing);
    expect(find.text('page-home'), findsOneWidget);
  });

  testWidgets('wide shows rail and navigates on tap', (t) async {
    await size(t, 1200);
    await t.pumpWidget(_app(_router()));
    await t.pumpAndSettle();
    expect(find.byType(NavigationRail), findsOneWidget);
    for (final l in ['Home', 'Rooms', 'Reports']) {
      expect(find.text(l), findsOneWidget);
    }
    await t.tap(find.text('Rooms'));
    await t.pumpAndSettle();
    expect(find.text('page-rooms'), findsOneWidget);
  });

  testWidgets('longest prefix selects the item', (t) async {
    await size(t, 1200);
    await t.pumpWidget(_app(_router(initial: '/admin/rooms/type')));
    await t.pumpAndSettle();
    expect(t.widget<NavigationRail>(find.byType(NavigationRail)).selectedIndex, 1);
  });

  testWidgets('resizing keeps the location', (t) async {
    await size(t, 1200);
    await t.pumpWidget(_app(_router(initial: '/admin/reports')));
    await t.pumpAndSettle();
    await size(t, 400);
    await t.pumpAndSettle();
    expect(find.byType(NavigationRail), findsNothing);
    expect(find.text('page-reports'), findsOneWidget);
    await size(t, 1200);
    await t.pumpAndSettle();
    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.text('page-reports'), findsOneWidget);
    expect(t.widget<NavigationRail>(find.byType(NavigationRail)).selectedIndex, 2);
  });
}
