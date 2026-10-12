import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tuloy_app/core/http.dart';
import 'package:tuloy_app/core/ui.dart';
import 'package:tuloy_app/features/admin/admin_screens.dart';
import 'package:tuloy_app/features/staff/staff_screens.dart';
import 'package:tuloy_app/l10n/app_localizations.dart';

const _staff = {
  'arrivals': 3,
  'departures': 2,
  'inHouse': 7,
  'pending': 1,
  'unreadChats': 0,
  'openTasks': 4,
  'myTasks': 0,
  'openOrders': 0,
};

const _admin = {
  ..._staff,
  'occupancy': 58,
  'roomsSold': 7,
  'rooms': 12,
  'collectedToday': 1500,
  'refundedToday': 0,
  'netToday': 1500,
  'currency': 'PHP',
  'alerts': {'failedRefunds': 2, 'failedNotifications': 0},
};

Future<void> _pump(WidgetTester t, double w, String path, Object data, Widget home) async {
  t.view.devicePixelRatio = 1;
  t.view.physicalSize = Size(w, 900);
  addTearDown(t.view.reset);
  await t.pumpWidget(
    ProviderScope(
      overrides: [getProvider(path).overrideWith((ref) async => data)],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: home,
      ),
    ),
  );
  await t.pumpAndSettle();
}

void main() {
  testWidgets('admin home: KPI cards and attention on wide, no menu tiles', (t) async {
    await _pump(t, 1400, '/admin/dashboard', _admin, const AdminHomeScreen());
    expect(find.byType(KpiGrid), findsOneWidget);
    expect(find.byType(NavTile), findsNothing);
    expect(find.text('Occupancy tonight'), findsOneWidget);
    expect(find.text('58%'), findsOneWidget);
    expect(find.text('Needs attention'), findsOneWidget);
    expect(find.text('Failed refunds'), findsOneWidget);
    expect(find.text('Failed notifications'), findsNothing); // zero counts are hidden
    expect(find.byTooltip('Refresh'), findsOneWidget);
  });

  testWidgets('admin home keeps the menu tiles on narrow', (t) async {
    await _pump(t, 400, '/admin/dashboard', _admin, const AdminHomeScreen());
    expect(find.byType(KpiGrid), findsNothing);
    expect(find.byType(NavTile), findsWidgets);
    expect(find.byTooltip('Refresh'), findsNothing);
  });

  testWidgets('staff home: KPI cards on wide, no menu tiles', (t) async {
    await _pump(t, 1400, '/staff/dashboard', _staff, const StaffHomeScreen());
    expect(find.byType(KpiGrid), findsOneWidget);
    expect(find.byType(NavTile), findsNothing);
    expect(find.text('Open tasks'), findsOneWidget);
    expect(find.text('Pending'), findsOneWidget); // attention row
  });

  testWidgets('staff home shows a calm state when nothing needs attention', (t) async {
    await _pump(t, 1400, '/staff/dashboard', {..._staff, 'pending': 0}, const StaffHomeScreen());
    expect(find.text('Nothing needs attention'), findsOneWidget);
  });

  testWidgets('staff home keeps the menu tiles on narrow', (t) async {
    await _pump(t, 400, '/staff/dashboard', _staff, const StaffHomeScreen());
    expect(find.byType(KpiGrid), findsNothing);
    expect(find.byType(NavTile), findsWidgets);
  });
}
