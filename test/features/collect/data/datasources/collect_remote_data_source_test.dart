import 'package:ambev_track/core/error/exceptions/server_exception.dart';
import 'package:ambev_track/core/service/response_service/response_service.dart';
import 'package:ambev_track/core/service/service.dart';
import 'package:ambev_track/features/collect/data/datasources/collect_remote_data_source.dart';
import 'package:ambev_track/features/collect/data/models/collect_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockService extends Mock implements Service {}

void main() {
  late Service service;
  late CollectRemoteDataSource collectDataSource;

  setUpAll(() {
    service = MockService();
    collectDataSource = CollectRemoteDataSourceImpl(service: service);
  });

  final tNewCollect = CollectModel(
    dateTime: DateTime.now(),
    duration: const Duration(hours: 1, minutes: 30),
    latitude: -10.9282011,
    longitude: -37.0922412,
  );

  void setUpMockServiceSuccess() {
    when(() => service.post(path: any(named: "path"), body: any(named: "body")))
        .thenAnswer(
      (_) async => ResponseService(
        data: fixture('collect.json'),
        statusCode: 200,
        requestOptions: const {},
      ),
    );
  }

  void setupUpMockServiceFailure() {
    when(() => service.post(path: any(named: "path"), body: any(named: "body")))
        .thenAnswer(
      (_) async => const ResponseService(
        data: 'Something went wrong',
        statusCode: 404,
        requestOptions: {},
      ),
    );
  }

  group('insertNewCollect', () {
    /// TODO: Falta o endpoint
    test(
        'must perform a POST request on a URL with "path" being the endpoint and with the collect data',
        () async {
      setUpMockServiceSuccess();
      await collectDataSource.insertNewCollect(collectModel: tNewCollect);
      verify(() => service.post(
            path: insertNewCollectPath,
            body: tNewCollect.toMap(),
          ));
    });

    test('should throw a ServerException when the response code is not 200',
        () async {
      setupUpMockServiceFailure();
      final call = collectDataSource.insertNewCollect;
      expect(() => call(collectModel: tNewCollect),
          throwsA(isA<ServerException>()));
    });
  });
}
