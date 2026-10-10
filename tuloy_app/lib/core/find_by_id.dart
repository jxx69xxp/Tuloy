import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../l10n/app_localizations.dart';
import 'http.dart';
import 'ui.dart';

/// Resolves one item of a list endpoint by its `id`, so an edit route can be
/// addressed by URL (and survive a browser refresh) instead of carrying the item as `extra`.
class FindById extends ConsumerWidget {
  const FindById({super.key, required this.listPath, required this.id, required this.builder});
  final String listPath;
  final String id;
  final Widget Function(BuildContext, J item) builder;

  @override
  Widget build(BuildContext context, WidgetRef ref) => AsyncBody(
    value: ref.watch(getProvider(listPath)),
    onRetry: () => ref.invalidate(getProvider(listPath)),
    builder: (data) {
      for (final r in jsonList(data)) {
        if ('${r['id']}' == id) return builder(context, r);
      }
      return Center(child: Text(AppLocalizations.of(context).notFound));
    },
  );
}

/// Pops after a save; when the page was opened directly by URL (nothing to pop) goes to [fallback].
void popOr(BuildContext context, String fallback) => context.canPop() ? context.pop() : context.go(fallback);
