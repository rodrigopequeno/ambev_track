import 'response_service/response_service.dart';

abstract class Service {
  Future<ResponseService<T?>> post<T>({
    required String path,
    required Map<String, dynamic> body,
  });
}
