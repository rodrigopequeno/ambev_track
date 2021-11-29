import '../../service/response_service/response_service.dart';

enum ServerExceptionType {
  connectTimeout,
  sendTimeout,
  receiveTimeout,
  response,
  cancel,
  other,
}

class ServerException implements Exception {
  ServerException({
    this.response,
    this.error,
    this.type = ServerExceptionType.other,
  });

  ResponseService? response;

  ServerExceptionType type;

  dynamic error;
}
