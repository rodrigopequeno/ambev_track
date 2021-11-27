import 'package:ambev_track/features/add_collect/domain/entities/collect.dart';
import 'package:ambev_track/features/add_collect/domain/repositories/add_collect_repository.dart';
import 'package:ambev_track/features/add_collect/domain/usecases/insert_new_collect.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAddCollectRepository extends Mock implements AddCollectRepository {}

void main() {
  late InsertNewCollect usecase;
  late MockAddCollectRepository mockAddCollectRepository;

  final tNewCollect = Collect(
    duration: const Duration(hours: 1, minutes: 30),
    latitude: -10.9282011,
    longitude: -37.0922412,
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
