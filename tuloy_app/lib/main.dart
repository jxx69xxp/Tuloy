import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'core/api.dart';
import 'features/auth/presentation/auth_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final store = TokenStore();
  final language = await store.readLanguage();
  final theme = ThemeMode.values.asNameMap()[await store.readThemeMode()] ?? ThemeMode.system;
  runApp(
    ProviderScope(
      overrides: [tokenStoreProvider.overrideWithValue(store), languageProvider.overrideWith((_) => language),
        themeModeProvider.overrideWith((_) => theme),
      ],
      child: const TuloyApp(),
    ),
  );
}
