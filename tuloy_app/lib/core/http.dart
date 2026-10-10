import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/auth/presentation/auth_controller.dart';
import 'api.dart';

/// Random key per user action, so a retried request can't create a duplicate.
String newKey() {
  final r = Random.secure();
  return List.generate(16, (_) => r.nextInt(256).toRadixString(16).padLeft(2, '0')).join();
}

/// Thin JSON client for staff/admin screens and guest extras.
/// ponytail: these features have no client-side rules (the API owns them), so they read JSON maps
/// directly instead of per-feature entities/repositories. Add a domain layer to a feature when it gains rules.
class Api {
  Api(this._dio);
  final Dio _dio;

  Future<dynamic> get(String path, [Map<String, dynamic>? query]) => _run(_dio.get(path, queryParameters: query));
  Future<dynamic> post(String path, [Object? body, bool once = false]) => _run(
    _dio.post(
      path,
      data: body ?? const {},
      options: once ? Options(headers: {'Idempotency-Key': newKey()}) : null,
    ),
  );
  Future<dynamic> patch(String path, Object body) => _run(_dio.patch(path, data: body));
  Future<dynamic> put(String path, Object body) => _run(_dio.put(path, data: body));
  Future<dynamic> delete(String path, [Object? body]) => _run(_dio.delete(path, data: body));

  /// Upload to storage through a presigned URL from the API; returns the stored key.
  Future<String> upload(String folder, List<int> bytes, String ext) async {
    final p = await post('/admin/uploads', {'folder': folder, 'ext': ext}) as Map;
    await _run(
      Dio().put(
        p['uploadUrl'] as String,
        data: Stream.fromIterable([bytes]),
        options: Options(headers: {Headers.contentLengthHeader: bytes.length, 'Content-Type': 'image/$ext'}),
      ),
    );
    return p['key'] as String;
  }

  Future<dynamic> _run(Future<Response> r) async {
    try {
      return (await r).data;
    } catch (e) {
      throw toFailure(e);
    }
  }
}

final apiProvider = Provider<Api>((ref) => Api(ref.read(dioProvider)));

/// GET any path; refetches when the language changes. Invalidate with `ref.invalidate(getProvider(path))`.
final getProvider = FutureProvider.autoDispose.family<dynamic, String>((ref, path) {
  ref.watch(languageProvider);
  return ref.read(apiProvider).get(path);
});

/// Shorthands for JSON maps.
typedef J = Map<String, dynamic>;
List<J> jsonList(dynamic v) => (v as List).cast<Map>().map((m) => m.cast<String, dynamic>()).toList();
double num2(dynamic v) => v == null ? 0 : (v is num ? v.toDouble() : double.tryParse('$v') ?? 0);
