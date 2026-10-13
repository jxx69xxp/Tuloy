import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';
import '../adaptive.dart';
import 'web_table.dart' show tableSearchFocus;

/// Keyboard shortcuts of the wide shell: "/" focuses the page's table search, Ctrl/Cmd+K opens
/// quick jump, "?" lists the shortcuts. Esc is the usual dismiss of panels and dialogs.
class ShellShortcuts extends StatefulWidget {
  const ShellShortcuts({super.key, required this.items, required this.child});
  final List<RailItem> items;
  final Widget child;

  @override
  State<ShellShortcuts> createState() => _ShellShortcutsState();
}

class _ShellShortcutsState extends State<ShellShortcuts> {
  bool _dialog = false;

  @override
  void initState() {
    super.initState();
    // A global handler so shortcuts work whatever has focus (or nothing does).
    HardwareKeyboard.instance.addHandler(_onKey);
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_onKey);
    super.dispose();
  }

  bool get _typing {
    final c = FocusManager.instance.primaryFocus?.context;
    return c != null && (c.widget is EditableText || c.findAncestorWidgetOfExactType<EditableText>() != null);
  }

  bool _onKey(KeyEvent e) {
    if (e is! KeyDownEvent || _dialog || !mounted) return false;
    final k = HardwareKeyboard.instance;
    if (e.logicalKey == LogicalKeyboardKey.keyK && (k.isControlPressed || k.isMetaPressed)) {
      _show(QuickJump(items: widget.items));
      return true;
    }
    if (_typing || k.isControlPressed || k.isMetaPressed || k.isAltPressed) return false;
    final question =
        e.logicalKey == LogicalKeyboardKey.question || (e.logicalKey == LogicalKeyboardKey.slash && k.isShiftPressed);
    if (question) {
      _show(const ShortcutsHelp());
      return true;
    }
    if (e.logicalKey == LogicalKeyboardKey.slash) {
      // The table on the current route only (not one under a dialog or panel).
      final node = tableSearchFocus.reversed
          .where((n) => n.context != null && (ModalRoute.of(n.context!)?.isCurrent ?? false))
          .firstOrNull;
      if (node == null) return false;
      node.requestFocus();
      return true;
    }
    return false;
  }

  Future<void> _show(Widget dialog) async {
    _dialog = true;
    await showDialog<void>(context: context, builder: (_) => dialog);
    _dialog = false;
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

/// Ctrl/Cmd+K: type to filter the sidebar items, arrows to move, Enter to go, Esc to close.
class QuickJump extends StatefulWidget {
  const QuickJump({super.key, required this.items});
  final List<RailItem> items;
  @override
  State<QuickJump> createState() => _QuickJumpState();
}

class _QuickJumpState extends State<QuickJump> {
  String _q = '';
  int _i = 0;

  List<RailItem> get _shown => [
    for (final i in widget.items)
      if ('${i.label} ${i.section ?? ''}'.toLowerCase().contains(_q)) i,
  ];

  void _go(RailItem i) {
    final router = GoRouter.of(context);
    Navigator.pop(context);
    router.go(i.path);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final shown = _shown;
    final sel = shown.isEmpty ? -1 : _i.clamp(0, shown.length - 1);
    return Dialog(
      alignment: const Alignment(0, -0.6),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480, maxHeight: 440),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Focus(
                canRequestFocus: false,
                skipTraversal: true,
                onKeyEvent: (_, e) {
                  if (e is KeyUpEvent) return KeyEventResult.ignored;
                  final k = e.logicalKey;
                  if (k == LogicalKeyboardKey.arrowDown || k == LogicalKeyboardKey.arrowUp) {
                    if (shown.isNotEmpty) {
                      setState(() => _i = (sel + (k == LogicalKeyboardKey.arrowDown ? 1 : -1)) % shown.length);
                    }
                    return KeyEventResult.handled;
                  }
                  if (k == LogicalKeyboardKey.enter && sel >= 0) {
                    _go(shown[sel]);
                    return KeyEventResult.handled;
                  }
                  return KeyEventResult.ignored;
                },
                child: TextField(
                  autofocus: true,
                  onChanged: (v) => setState(() {
                    _q = v.trim().toLowerCase();
                    _i = 0;
                  }),
                  decoration: InputDecoration(prefixIcon: const Icon(Icons.search), hintText: l.goToPage),
                ),
              ),
            ),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: [
                  for (var j = 0; j < shown.length; j++)
                    ListTile(
                      dense: true,
                      selected: j == sel,
                      leading: Icon(shown[j].icon, size: 20),
                      title: Text(shown[j].label),
                      subtitle: shown[j].section == null ? null : Text(shown[j].section!),
                      onTap: () => _go(shown[j]),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The list of shell shortcuts ("?" or the keyboard icon in the top bar).
class ShortcutsHelp extends StatelessWidget {
  const ShortcutsHelp({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final rows = [
      ('/', l.shortcutSearch),
      ('Ctrl/⌘ K', l.goToPage),
      ('Esc', l.shortcutClose),
      ('Enter', l.shortcutSend),
      ('?', l.shortcutHelp),
    ];
    return AlertDialog(
      title: Text(l.keyboardShortcuts),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final (key, what) in rows)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  SizedBox(
                    width: 96,
                    child: Text(
                      key,
                      style: const TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.w600),
                    ),
                  ),
                  Expanded(child: Text(what)),
                ],
              ),
            ),
        ],
      ),
      actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text(l.ok))],
    );
  }
}
