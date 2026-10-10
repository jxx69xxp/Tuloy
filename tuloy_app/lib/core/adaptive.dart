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
          LayoutBuilder(
            builder: (context, box) => SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: box.maxHeight),
                child: IntrinsicHeight(
                  child: NavigationRail(
                    selectedIndex: _selected,
                    labelType: NavigationRailLabelType.all,
                    onDestinationSelected: (i) => context.go(items[i].path),
                    destinations: [
                      for (final i in items) NavigationRailDestination(icon: Icon(i.icon), label: Text(i.label)),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const VerticalDivider(width: 1),
          Expanded(child: child),
        ],
      ),
    );
  }
}

/// Simple read-only table for wide screens: header row, one row per entry,
/// scrolls horizontally when too narrow. A row tap calls [onTap] with its index.
class DataTableView extends StatelessWidget {
  const DataTableView({super.key, required this.columns, required this.rows, this.onTap});

  final List<String> columns;
  final List<List<String>> rows;
  final void Function(int index)? onTap;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: DataTable(
      showCheckboxColumn: false,
      columns: [for (final c in columns) DataColumn(label: Text(c))],
      rows: [
        for (var i = 0; i < rows.length; i++)
          DataRow(
            onSelectChanged: onTap == null ? null : (_) => onTap!(i),
            cells: [
              for (final cell in rows[i])
                DataCell(ConstrainedBox(constraints: const BoxConstraints(maxWidth: 320), child: Text(cell))),
            ],
          ),
      ],
    ),
  );
}
