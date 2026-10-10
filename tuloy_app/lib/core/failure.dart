/// Error surfaced to the UI. `code` mirrors the API's stable error codes
/// (INVALID_CREDENTIALS, ACCOUNT_EXISTS, ...); `NETWORK` means the server was unreachable.
class Failure implements Exception {
  const Failure(this.code, [this.message]);
  final String code;

  /// Already localized by the API (Accept-Language). Null for NETWORK.
  final String? message;

  @override
  String toString() => 'Failure($code)';
}
