import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/booking/presentation/booking_providers.dart' show AsyncBody;
import '../../l10n/app_localizations.dart';
import '../http.dart';

/// Value a column sorts by (num, DateTime, lower-cased String…); null sorts last.
typedef SortKey = Comparable<dynamic>? Function(J row);

/// Wide-screen table layout of a [JsonList]: header labels, cells per row, row tap.
class JsonTable {
  const JsonTable({
    required this.columns,
    required this.cells,
    this.onTap,
    this.sortKeys,
    this.actions,
    this.toolbar = const [],
    this.onSearch,
    this.searchHint,
    this.expanded,
  });
  final List<String> columns;
  final List<String> Function(BuildContext, J row) cells;
  final void Function(J row)? onTap;

  /// One entry per column; a column is sortable when its entry is not null.
  final List<SortKey?>? sortKeys;

  /// Per-row buttons, the same actions the mobile tile offers.
  final List<Widget> Function(BuildContext, J row)? actions;

  /// Controls beside the search box: filters, an add button.
  final List<Widget> toolbar;

  /// When set, the (debounced) search text goes to the server instead of filtering rows here.
  final ValueChanged<String>? onSearch;
  final String? searchHint;

  /// Optional detail area under a row, toggled by a chevron; null for a row hides its chevron.
  final Widget? Function(BuildContext, J row)? expanded;
}

/// Wide-screen table: search toolbar, sortable sticky header, hover/selected rows, actions and
/// "Show more" paging. Everything is client-side over the rows already loaded.
class WebTable extends StatefulWidget {
  const WebTable({
    super.key,
    required this.table,
    required this.value,
    required this.onRetry,
    this.onRefresh,
    this.empty,
    this.header,
  });
  final JsonTable table;
  final AsyncValue<dynamic> value;
  final VoidCallback onRetry;
  final VoidCallback? onRefresh;
  final String? empty;
  final Widget? header;

  @override
  State<WebTable> createState() => _WebTableState();
}

/// Search boxes of the tables on screen, newest last; "/" focuses the one on the current route.
final tableSearchFocus = <FocusNode>[];

class _WebTableState extends State<WebTable> {
  static const pageSize = 50;
  final _search = TextEditingController();
  final _searchFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    tableSearchFocus.add(_searchFocus);
  }

  Timer? _debounce;
  String _q = '';
  int? _sortCol;
  bool _asc = true;
  int _shown = pageSize;
  Object? _selected;

  /// Ids of expanded rows; kept across sort, search, paging and reloads.
  final _open = <Object>{};

  JsonTable get t => widget.table;

  @override
  void dispose() {
    _debounce?.cancel();
    tableSearchFocus.remove(_searchFocus);
    _searchFocus.dispose();
    _search.dispose();
    super.dispose();
  }

  void _onType(String v) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), () {
      final q = v.trim();
      if (t.onSearch != null) return t.onSearch!(q);
      setState(() {
        _q = q.toLowerCase();
        _shown = pageSize;
      });
    });
  }

  void _sort(int i) => setState(() {
    _asc = _sortCol == i ? !_asc : true;
    _sortCol = i;
  });

  SortKey? _key(int i) => (t.sortKeys != null && i < t.sortKeys!.length) ? t.sortKeys![i] : null;

  List<J> _visible(BuildContext context, List<J> rows) {
    var out = rows;
    if (_q.isNotEmpty) {
      out = [
        for (final r in rows)
          if (t.cells(context, r).any((c) => c.toLowerCase().contains(_q))) r,
      ];
    }
    final key = _sortCol == null ? null : _key(_sortCol!);
    if (key != null) {
      out = [...out]
        ..sort((a, b) {
          final x = key(a), y = key(b);
          if (x == null || y == null) return x == null ? (y == null ? 0 : 1) : -1;
          final c = x.compareTo(y);
          return _asc ? c : -c;
        });
    }
    return out;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.header != null) widget.header!,
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              Flexible(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 360),
                  child: TextField(
                    controller: _search,
                    focusNode: _searchFocus,
                    onChanged: _onType,
                    decoration: InputDecoration(
                      isDense: true,
                      prefixIcon: const Icon(Icons.search),
                      hintText: l.search,
                    ),
                  ),
                ),
              ),
              for (final w in t.toolbar) Padding(padding: const EdgeInsets.only(left: 12), child: w),
              const Spacer(),
              if (widget.onRefresh != null)
                IconButton(tooltip: l.refresh, icon: const Icon(Icons.refresh), onPressed: widget.onRefresh),
            ],
          ),
        ),
        Expanded(
          child: Card(
            margin: EdgeInsets.zero,
            child: AsyncBody(
              value: widget.value,
              onRetry: widget.onRetry,
              builder: (data) => _table(context, jsonList(data)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _line(List<Widget> cells, Widget? actions, [Widget? toggle]) => Row(
    children: [
      if (t.expanded != null) SizedBox(width: 48, child: toggle),
      for (final c in cells)
        Expanded(
          child: Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: c),
        ),
      if (t.actions != null) SizedBox(width: 160, child: actions),
    ],
  );

  Widget _head(BuildContext context, int i) {
    final l = AppLocalizations.of(context);
    final label = Text(t.columns[i], overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.labelLarge);
    if (_key(i) == null) return Align(alignment: Alignment.centerLeft, child: label);
    final active = _sortCol == i;
    return Align(
      alignment: Alignment.centerLeft,
      child: Tooltip(
        message: l.sortBy(t.columns[i]),
        child: InkWell(
          onTap: () => _sort(i),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(child: label),
                if (active)
                  Icon(
                    _asc ? Icons.arrow_upward : Icons.arrow_downward,
                    size: 16,
                    semanticLabel: _asc ? l.sortedAscending : l.sortedDescending,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _table(BuildContext context, List<J> all) {
    final l = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final rows = _visible(context, all);
    final shown = rows.take(_shown).toList();
    final more = rows.length > shown.length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header stays put while the rows scroll.
        Container(
          constraints: const BoxConstraints(minHeight: 44),
          color: scheme.surfaceContainerHigh,
          child: _line([for (var i = 0; i < t.columns.length; i++) _head(context, i)], null),
        ),
        const Divider(height: 1),
        Expanded(
          child: rows.isEmpty
              ? Center(
                  child: Padding(padding: const EdgeInsets.all(24), child: Text(widget.empty ?? l.nothingHere)),
                )
              : ListView.separated(
                  itemCount: shown.length + (more ? 1 : 0),
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    if (i == shown.length) {
                      return Padding(
                        padding: const EdgeInsets.all(8),
                        child: Center(
                          child: TextButton(
                            onPressed: () => setState(() => _shown += pageSize),
                            child: Text('${l.showMore} · ${l.rowsShown(shown.length, rows.length)}'),
                          ),
                        ),
                      );
                    }
                    final r = shown[i];
                    final id = r['id'] ?? r;
                    final open = _open.contains(id);
                    final detail = t.expanded?.call(context, r);
                    final row = Material(
                      color: id == _selected ? scheme.secondaryContainer : Colors.transparent,
                      child: InkWell(
                        onTap: t.onTap == null
                            ? null
                            : () {
                                setState(() => _selected = id);
                                t.onTap!(r);
                              },
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(minHeight: 48),
                          child: _line(
                            [
                              for (final c in t.cells(context, r))
                                Text(c, maxLines: 2, overflow: TextOverflow.ellipsis),
                            ],
                            t.actions == null
                                ? null
                                : Row(mainAxisAlignment: MainAxisAlignment.end, children: t.actions!(context, r)),
                            detail == null
                                ? null
                                : IconButton(
                                    tooltip: open ? l.hideDetails : l.showDetails,
                                    icon: Icon(open ? Icons.expand_less : Icons.expand_more),
                                    onPressed: () => setState(() => open ? _open.remove(id) : _open.add(id)),
                                  ),
                          ),
                        ),
                      ),
                    );
                    if (!open || detail == null) return row;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        row,
                        Padding(padding: const EdgeInsets.fromLTRB(60, 4, 12, 12), child: detail),
                      ],
                    );
                  },
                ),
        ),
      ],
    );
  }
}
