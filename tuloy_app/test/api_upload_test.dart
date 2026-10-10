import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tuloy_app/core/http.dart';

/// Resolves every request in-process, so no network is touched.
class _Stub extends Interceptor {
  _Stub(this.respond);
  final Response Function(RequestOptions o) respond;
  final List<RequestOptions> seen = [];

  @override
  void onRequest(RequestOptions o, RequestInterceptorHandler h) {
    seen.add(o);
    h.resolve(respond(o));
  }
}

void main() {
  test('upload sends the photo as bytes with length and type, and returns the key', () async {
    final bytes = Uint8List.fromList(List.generate(64, (i) => i));

    final apiDio = Dio(BaseOptions(baseUrl: 'http://api.test'));
    final apiStub = _Stub((o) => Response(
      requestOptions: o,
      data: {'uploadUrl': 'http://upload.test/x', 'key': 'rooms/x.png'},
    ));
    apiDio.interceptors.add(apiStub);

    final uploadDio = Dio();
    final putStub = _Stub((o) => Response(requestOptions: o, statusCode: 200, data: ''));
    uploadDio.interceptors.add(putStub);

    final key = await Api(apiDio, uploadDio: uploadDio).upload('rooms', bytes, 'png');

    expect(key, 'rooms/x.png');
    expect(apiStub.seen.single.path, '/admin/uploads');
    expect(apiStub.seen.single.method, 'POST');

    final put = putStub.seen.single;
    expect(put.method, 'PUT');
    expect(put.uri.toString(), 'http://upload.test/x');
    expect(put.data, isA<Uint8List>());
    expect(put.data, equals(bytes));
    expect(put.headers[Headers.contentLengthHeader], bytes.length);
    expect(put.headers['Content-Type'], 'image/png');
  });
}
