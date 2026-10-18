import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../../auth/domain/auth.dart';
import '../../auth/presentation/auth_controller.dart';

/// Landing screen of each role's area (G1 / T1 / A1). Phase 2+ fills these in.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key, required this.role});
  final Role role;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final user = ref.watch(authProvider).valueOrNull;
    final title = switch (role) {
      Role.guest => l.guestHome,
      Role.restaurant => l.restaurant,
      Role.staff => l.staffHome,
      Role.admin => l.adminHome,
    };
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            tooltip: l.settings,
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(l.hello(user?.fullName ?? ''), style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(l.comingSoon),
        ],
      ),
    );
  }
}
