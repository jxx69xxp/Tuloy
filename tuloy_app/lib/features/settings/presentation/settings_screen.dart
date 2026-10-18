import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/ui.dart' show AppearanceSelector, LanguagePicker;
import '../../../l10n/app_localizations.dart';
import '../../auth/presentation/auth_controller.dart';

/// S5 — language and sign out. Profile and notification preferences come with Phase 2 (B-6).
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l.settings)),
      // Wide screens: a readable column instead of rows stretched across the window.
      body: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.sizeOf(context).width > 720 ? (MediaQuery.sizeOf(context).width - 640) / 2 : 0,
        ),
        children: [
          const LanguagePicker(),
          const Divider(),
          ListTile(title: Text(l.appearance, style: Theme.of(context).textTheme.titleSmall)),
          const Padding(padding: EdgeInsets.fromLTRB(16, 0, 16, 12), child: AppearanceSelector()),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: Text(l.signOut),
            onTap: () => ref.read(authProvider.notifier).signOut(),
          ),
        ],
      ),
    );
  }
}
