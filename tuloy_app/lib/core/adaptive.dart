import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Width from which the web/desktop layout (navigation rail, tables) is used.
const double kWideBreakpoint = 840;

bool isWide(BuildContext context) => MediaQuery.sizeOf(context).width >= kWideBreakpoint;

class RailItem {
  const RailItem(this.icon, this.label, this.path);
  final IconData icon;
  final String label;
  final String path;
}

/// Wraps the routes of an area: on wide screens adds a navigation rail beside
/// the page; on narrow screens the page is shown untouched.
class AdaptiveShell extends StatelessWidget {
  const AdaptiveShell({super.key, required this.items, required this.location, required this.child});

  final List<RailItem> items;
  final String location;
  final Widget child;

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

  @override
  Widget build(BuildContext context) {
    if (!isWide(context)) return child;
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selected,
            labelType: NavigationRailLabelType.all,
            onDestinationSelected: (i) => context.go(items[i].path),
            destinations: [
              for (final i in items) NavigationRailDestination(icon: Icon(i.icon), label: Text(i.label)),
            ],
          ),
          const VerticalDivider(width: 1),
          Expanded(child: child),
        ],
      ),
    );
  }
}
