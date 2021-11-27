import 'package:ambev_track/core/database/database.dart';
import 'package:ambev_track/features/collect/data/datasources/collect_local_data_source.dart';
import 'package:ambev_track/features/collect/data/models/collect_model.dart';
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

  final tNewCollect = CollectModel(
    dateTime: DateTime.now(),
    duration: const Duration(hours: 1, minutes: 30),
    latitude: -10.9282011,
    longitude: -37.0922412,
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
