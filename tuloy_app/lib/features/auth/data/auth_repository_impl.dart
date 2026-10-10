import 'package:dio/dio.dart';

import '../../../core/api.dart';
import '../../../core/config.dart';
import '../domain/auth.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._dio, this._store);
  final Dio _dio;
  final TokenStore _store;

  @override
  Future<User?> restore() async {
    await _store.load();
    if (_store.refresh == null) return null;
    try {
      return _user((await _dio.get('/me')).data as Map);
    } catch (_) {
      return null; // expired or offline: show sign-in
    }
  }

  @override
  Future<User> signIn(String login, String password) =>
      _session(_dio.post('/auth/login', data: {'login': login, 'password': password}));

  @override
  Future<User> signUp({
    required String fullName,
    required String login,
    required String password,
    required String language,
  }) => _session(
    _dio.post(
      '/auth/register',
      data: {'fullName': fullName, 'login': login, 'password': password, 'locale': language, 'hotelId': hotelId},
    ),
  );

  @override
  Future<void> requestReset(String login) => _call(_dio.post('/auth/otp/request', data: {'login': login}));

  @override
  Future<void> resetPassword({required String login, required String code, required String newPassword}) =>
      _call(_dio.post('/auth/password/reset', data: {'login': login, 'code': code, 'newPassword': newPassword}));

  @override
  Future<void> updateLanguage(String language) => _call(_dio.patch('/me', data: {'locale': language}));

  @override
  Future<void> signOut() async {
    final refresh = _store.refresh;
    await _store.clear();
    if (refresh != null) {
      try {
        await _dio.post('/auth/logout', data: {'refreshToken': refresh});
      } catch (_) {} // signed out locally either way
    }
  }

  Future<User> _session(Future<Response> call) async {
    try {
      final data = (await call).data as Map;
      await _store.save(data['accessToken'] as String, data['refreshToken'] as String);
      return _user(data['user'] as Map);
    } catch (e) {
      throw toFailure(e);
    }
  }

  Future<void> _call(Future<Response> call) async {
    try {
      await call;
    } catch (e) {
      throw toFailure(e);
    }
  }

  static User _user(Map j) => User(
    id: j['id'] as String,
    fullName: j['fullName'] as String,
    email: j['email'] as String?,
    phone: j['phone'] as String?,
    language: j['locale'] as String,
    memberships: [
      for (final m in (j['memberships'] as List).cast<Map>())
        Membership(
          hotelId: m['hotelId'] as String,
          role: Role.values.byName((m['role'] as String).toLowerCase()),
          permissions: (m['permissions'] as List).cast<String>(),
        ),
    ],
  );
}
