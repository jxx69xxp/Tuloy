import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tuloy_app/core/api.dart';

/// Storage that fails like flutter_secure_storage_web outside a secure context (no crypto.subtle).
class _Broken extends FlutterSecureStorage {
  const _Broken();
  @override
  Future<String?> read({
    required String key,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async => throw UnsupportedError('crypto.subtle unavailable');
}

void main() {
  test('unreadable storage falls back to defaults instead of throwing', () async {
    final store = TokenStore(const _Broken());
    expect(await store.readLanguage(), isNull);
    await store.load();
    expect(store.access, isNull);
    expect(store.refresh, isNull);
  });
}
