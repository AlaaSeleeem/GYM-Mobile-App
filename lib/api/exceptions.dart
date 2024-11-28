class ClientErrorException implements Exception {
  final int statusCode;
  final Map<String, dynamic> responseBody;

  const ClientErrorException(
      {required this.statusCode, required this.responseBody});

  @override
  String toString() {
    return "Client error with status code: $statusCode}\n$responseBody";
  }
}
