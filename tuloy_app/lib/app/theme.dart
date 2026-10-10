import 'package:flutter/material.dart';

/// Tuloy look: warm sand surfaces, deep teal brand, amber "door light" for highlights.
/// Signature: arch cards — rounder at the top, like the doorway in the logo.
const _teal = Color(0xFF0F6E6E);
const _amber = Color(0xFFF4B860);

const archRadius = BorderRadius.only(
  topLeft: Radius.circular(28),
  topRight: Radius.circular(28),
  bottomLeft: Radius.circular(14),
  bottomRight: Radius.circular(14),
);

ThemeData tuloyTheme(Brightness b) {
  final dark = b == Brightness.dark;
  final scheme = ColorScheme.fromSeed(seedColor: _teal, brightness: b).copyWith(
    primary: dark ? const Color(0xFF7FD3CF) : _teal,
    onPrimary: dark ? const Color(0xFF00201F) : Colors.white,
    tertiary: _amber,
    onTertiary: const Color(0xFF3A2500),
    tertiaryContainer: dark ? const Color(0xFF5A4012) : const Color(0xFFFCE7C4),
    onTertiaryContainer: dark ? const Color(0xFFFCE7C4) : const Color(0xFF3A2500),
    surface: dark ? const Color(0xFF0E1514) : const Color(0xFFF7F4EE),
    surfaceContainerLowest: dark ? const Color(0xFF0A100F) : Colors.white,
    surfaceContainerLow: dark ? const Color(0xFF151D1C) : const Color(0xFFFFFDF9),
    surfaceContainer: dark ? const Color(0xFF1A2322) : const Color(0xFFF0ECE4),
    surfaceContainerHigh: dark ? const Color(0xFF212B2A) : const Color(0xFFEAE5DB),
    outlineVariant: dark ? const Color(0xFF2C3736) : const Color(0xFFE4DED2),
  );
  final base = ThemeData(colorScheme: scheme, useMaterial3: true);
  final text = base.textTheme.copyWith(
    displaySmall: base.textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w800, letterSpacing: -1),
    headlineMedium: base.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800, letterSpacing: -0.8),
    headlineSmall: base.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700, letterSpacing: -0.5),
    titleLarge: base.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, letterSpacing: -0.3),
    titleMedium: base.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
    labelLarge: base.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600, letterSpacing: 0.2),
  );
  final field = FieldBorder(borderSide: BorderSide(color: scheme.outlineVariant));
  const button = Size.fromHeight(56);
  final buttonShape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(18));

  return base.copyWith(
    scaffoldBackgroundColor: scheme.surface,
    textTheme: text,
    appBarTheme: AppBarTheme(
      backgroundColor: scheme.surface,
      surfaceTintColor: Colors.transparent,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: text.titleLarge?.copyWith(color: scheme.onSurface),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: scheme.surfaceContainerLow,
      margin: const EdgeInsets.symmetric(vertical: 6),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: archRadius,
        side: BorderSide(color: scheme.outlineVariant),
      ),
    ),
    listTileTheme: ListTileThemeData(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      selectedColor: scheme.onTertiaryContainer,
      selectedTileColor: scheme.tertiaryContainer,
      iconColor: scheme.primary,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: scheme.surfaceContainerLowest,
      contentPadding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      border: field,
      enabledBorder: field,
      focusedBorder: field.copyWith(borderSide: BorderSide(color: scheme.primary, width: 1.6)),
      errorBorder: field.copyWith(borderSide: BorderSide(color: scheme.error)),
      focusedErrorBorder: field.copyWith(borderSide: BorderSide(color: scheme.error, width: 1.6)),
      labelStyle: text.bodyLarge?.copyWith(color: scheme.onSurfaceVariant),
      floatingLabelStyle: WidgetStateTextStyle.resolveWith(
        (st) => TextStyle(
          fontWeight: FontWeight.w600,
          color: st.contains(WidgetState.error)
              ? scheme.error
              : st.contains(WidgetState.focused)
              ? scheme.primary
              : scheme.onSurfaceVariant,
        ),
      ),
      prefixIconColor: WidgetStateColor.resolveWith(
        (st) => st.contains(WidgetState.focused) ? scheme.primary : scheme.onSurfaceVariant,
      ),
      helperStyle: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(minimumSize: button, shape: buttonShape, textStyle: text.labelLarge),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: button,
        shape: buttonShape,
        side: BorderSide(color: scheme.outlineVariant, width: 1.5),
        textStyle: text.labelLarge,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(minimumSize: const Size(48, 48), shape: buttonShape, textStyle: text.labelLarge),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: scheme.tertiary,
      foregroundColor: scheme.onTertiary,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    chipTheme: base.chipTheme.copyWith(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      side: BorderSide(color: scheme.outlineVariant),
      selectedColor: scheme.tertiaryContainer,
      checkmarkColor: scheme.onTertiaryContainer,
    ),
    tabBarTheme: TabBarThemeData(
      indicatorSize: TabBarIndicatorSize.label,
      dividerColor: Colors.transparent,
      labelStyle: text.labelLarge,
    ),
    dividerTheme: DividerThemeData(color: scheme.outlineVariant, space: 1),
    dialogTheme: DialogThemeData(
      backgroundColor: scheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(borderRadius: archRadius),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    badgeTheme: BadgeThemeData(backgroundColor: scheme.tertiary, textColor: scheme.onTertiary),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? scheme.onPrimary : null),
    ),
  );
}

/// Concentric doorway arches, drawn faintly behind headers and room art.
class ArchPattern extends CustomPainter {
  const ArchPattern({this.color = const Color(0x33FFFFFF)});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final base = size.width * .62;
    for (var i = 0; i < 4; i++) {
      final w = size.width * (.22 + i * .13);
      final top = size.height * (.18 + i * .05) - i * 8;
      final r = Rect.fromLTRB(base + size.width * .18 - w / 2, top, base + size.width * .18 + w / 2, size.height + 2);
      canvas.drawRRect(
        RRect.fromRectAndCorners(r, topLeft: Radius.circular(w / 2), topRight: Radius.circular(w / 2)),
        p,
      );
    }
  }

  @override
  bool shouldRepaint(ArchPattern old) => old.color != color;
}

/// Teal dusk sky with a warm sun glow — the guest home header.
class DuskBackdrop extends StatelessWidget {
  const DuskBackdrop({super.key, this.rounded = true});
  final bool rounded;

  @override
  Widget build(BuildContext context) {
    final radius = rounded ? const BorderRadius.vertical(bottom: Radius.circular(36)) : null;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF083E3F), _teal, Color(0xFF2A9D8F)],
        ),
        borderRadius: radius,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const RadialGradient(
            center: Alignment(.85, .35),
            radius: .7,
            colors: [Color(0x99F4B860), Color(0x00F4B860)],
          ),
          borderRadius: radius,
        ),
        child: const CustomPaint(painter: ArchPattern(), child: SizedBox.expand()),
      ),
    );
  }
}

/// Stand-in for room/service photos (the API has none yet): a gradient picked from the room name.
// ponytail: swap for Image.network once room photos are served by the API.
class RoomArt extends StatelessWidget {
  const RoomArt({super.key, required this.name, this.height = 140, this.icon = Icons.king_bed_outlined, this.child});
  final String name;
  final IconData icon;
  final double height;
  final Widget? child;

  static const _palettes = [
    [Color(0xFF0F6E6E), Color(0xFF2A9D8F)],
    [Color(0xFFE08E45), Color(0xFFF4B860)],
    [Color(0xFF1F4E79), Color(0xFF3F88C5)],
    [Color(0xFF5B7F5F), Color(0xFF9CBF8E)],
    [Color(0xFF7A4E6B), Color(0xFFC08497)],
  ];

  @override
  Widget build(BuildContext context) {
    final colors = _palettes[name.codeUnits.fold<int>(0, (a, b) => a + b) % _palettes.length];
    return SizedBox(
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: colors),
        ),
        child: CustomPaint(
          painter: const ArchPattern(color: Color(0x40FFFFFF)),
          child: Stack(
            children: [
              Center(child: Icon(icon, color: Colors.white70, size: 40)),
              if (child != null) child!,
            ],
          ),
        ),
      ),
    );
  }
}

/// Rounded bordered field with the label floating *inside* the box (no notch cut into the border).
class FieldBorder extends OutlineInputBorder {
  const FieldBorder({super.borderSide, super.borderRadius = const BorderRadius.all(Radius.circular(14))});

  // Lay the label out like a filled field (inside), but paint the outline.
  @override
  bool get isOutline => false;

  @override
  FieldBorder copyWith({BorderSide? borderSide, BorderRadius? borderRadius, double? gapPadding}) =>
      FieldBorder(borderSide: borderSide ?? this.borderSide, borderRadius: borderRadius ?? this.borderRadius);

  @override
  ShapeBorder? lerpFrom(ShapeBorder? a, double t) => a is OutlineInputBorder
      ? FieldBorder(
          borderSide: BorderSide.lerp(a.borderSide, borderSide, t),
          borderRadius: BorderRadius.lerp(a.borderRadius, borderRadius, t)!,
        )
      : super.lerpFrom(a, t);

  @override
  ShapeBorder? lerpTo(ShapeBorder? b, double t) => b is OutlineInputBorder
      ? FieldBorder(
          borderSide: BorderSide.lerp(borderSide, b.borderSide, t),
          borderRadius: BorderRadius.lerp(borderRadius, b.borderRadius, t)!,
        )
      : super.lerpTo(b, t);

  @override
  void paint(
    Canvas canvas,
    Rect rect, {
    double? gapStart,
    double gapExtent = 0.0,
    double gapPercentage = 0.0,
    TextDirection? textDirection,
  }) => super.paint(canvas, rect, textDirection: textDirection);
}
