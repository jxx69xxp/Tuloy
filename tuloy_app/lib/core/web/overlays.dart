import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';
import '../adaptive.dart';

/// Route shown over the current page on wide screens: a right-hand side panel (~480px) or a
/// centered editor dialog (~560px). Tapping outside or Esc pops it.
PageRoute<T> _overlayRoute<T>(BuildContext context, Widget child, {required bool panel, RouteSettings? settings}) =>
    PageRouteBuilder<T>(
      settings: settings,
      opaque: false,
      // A dialog's app bar then shows a close (X) instead of a back arrow.
      fullscreenDialog: !panel,
      barrierDismissible: true,
      barrierColor: Colors.black38,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      pageBuilder: (context, _, __) => panel
          ? Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                width: 480,
                height: double.infinity,
                child: Material(elevation: 8, child: child),
              ),
            )
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 560, maxHeight: 720),
                  child: Material(
                    elevation: 8,
                    clipBehavior: Clip.antiAlias,
                    borderRadius: BorderRadius.circular(12),
                    child: child,
                  ),
                ),
              ),
            ),
      transitionsBuilder: (_, a, __, child) => panel
          ? SlideTransition(
              position: Tween(
                begin: const Offset(1, 0),
                end: Offset.zero,
              ).animate(CurvedAnimation(parent: a, curve: Curves.easeOutCubic)),
              child: child,
            )
          : FadeTransition(opacity: a, child: child),
    );

/// Route for an edit form pushed with Navigator: a dialog on wide screens, the usual page otherwise.
PageRoute<T> editorRoute<T>(BuildContext context, Widget child) =>
    isWide(context) ? _overlayRoute<T>(context, child, panel: false) : MaterialPageRoute<T>(builder: (_) => child);

/// go_router page: on wide screens a side panel ([panel]) or editor dialog over the parent route's page,
/// otherwise the same MaterialPage go_router builds by default.
Page<void> adaptivePage(BuildContext context, GoRouterState s, Widget child, {bool panel = false}) => isWide(context)
    ? _OverlayPage(key: s.pageKey, restorationId: s.pageKey.value, panel: panel, child: child)
    : MaterialPage<void>(key: s.pageKey, restorationId: s.pageKey.value, child: child);

class _OverlayPage extends Page<void> {
  const _OverlayPage({super.key, super.restorationId, required this.panel, required this.child});
  final bool panel;
  final Widget child;

  @override
  Route<void> createRoute(BuildContext context) => _overlayRoute<void>(context, child, panel: panel, settings: this);
}

/// Sticky Cancel/Save row for edit forms on wide screens; [more] go between Cancel and Save.
class EditorFooter extends StatelessWidget {
  const EditorFooter({super.key, required this.save, this.more = const []});
  final Widget save;
  final List<Widget> more;

  @override
  Widget build(BuildContext context) => Material(
    child: Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Theme.of(context).colorScheme.outlineVariant)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(onPressed: () => Navigator.maybePop(context), child: Text(AppLocalizations.of(context).cancel)),
          for (final w in more) Padding(padding: const EdgeInsets.only(left: 8), child: w),
          const SizedBox(width: 8),
          save,
        ],
      ),
    ),
  );
}
