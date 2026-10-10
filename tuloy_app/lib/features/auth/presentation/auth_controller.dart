import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api.dart';
import '../data/auth_repository_impl.dart';
import '../domain/auth.dart';

/// Overridden in main() with a store already holding the saved language.
final tokenStoreProvider = Provider<TokenStore>((_) => TokenStore());

/// Chosen UI language; null until the user picks one on first run.
final languageProvider = StateProvider<String?>((_) => null);

final dioProvider = Provider<Dio>(
  (ref) => buildDio(
    ref.read(tokenStoreProvider),
    language: () => ref.read(languageProvider) ?? 'en',
    onSessionExpired: () => ref.read(authProvider.notifier).sessionExpired(),
  ),
);

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(ref.read(dioProvider), ref.read(tokenStoreProvider)),
);

final authProvider = AsyncNotifierProvider<AuthController, User?>(AuthController.new);

class AuthController extends AsyncNotifier<User?> {
  AuthRepository get _repo => ref.read(authRepositoryProvider);

  @override
  Future<User?> build() => _repo.restore();

  /// Throws [Failure]; the screen shows it. State only changes on success.
  Future<void> signIn(String login, String password) async {
    state = AsyncData(await _repo.signIn(login, password));
  }

  Future<void> signUp({required String fullName, required String login, required String password}) async {
    state = AsyncData(
      await _repo.signUp(
        fullName: fullName,
        login: login,
        password: password,
        language: ref.read(languageProvider) ?? 'en',
      ),
    );
  }

  Future<void> signOut() async {
    await _repo.signOut();
    state = const AsyncData(null);
  }

  void sessionExpired() {
    state = const AsyncData(null);
  }

  /// Saves locally, and on the server when signed in (server picks notification language from it).
  Future<void> setLanguage(String code) async {
    ref.read(languageProvider.notifier).state = code;
    await ref.read(tokenStoreProvider).writeLanguage(code);
    if (state.valueOrNull != null) {
      try {
        await _repo.updateLanguage(code);
      } catch (_) {} // ponytail: retried on next change; add an outbox if this matters
    }
  }
}
