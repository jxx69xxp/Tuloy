import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'config.dart';
import 'failure.dart';

/// Tokens and chosen language in the OS keychain/keystore, cached in memory.
class TokenStore {
  TokenStore([FlutterSecureStorage? storage]) : _s = storage ?? const FlutterSecureStorage();
  final FlutterSecureStorage _s;
  String? access;
  String? refresh;

  /// Storage can be unreadable (on web it needs a secure context: HTTPS or localhost).
  /// Fall back to signed out rather than failing app start.
  Future<void> load() async {
    access = await _tryRead('access');
    refresh = await _tryRead('refresh');
  }

  Future<String?> _tryRead(String key) async {
    try {
      return await _s.read(key: key);
    } catch (_) {
      return null;
    }
  }

  Future<void> save(String access, String refresh) async {
    this.access = access;
    this.refresh = refresh;
    await _s.write(key: 'access', value: access);
    await _s.write(key: 'refresh', value: refresh);
  }

  Future<void> clear() async {
    access = refresh = null;
    await _s.delete(key: 'access');
    await _s.delete(key: 'refresh');
  }

  /// Read before runApp: a failure here must not leave a blank page, so it yields null (language picker).
  Future<String?> readLanguage() => _tryRead('language');
  Future<void> writeLanguage(String code) => _s.write(key: 'language', value: code);

  /// Light, dark or system appearance (ThemeMode name).
  Future<String?> readThemeMode() => _tryRead('themeMode');
  Future<void> writeThemeMode(String mode) => _s.write(key: 'themeMode', value: mode);

  /// When the front-desk notifications were last opened (ISO time); newer items count as unread.
  Future<String?> readNotificationsSeen() => _tryRead('notificationsSeen');
  Future<void> writeNotificationsSeen(String iso) => _s.write(key: 'notificationsSeen', value: iso);
}

/// Dio with: bearer token, Accept-Language, and one transparent refresh on 401.
/// QueuedInterceptor runs errors one at a time, so parallel 401s trigger a single refresh.
Dio buildDio(TokenStore store, {required String Function() language, required void Function() onSessionExpired}) {
  final dio = Dio(BaseOptions(baseUrl: apiUrl, connectTimeout: const Duration(seconds: 10)));
  dio.interceptors.add(_AuthInterceptor(store, language, onSessionExpired));
  return dio;
}

class _AuthInterceptor extends QueuedInterceptor {
  _AuthInterceptor(this._store, this._language, this._onExpired);
  final TokenStore _store;
  final String Function() _language;
  final void Function() _onExpired;

  /// No interceptors: used for the refresh call and the retry, so a second 401
  /// can't re-enter this (queued, single-file) interceptor and deadlock.
  final _plain = Dio(BaseOptions(baseUrl: apiUrl, connectTimeout: const Duration(seconds: 10)));

  @override
  void onRequest(RequestOptions o, RequestInterceptorHandler h) {
    o.headers['Accept-Language'] = _language();
    o.headers['x-hotel-id'] = hotelId; // staff/admin routes are scoped to this hotel
    if (_store.access != null) o.headers['Authorization'] = 'Bearer ${_store.access}';
    h.next(o);
  }

  @override
  Future<void> onError(DioException e, ErrorInterceptorHandler h) async {
    final req = e.requestOptions;
    if (e.response?.statusCode != 401 || req.path.startsWith('/auth/') || _store.refresh == null) {
      h.next(e);
      return;
    }
    // Another queued request may already have refreshed while this one waited.
    if (req.headers['Authorization'] == 'Bearer ${_store.access}') {
      try {
        final res = await _plain.post('/auth/refresh', data: {'refreshToken': _store.refresh});
        await _store.save(res.data['accessToken'] as String, res.data['refreshToken'] as String);
      } catch (_) {
        await _store.clear();
        _onExpired();
        h.next(e);
        return;
      }
    }
    req.headers['Authorization'] = 'Bearer ${_store.access}';
    try {
      h.resolve(await _plain.fetch(req));
    } on DioException catch (err) {
      h.next(err);
    }
  }
}

/// Map anything thrown by Dio into a [Failure] the UI can show.
Failure toFailure(Object e) {
  if (e is Failure) return e;
  if (e is DioException) {
    final body = e.response?.data;
    if (body is Map && body['error'] is Map) {
      final err = body['error'] as Map;
      return Failure('${err['code']}', err['message'] as String?);
    }
  }
  return const Failure('NETWORK');
}
