import 'package:ambev_track/core/database/database.dart';
import 'package:ambev_track/features/collect/data/datasources/collect_local_data_source.dart';
import 'package:ambev_track/features/collect/data/models/collect_model.dart';
import 'package:ambev_track/features/collect/data/models/geographic_coordinate_model.dart';
import 'package:ambev_track/features/collect/domain/entities/cardinal_point.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDatabase extends Mock implements Database {}

void main() {
  late Database database;
  late CollectLocalDataSource collectDataSource;

  setUpAll(() {
    database = MockDatabase();
    collectDataSource = CollectLocalDataSourceImpl(database: database);
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

  group('saveCacheNewCollect', () {
    test('should call Database to cache the data', () async {
      when(() => database.get(
            boxName: any(named: "boxName"),
            key: any(named: "key"),
          )).thenAnswer((_) async => Future<List<CollectModel>>.value([]));
      when(() => database.put(
            boxName: any(named: "boxName"),
            key: any(named: "key"),
            value: any(named: "value"),
          )).thenAnswer((_) async => Future<void>.value());
      await collectDataSource.saveCacheNewCollect(collectModel: tNewCollect);
      verify(
          () => database.get(boxName: boxCacheCollect, key: boxCacheCollect));
      verify(
        () => database.put(
          boxName: boxCacheCollect,
          key: boxCacheCollect,
          value: [tNewCollect],
        ),
      );
    });
  });

  group('saveUnsentCollect', () {
    test('should call Database to unsent the data', () async {
      when(() => database.get(
            boxName: any(named: "boxName"),
            key: any(named: "key"),
          )).thenAnswer((_) async => Future<List<CollectModel>>.value([]));
      when(() => database.put(
            boxName: any(named: "boxName"),
            key: any(named: "key"),
            value: any(named: "value"),
          )).thenAnswer((_) async => Future<void>.value());
      await collectDataSource.saveUnsentCollect(collectModel: tNewCollect);
      verify(
          () => database.get(boxName: boxUnsentCollect, key: boxUnsentCollect));
      verify(
        () => database.put(
          boxName: boxUnsentCollect,
          key: boxUnsentCollect,
          value: [tNewCollect],
        ),
      );
    });
  });
}
