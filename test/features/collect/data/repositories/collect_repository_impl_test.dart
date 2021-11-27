import 'package:ambev_track/core/error/exceptions/server_exception.dart';
import 'package:ambev_track/core/network/network_info.dart';
import 'package:ambev_track/features/collect/data/datasources/collect_local_data_source.dart';
import 'package:ambev_track/features/collect/data/datasources/collect_remote_data_source.dart';
import 'package:ambev_track/features/collect/data/models/collect_model.dart';
import 'package:ambev_track/features/collect/data/repositories/collect_repository_impl.dart';
import 'package:ambev_track/features/collect/domain/repositories/collect_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCollectLocalDataSource extends Mock
    implements CollectLocalDataSource {}

class MockCollectRemoteDataSource extends Mock
    implements CollectRemoteDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late CollectRepository repository;
  late MockCollectLocalDataSource mockCollectLocalDataSource;
  late MockCollectRemoteDataSource mockCollectRemoteDataSource;
  late NetworkInfo mockNetworkInfo;

  setUp(() {
    mockCollectLocalDataSource = MockCollectLocalDataSource();
    mockCollectRemoteDataSource = MockCollectRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = CollectRepositoryImpl(
      collectLocalDataSource: mockCollectLocalDataSource,
      collectRemoteDataSource: mockCollectRemoteDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  final tNewCollect = CollectModel(
    dateTime: DateTime.now(),
    duration: const Duration(hours: 1, minutes: 30),
    latitude: -10.9282011,
    longitude: -37.0922412,
  );

  setUpAll(() {
    registerFallbackValue(tNewCollect);
  });

  void runTestsOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      body();
    });
  }

  void runTestsOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      body();
    });
  }

  group('addCollect', () {
    test('should check if the device is online', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockCollectRemoteDataSource.insertNewCollect(
              collectModel: any(named: "collectModel")))
          .thenAnswer((_) async => unit);
      when(() => mockCollectLocalDataSource.saveUnsentCollect(
              collectModel: any(named: "collectModel")))
          .thenAnswer((_) async => unit);
      when(() => mockCollectLocalDataSource.saveCacheNewCollect(
              collectModel: any(named: "collectModel")))
          .thenAnswer((_) async => unit);
      await repository.addCollect(collect: tNewCollect);
      verify(() => mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      test('''should make a successful call to the remote data source''',
          () async {
        when(() => mockCollectRemoteDataSource.insertNewCollect(
                collectModel: any(named: "collectModel")))
            .thenAnswer((_) async => unit);
        when(() => mockCollectLocalDataSource.saveCacheNewCollect(
                collectModel: any(named: "collectModel")))
            .thenAnswer((_) async => unit);
        final result = await repository.addCollect(collect: tNewCollect);
        verify(() => mockCollectRemoteDataSource.insertNewCollect(
            collectModel: tNewCollect));
        expect(result, equals(const Right(unit)));
      });

      test(
          '''should cache the data locally when the call to remote data source is successful''',
          () async {
        when(() => mockCollectRemoteDataSource.insertNewCollect(
                collectModel: any(named: "collectModel")))
            .thenAnswer((_) async => unit);
        when(() => mockCollectLocalDataSource.saveCacheNewCollect(
                collectModel: any(named: "collectModel")))
            .thenAnswer((_) async => unit);
        await repository.addCollect(collect: tNewCollect);
        verify(() => mockCollectRemoteDataSource.insertNewCollect(
            collectModel: tNewCollect));
        verify(() => mockCollectLocalDataSource.saveCacheNewCollect(
            collectModel: tNewCollect));
      });

      test(
          '''should save to "not sent" when the call to remote data source is unsuccessful''',
          () async {
        when(() => mockCollectRemoteDataSource.insertNewCollect(
                collectModel: any(named: "collectModel")))
            .thenThrow(ServerException());
        when(() => mockCollectLocalDataSource.saveUnsentCollect(
                collectModel: any(named: "collectModel")))
            .thenAnswer((_) async => unit);
        final result = await repository.addCollect(collect: tNewCollect);
        verify(() => mockCollectRemoteDataSource.insertNewCollect(
            collectModel: tNewCollect));
        verify(() => mockCollectLocalDataSource.saveUnsentCollect(
            collectModel: tNewCollect));
        expect(result, equals(const Right(unit)));
      });
    });

    runTestsOffline(() {
      test('should save data locally as unsent', () async {
        when(() => mockCollectLocalDataSource.saveUnsentCollect(
                collectModel: any(named: "collectModel")))
            .thenAnswer((_) async => unit);
        final result = await repository.addCollect(collect: tNewCollect);
        verifyZeroInteractions(mockCollectRemoteDataSource);
        verify(() => mockCollectLocalDataSource.saveUnsentCollect(
            collectModel: tNewCollect));
        expect(result, equals(const Right(unit)));
      });
    });
  });
}
