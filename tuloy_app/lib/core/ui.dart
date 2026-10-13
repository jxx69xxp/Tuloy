import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/auth/presentation/widgets.dart';
import '../features/booking/presentation/booking_providers.dart';
import '../l10n/app_localizations.dart';
import 'adaptive.dart';
import 'config.dart';
import 'http.dart';
import 'web/web_table.dart';

export '../features/auth/presentation/widgets.dart' show BusyButton, failureText;
export '../features/booking/presentation/booking_providers.dart' show AsyncBody;
export 'web/web_table.dart' show JsonTable, SortKey;

void snack(BuildContext context, String text) =>
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

/// Runs an API action and shows the localized error, if any. Returns true on success.
Future<bool> act(BuildContext context, Future<void> Function() run, {String? done}) async {
  try {
    await run();
    if (done != null && context.mounted) snack(context, done);
    return true;
  } catch (e) {
    if (context.mounted) snack(context, failureText(context, e));
    return false;
  }
}

Future<bool> confirm(BuildContext context, String title, [String? body]) async {
  final l = AppLocalizations.of(context);
  return await showDialog<bool>(
        context: context,
        builder: (c) => AlertDialog(
          title: Text(title),
          content: body == null ? null : Text(body),
          actions: [
            TextButton(onPressed: () => Navigator.pop(c, false), child: Text(l.cancel)),
            FilledButton(onPressed: () => Navigator.pop(c, true), child: Text(l.ok)),
          ],
        ),
      ) ??
      false;
}

/// One-field dialog. Returns null when cancelled.
Future<String?> prompt(BuildContext context, String title, {String? label, bool number = false, String initial = ''}) {
  final l = AppLocalizations.of(context);
  final c = TextEditingController(text: initial);
  return showDialog<String>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: TextField(
        controller: c,
        autofocus: true,
        keyboardType: number ? const TextInputType.numberWithOptions(decimal: true, signed: true) : TextInputType.text,
        decoration: InputDecoration(labelText: label),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l.cancel)),
        FilledButton(onPressed: () => Navigator.pop(ctx, c.text.trim()), child: Text(l.ok)),
      ],
    ),
  );
}

class KV extends StatelessWidget {
  const KV(this.label, this.value, {super.key});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: Text(label, style: Theme.of(context).textTheme.bodySmall)),
        Flexible(child: Text(value, textAlign: TextAlign.end)),
      ],
    ),
  );
}

/// Copyable value (Wi-Fi password, QR payload).
class CopyRow extends StatelessWidget {
  const CopyRow(this.label, this.value, {super.key});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => ListTile(
    title: Text(value, style: const TextStyle(fontFamily: 'monospace')),
    subtitle: Text(label),
    trailing: IconButton(
      tooltip: AppLocalizations.of(context).copy,
      icon: const Icon(Icons.copy),
      onPressed: () async {
        await Clipboard.setData(ClipboardData(text: value));
        if (context.mounted) snack(context, AppLocalizations.of(context).copied);
      },
    ),
  );
}

/// Calls [onTick] every [every] while on screen. ponytail: polling stands in for WebSockets.
class Poller extends StatefulWidget {
  const Poller({super.key, required this.every, required this.onTick, required this.child});
  final Duration every;
  final VoidCallback onTick;
  final Widget child;
  @override
  State<Poller> createState() => _PollerState();
}

class _PollerState extends State<Poller> {
  late final Timer _t;

  @override
  void initState() {
    super.initState();
    _t = Timer.periodic(widget.every, (_) => widget.onTick());
  }

  @override
  void dispose() {
    _t.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

/// Edits a translated value {en, fil, ceb}: one field per app language.
class Tr {
  Tr([Map? initial])
    : c = {for (final k in supportedLanguages.keys) k: TextEditingController(text: '${initial?[k] ?? ''}')};
  final Map<String, TextEditingController> c;
  Map<String, String> get value => {for (final e in c.entries) e.key: e.value.text.trim()};
  void dispose() {
    for (final x in c.values) {
      x.dispose();
    }
  }

  List<Widget> fields(String label, {int maxLines = 1}) => [
    for (final e in c.entries)
      Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: TextField(
          controller: e.value,
          maxLines: maxLines,
          decoration: InputDecoration(labelText: '$label · ${supportedLanguages[e.key]}'),
        ),
      ),
  ];
}

/// List of JSON rows from a GET path with pull-to-refresh, empty and error states.
class JsonList extends ConsumerWidget {
  const JsonList({super.key, required this.path, required this.item, this.empty, this.header, this.table});
  final String path;
  final Widget Function(BuildContext, J row) item;
  final String? empty;
  final Widget? header;

  /// When set, wide screens show these rows as a [WebTable] instead of [item] cards.
  final JsonTable? table;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (table != null && isWide(context)) {
      return WebTable(
        table: table!,
        value: ref.watch(getProvider(path)),
        onRetry: () => ref.invalidate(getProvider(path)),
        onRefresh: () => ref.invalidate(getProvider(path)),
        empty: empty,
        header: header,
      );
    }
    return RefreshIndicator(
      onRefresh: () => ref.refresh(getProvider(path).future),
      child: AsyncBody(
        value: ref.watch(getProvider(path)),
        onRetry: () => ref.invalidate(getProvider(path)),
        builder: (data) {
          final rows = jsonList(data);
          return ListView(
            children: [
              if (header != null) header!,
              if (rows.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(empty ?? AppLocalizations.of(context).nothingHere),
                ),
              for (final r in rows) item(context, r),
            ],
          );
        },
      ),
    );
  }
}

/// Tile for a home-screen menu.
class NavTile extends StatelessWidget {
  const NavTile(this.icon, this.label, this.onTap, {super.key, this.badge = 0});
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final int badge;

  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(
      leading: Badge(isLabelVisible: badge > 0, label: Text('$badge'), child: Icon(icon)),
      title: Text(label),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    ),
  );
}

/// One dashboard figure on wide screens: label, large value, optional sub-label; tappable when [onTap] is set.
class Kpi {
  const Kpi(this.label, this.value, {this.sub, this.onTap});
  final String label;
  final String value;
  final String? sub;
  final VoidCallback? onTap;
}

/// Wide-screen grid of [Kpi] cards: up to 4 per row, fewer when narrower.
class KpiGrid extends StatelessWidget {
  const KpiGrid(this.items, {super.key});
  final List<Kpi> items;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return LayoutBuilder(
      builder: (context, box) {
        const gap = 12.0;
        final cols = (box.maxWidth / 220).floor().clamp(1, 4);
        final w = (box.maxWidth - gap * (cols - 1)) / cols;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final k in items)
              SizedBox(
                width: w,
                child: Card(
                  margin: EdgeInsets.zero,
                  child: InkWell(
                    onTap: k.onTap,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(k.label, style: t.textTheme.bodyMedium?.copyWith(color: t.colorScheme.onSurfaceVariant)),
                          const SizedBox(height: 4),
                          Text(k.value, style: t.textTheme.headlineMedium),
                          if (k.sub != null) Text(k.sub!, style: t.textTheme.bodySmall),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

/// Wide-screen card listing counts that need action; only non-zero rows show.
class AttentionCard extends StatelessWidget {
  const AttentionCard(this.rows, {super.key});

  /// (icon, label, count, onTap).
  final List<(IconData, String, int, VoidCallback?)> rows;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final t = Theme.of(context);
    final open = [
      for (final r in rows)
        if (r.$3 > 0) r,
    ];
    return Card(
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(l.needsAttention, style: t.textTheme.titleMedium),
          ),
          if (open.isEmpty)
            ListTile(
              leading: Icon(Icons.check_circle_outline, color: t.colorScheme.primary),
              title: Text(l.allClear),
            )
          else
            for (final (icon, label, count, onTap) in open)
              ListTile(
                leading: Icon(icon, color: t.colorScheme.error),
                title: Text(label),
                trailing: Text('$count', style: t.textTheme.titleMedium),
                onTap: onTap,
              ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
