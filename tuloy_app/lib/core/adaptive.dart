import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../l10n/app_localizations.dart';
import 'web/shortcuts.dart';

/// Width from which the web/desktop layout (navigation rail, tables) is used.
const double kWideBreakpoint = 840;

bool isWide(BuildContext context) => MediaQuery.sizeOf(context).width >= kWideBreakpoint;

class RailItem {
  const RailItem(this.icon, this.label, this.path, {this.section});
  final IconData icon;
  final String label;
  final String path;

  /// Sidebar group heading on wide screens; a new heading shows when it changes.
  final String? section;
}

/// Wraps the routes of an area. On wide screens: sidebar, top bar with breadcrumbs
/// and a centered, denser content column. On narrow screens the page is shown untouched.
class AdaptiveShell extends StatelessWidget {
  const AdaptiveShell({
    super.key,
    required this.items,
    required this.location,
    required this.child,
    this.labels = const {},
    this.userName,
    this.onSignOut,
    this.topActions = const [],
    this.fab,
  });

  final List<RailItem> items;
  final String location;
  final Widget child;

  /// Breadcrumb labels for paths that are not sidebar items (e.g. desk screens under /admin/desk).
  final Map<String, String> labels;
  final String? userName;
  final VoidCallback? onSignOut;

  /// Extra top-bar buttons (e.g. notifications) and a floating action button, wide screens only.
  final List<Widget> topActions;
  final Widget? fab;

  /// Index of the item whose path is the longest prefix of [location].
  int? get _selected {
    int? best;
    for (var i = 0; i < items.length; i++) {
      final p = items[i].path;
      final matches = location == p || location.startsWith('$p/');
      if (matches && (best == null || p.length > items[best].path.length)) best = i;
    }
    return best;
  }

  /// (label, path) for each labelled prefix of [location]; an unlabelled tail (ids, new, menu…) is "Details".
  List<(String, String)> _crumbs(String details) {
    final known = {for (final i in items) i.path: i.label, ...labels};
    final out = <(String, String)>[];
    var p = '';
    for (final seg in Uri.parse(location).pathSegments) {
      p += '/$seg';
      if (known[p] != null) out.add((known[p]!, p));
    }
    if (out.isEmpty || out.last.$2 != location) out.add((details, location));
    return out;
  }

  /// Desktop density for the wide shell only; the app's ThemeData stays as is for mobile.
  static ThemeData _desk(ThemeData t) => t.copyWith(
    visualDensity: VisualDensity.compact,
    // Keyboard users: a clearly visible focus highlight on sidebar items, table rows and buttons.
    focusColor: t.colorScheme.primary.withValues(alpha: 0.16),
    textTheme: t.textTheme.apply(fontSizeFactor: 0.95),
    cardTheme: t.cardTheme.copyWith(
      elevation: 0,
      color: t.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: t.colorScheme.outlineVariant),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: t.filledButtonTheme.style?.copyWith(minimumSize: const WidgetStatePropertyAll(Size(64, 40))),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: t.outlinedButtonTheme.style?.copyWith(minimumSize: const WidgetStatePropertyAll(Size(64, 40))),
    ),
    listTileTheme: t.listTileTheme.copyWith(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
    scrollbarTheme: t.scrollbarTheme.copyWith(thumbVisibility: const WidgetStatePropertyAll(true)),
  );

  @override
  Widget build(BuildContext context) {
    if (!isWide(context)) return child;
    final l = AppLocalizations.of(context);
    final actions = [
      IconButton(
        tooltip: l.settings,
        icon: const Icon(Icons.settings_outlined),
        onPressed: () => context.push('/settings'),
      ),
      if (onSignOut != null) IconButton(tooltip: l.signOut, icon: const Icon(Icons.logout), onPressed: onSignOut),
    ];
    final help = IconButton(
      tooltip: l.keyboardShortcuts,
      icon: const Icon(Icons.keyboard_outlined),
      onPressed: () => showDialog<void>(context: context, builder: (_) => const ShortcutsHelp()),
    );
    return Theme(
      data: _desk(Theme.of(context)),
      child: ShellShortcuts(
        items: items,
        child: Scaffold(
          floatingActionButton: fab,
          body: Row(
            children: [
              ValueListenableBuilder<bool>(
                valueListenable: sidebarCollapsed,
                builder: (context, collapsed, _) => AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOutCubic,
                  width: collapsed ? 72 : 232,
                  child: _Sidebar(
                    items: items,
                    selected: _selected,
                    userName: userName,
                    actions: actions,
                    collapsed: collapsed,
                  ),
                ),
              ),
              const VerticalDivider(width: 1),
              Expanded(
                child: Column(
                  children: [
                    // Settings and sign out live once, in the sidebar footer.
                    _TopBar(crumbs: _crumbs(l.details), actions: [...topActions, help]),
                    const Divider(height: 1),
                    Expanded(
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 1280),
                          child: Padding(padding: const EdgeInsets.all(24), child: child),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Wide-screen sidebar width: full (labels) or a 72 px icon rail. Kept while moving between pages.
final sidebarCollapsed = ValueNotifier(false);

class _Sidebar extends StatelessWidget {
  const _Sidebar({
    required this.items,
    required this.selected,
    required this.userName,
    required this.actions,
    required this.collapsed,
  });
  final List<RailItem> items;
  final int? selected;
  final String? userName;
  final List<Widget> actions;
  final bool collapsed;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final l = AppLocalizations.of(context);
    final heading = t.textTheme.labelSmall?.copyWith(color: t.colorScheme.onSurfaceVariant, letterSpacing: 0.8);
    final toggle = IconButton(
      tooltip: collapsed ? l.expandMenu : l.collapseMenu,
      icon: Icon(collapsed ? Icons.menu_open : Icons.menu),
      onPressed: () => sidebarCollapsed.value = !collapsed,
    );
    return ClipRect(
      child: OverflowBox(
        // Lay out at the final width while the width animates, so nothing reflows mid-animation.
        alignment: Alignment.topLeft,
        minWidth: collapsed ? 72 : 232,
        maxWidth: collapsed ? 72 : 232,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(collapsed ? 12 : 20, 12, 8, 8),
              child: collapsed
                  ? toggle
                  : Row(
                      children: [
                        Image.asset('assets/logo/tuloy_icon.png', width: 28, height: 28, excludeFromSemantics: true),
                        const SizedBox(width: 10),
                        Expanded(child: Text(l.appTitle, style: t.textTheme.titleMedium)),
                        toggle,
                      ],
                    ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                children: [
                  for (var i = 0; i < items.length; i++) ...[
                    if (i == 0 || items[i].section != items[i - 1].section)
                      collapsed
                          ? const Divider(height: 16, indent: 12, endIndent: 12)
                          : Padding(
                              padding: const EdgeInsets.fromLTRB(12, 16, 12, 4),
                              child: items[i].section == null
                                  ? null
                                  : Semantics(
                                      header: true,
                                      child: Text(items[i].section!.toUpperCase(), style: heading),
                                    ),
                            ),
                    collapsed
                        ? Tooltip(
                            message: items[i].label,
                            preferBelow: false,
                            child: ListTile(
                              dense: true,
                              selected: i == selected,
                              contentPadding: EdgeInsets.zero,
                              title: Icon(items[i].icon, size: 22, semanticLabel: items[i].label),
                              onTap: () => context.go(items[i].path),
                            ),
                          )
                        : ListTile(
                            dense: true,
                            selected: i == selected,
                            leading: Icon(items[i].icon, size: 20),
                            title: Text(items[i].label),
                            onTap: () => context.go(items[i].path),
                          ),
                  ],
                ],
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: EdgeInsets.fromLTRB(collapsed ? 4 : 16, 8, 4, 8),
              child: collapsed
                  ? Column(mainAxisSize: MainAxisSize.min, children: actions)
                  : Row(
                      children: [
                        Expanded(
                          child: Text(userName ?? '', overflow: TextOverflow.ellipsis, style: t.textTheme.bodyMedium),
                        ),
                        ...actions,
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.crumbs, required this.actions});
  final List<(String, String)> crumbs;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return SizedBox(
      height: 56,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (var i = 0; i < crumbs.length; i++) ...[
                      if (i > 0) Icon(Icons.chevron_right, size: 18, color: t.colorScheme.onSurfaceVariant),
                      if (i < crumbs.length - 1)
                        TextButton(onPressed: () => context.go(crumbs[i].$2), child: Text(crumbs[i].$1))
                      else
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(crumbs[i].$1, style: t.textTheme.titleSmall),
                        ),
                    ],
                  ],
                ),
              ),
            ),
            ...actions,
          ],
        ),
      ),
    );
  }
}
