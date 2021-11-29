import 'package:ambev_track/features/collect/data/models/geographic_coordinate_model.dart';
import 'package:ambev_track/features/collect/domain/entities/cardinal_point.dart';
import 'package:ambev_track/features/collect/domain/entities/collect.dart';
import 'package:ambev_track/features/collect/domain/repositories/collect_repository.dart';
import 'package:ambev_track/features/collect/domain/usecases/insert_new_collect.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAddCollectRepository extends Mock implements CollectRepository {}

void main() {
  late InsertNewCollect usecase;
  late MockAddCollectRepository mockAddCollectRepository;

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
  final tNewCollect = Collect(
    dateTime: DateTime.now(),
    duration: const Duration(hours: 1, minutes: 30),
    latitude: tLatitude,
    longitude: tLongitude,
  );

  setUpAll(() {
    registerFallbackValue(tNewCollect);
  });

  setUp(() {
    mockAddCollectRepository = MockAddCollectRepository();
    usecase = InsertNewCollect(repository: mockAddCollectRepository);
  });

  test('should insert new collect from the repository', () async {
    when(() =>
            mockAddCollectRepository.addCollect(collect: any(named: "collect")))
        .thenAnswer((_) async => const Right(unit));

    final result =
        await usecase(InsertNewCollectParams(newCollect: tNewCollect));

    expect(result, const Right(unit));
    verify(() => mockAddCollectRepository.addCollect(collect: tNewCollect));
    verifyNoMoreInteractions(mockAddCollectRepository);
  });
}
