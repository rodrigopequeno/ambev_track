import 'package:dio/dio.dart';

import '../error/exceptions/server_exception.dart';
import 'response_service/response_service.dart';
import 'service.dart';

class DioServiceImpl extends Service {
  final Dio dio;

  DioServiceImpl({required this.dio});

  @override
  Future<ResponseService<T?>> post<T>(
      {required String path,
      required Map<String, dynamic> body,
      Map<String, dynamic>? queryParameters}) async {
    try {
      final Response<T?> response = await dio.post(
        path,
        data: body,
        queryParameters: queryParameters,
      );
      return ResponseService<T?>(
        data: response.data,
        headers: response.headers.map,
        requestOptions: {
          "path": response.requestOptions.path,
          "data": response.requestOptions.data,
        },
        statusCode: response.statusCode,
        statusMessage: response.statusMessage,
      );
    } on DioError catch (e) {
      throw ServerException(
        response: ResponseService(
          data: e.response?.data,
          headers: e.response?.headers.map,
          requestOptions: {
            "path": e.requestOptions.path,
            "data": e.requestOptions.data,
          },
          statusCode: e.response?.statusCode,
          statusMessage: e.response?.statusMessage,
        ),
        error: e.error,
        type: _converterDioErrorToServerException(e.type),
      );
    }
  }

  ServerExceptionType _converterDioErrorToServerException(DioErrorType type) {
    switch (type) {
      case DioErrorType.connectTimeout:
        return ServerExceptionType.connectTimeout;
      case DioErrorType.sendTimeout:
        return ServerExceptionType.sendTimeout;
      case DioErrorType.receiveTimeout:
        return ServerExceptionType.receiveTimeout;
      case DioErrorType.response:
        return ServerExceptionType.response;
      case DioErrorType.cancel:
        return ServerExceptionType.cancel;
      case DioErrorType.other:
        return ServerExceptionType.other;
    }
  }
}
