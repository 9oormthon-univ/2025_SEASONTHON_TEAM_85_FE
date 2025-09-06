class ApiException implements Exception {
  final int status;
  final String errorCode;
  final String message;

  ApiException(this.status, this.errorCode, this.message);

  @override
  String toString() => 'ApiException($status, $errorCode): $message';
}
