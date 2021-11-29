import 'package:ambev_track/core/error/exceptions/server_exception.dart';
import 'package:ambev_track/core/service/response_service/response_service.dart';
import 'package:ambev_track/core/service/service.dart';
import 'package:ambev_track/features/collect/data/datasources/collect_remote_data_source.dart';
import 'package:ambev_track/features/collect/data/models/collect_model.dart';
import 'package:ambev_track/features/collect/data/models/geographic_coordinate_model.dart';
import 'package:ambev_track/features/collect/domain/entities/cardinal_point.dart';
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

  final tLatitude = GeographicCoordinateModel(
    cardinalPoint: CardinalPoint.south,
    degrees: 10,
    minutes: 50,
    seconds: 30,
  );
  final tLongitude = GeographicCoordinateModel(
    cardinalPoint: CardinalPoint.west,
    degrees: 37,
    minutes: 10,
    seconds: 30,
  );

  final tNewCollect = CollectModel(
    dateTime: DateTime.now(),
    duration: const Duration(hours: 1, minutes: 30),
    latitude: tLatitude,
    longitude: tLongitude,
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
    test(
        'should perform a POST request on a URL the endpoint and with the collect data',
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
