import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/auth/presentation/auth_controller.dart';
import '../l10n/app_localizations.dart';
import 'router.dart';
import 'theme.dart';

class TuloyApp extends ConsumerWidget {
  const TuloyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    return MaterialApp.router(
      onGenerateTitle: (c) => AppLocalizations.of(c).appTitle,
      routerConfig: ref.watch(routerProvider),
      locale: language == null ? null : Locale(language),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        _Fallback(GlobalMaterialLocalizations.delegate),
        _Fallback(GlobalWidgetsLocalizations.delegate),
        _Fallback(GlobalCupertinoLocalizations.delegate),
      ],
      theme: tuloyTheme(Brightness.light),
      darkTheme: tuloyTheme(Brightness.dark),
      themeMode: ref.watch(themeModeProvider),
    );
  }
}

/// Flutter ships Material/Cupertino/Widgets strings for Filipino but not Cebuano.
/// For any unsupported language, load the Filipino set (our closest) for built-in widgets;
/// our own strings still come from app_ceb.arb.
class _Fallback<T> extends LocalizationsDelegate<T> {
  const _Fallback(this.inner);
  final LocalizationsDelegate<T> inner;

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<T> load(Locale locale) => inner.load(inner.isSupported(locale) ? locale : const Locale('fil'));

  @override
  bool shouldReload(covariant LocalizationsDelegate<T> old) => false;

  @override
  Type get type => inner.type;
}
