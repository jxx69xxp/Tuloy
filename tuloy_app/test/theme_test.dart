import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tuloy_app/app/theme.dart';

void main() {
  // Component themes get their styles before Theme.of adds font sizes; without them titles drop to 14px.
  testWidgets('app bar title uses the titleLarge size', (t) async {
    await t.pumpWidget(
      MaterialApp(theme: tuloyTheme(Brightness.light), home: Scaffold(appBar: AppBar(title: const Text('Hi')))),
    );
    final title = t.widget<RichText>(find.descendant(of: find.byType(AppBar), matching: find.byType(RichText)).first);
    expect(title.text.style?.fontSize, 22);
  });
}
