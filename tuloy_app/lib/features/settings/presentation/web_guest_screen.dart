import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';

/// Web is for Staff/Admin; signed-in guests land here and are pointed at the mobile app.
class WebGuestScreen extends StatelessWidget {
  const WebGuestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final t = Theme.of(context).textTheme;
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: Image.asset('assets/logo/tuloy_icon.png', width: 100, height: 100),
                ),
                const SizedBox(height: 24),
                Text(l.webGuestTitle, style: t.headlineSmall, textAlign: TextAlign.center),
                const SizedBox(height: 12),
                Text(l.webGuestBody, style: t.bodyMedium, textAlign: TextAlign.center),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: () => context.push('/settings'),
                  icon: const Icon(Icons.settings),
                  label: Text(l.settings),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
