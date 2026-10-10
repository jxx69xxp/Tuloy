import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tuloy_app/core/http.dart';
import 'package:tuloy_app/features/admin/admin_screens.dart';
import 'package:tuloy_app/l10n/app_localizations.dart';

void main() {
  Future<void> pump(WidgetTester t, double w) async {
    t.view.devicePixelRatio = 1;
    t.view.physicalSize = Size(w, 800);
    addTearDown(t.view.reset);
    await t.pumpWidget(
      ProviderScope(
        overrides: [
          getProvider('/admin/audit').overrideWith(
            (ref) async => [
              {'action': 'REFUND', 'entityType': 'Payment', 'at': '2026-10-01T10:00:00Z', 'actorId': 'actor-1'},
            ],
          ),
        ],
        child: const MaterialApp(
          localizationsDelegates: [...AppLocalizations.localizationsDelegates, DefaultMaterialLocalizations.delegate],
          supportedLocales: AppLocalizations.supportedLocales,
          home: AuditScreen(),
        ),
      ),
    );
    await t.pumpAndSettle();
  }

  testWidgets('audit log is a table on wide screens', (t) async {
    await pump(t, 1200);
    expect(find.byType(DataTable), findsOneWidget);
    expect(find.text('Action'), findsOneWidget);
    expect(find.text('REFUND'), findsOneWidget);
    expect(find.text('actor-1'), findsOneWidget);
  });

  testWidgets('audit log stays a list on narrow screens', (t) async {
    await pump(t, 400);
    expect(find.byType(DataTable), findsNothing);
    expect(find.byType(ListTile), findsOneWidget);
    expect(find.text('REFUND · Payment'), findsOneWidget);
  });
}
