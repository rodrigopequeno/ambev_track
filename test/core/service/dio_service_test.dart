import 'package:ambev_track/core/error/exceptions/server_exception.dart';
import 'package:ambev_track/core/service/dio_service.dart';
import 'package:ambev_track/core/service/response_service/response_service.dart';
import 'package:ambev_track/core/service/service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late Dio mockDio;
  late Service service;

  setUp(() {
    mockDio = MockDio();
    service = DioServiceImpl(dio: mockDio);
  });

  const path = "/add";
  const body = {
    "parameter1": 1,
    "parameter2": 2,
    "parameter3": 3,
  };
  const tResponse = ResponseService(
    requestOptions: {'path': path, 'data': {}},
    headers: {},
  );

  group('post', () {
    test('should make a POST request', () async {
      when(() => mockDio.post(any(), data: any(named: "data"))).thenAnswer(
          (_) async =>
              Response(requestOptions: RequestOptions(path: path, data: {})));

      final result = await service.post(path: path, body: body);
      verify(() => mockDio.post(path, data: body));
      expect(result, tResponse);
    });

    test('should throw ServerException if a DioError occurs', () async {
      when(() => mockDio.post(any(), data: any(named: "data"))).thenThrow(
          DioError(requestOptions: RequestOptions(path: path, data: {})));

      expect(() => service.post(path: path, body: body),
          throwsA(isA<ServerException>()));
    });
  });
}
