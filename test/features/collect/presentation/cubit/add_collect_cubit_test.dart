import 'package:ambev_track/core/error/failure.dart';
import 'package:ambev_track/core/utils/duration_converter/duration_converter.dart';
import 'package:ambev_track/features/collect/data/models/collect_model.dart';
import 'package:ambev_track/features/collect/data/models/geographic_coordinate_model.dart';
import 'package:ambev_track/features/collect/domain/entities/cardinal_point.dart';
import 'package:ambev_track/features/collect/domain/usecases/insert_new_collect.dart';
import 'package:ambev_track/features/collect/domain/usecases/validate_geographic_coordinate.dart';
import 'package:ambev_track/features/collect/presentation/cubit/add_collect_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockInsertNewCollect extends Mock implements InsertNewCollect {}

class MockValidateGeographicCoordinate extends Mock
    implements ValidateGeographicCoordinate {}

class MockDurationConverter extends Mock implements DurationConverter {}

class MockBuildContext extends Mock implements BuildContext {}

class FakeBuildContext extends Fake implements BuildContext {}

void main() {
  late AddCollectCubit cubit;
  late MockInsertNewCollect mockInsertNewCollect;
  late MockValidateGeographicCoordinate mockValidateGeographicCoordinate;
  late MockDurationConverter mockDurationConverter;

  const tDurationText = "01h 30m 00s";
  const tDuration = Duration(hours: 1, minutes: 30);
  const tLatitudeText = """00° 00' 00,00"N""";
  const tLongitudeText = """000° 00' 00,00"E""";
  final tDateTime = DateTime.now();
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
    dateTime: tDateTime,
    duration: tDuration,
    latitude: tLatitude,
    longitude: tLongitude,
  );

  setUp(() {
    mockInsertNewCollect = MockInsertNewCollect();
    mockValidateGeographicCoordinate = MockValidateGeographicCoordinate();
    mockDurationConverter = MockDurationConverter();

    cubit = AddCollectCubit(
      insertNewCollect: mockInsertNewCollect,
      validateGeographicCoordinate: mockValidateGeographicCoordinate,
      durationConverter: mockDurationConverter,
    );
  });
  setUpAll(() {
    registerFallbackValue(
      const ValidateGeographicCoordinateParams(
        latitudeText: tLatitudeText,
        longitudeText: tLongitudeText,
      ),
    );
    registerFallbackValue(InsertNewCollectParams(newCollect: tNewCollect));
    registerFallbackValue(tDuration);
    registerFallbackValue(FakeBuildContext());
  });

  void setUpMockDurationConverterSuccess() {
    when(() => mockDurationConverter.fromStringHHhMMmSSs(any()))
        .thenReturn(const Right(tDuration));
    when(() => mockDurationConverter.toStringFormattedHHhMMmSSs(any()))
        .thenReturn(tDurationText);
  }

  test('initial state should be AddCollectInitial', () async {
    expect(cubit.state, isA<AddCollectInitial>());
  });

  group('Add Collect', () {
    void setUpMockValidateGeographicCoordinateSuccess() {
      when(() => mockValidateGeographicCoordinate.call(any()))
          .thenAnswer((_) async => Right(Tuple2(tLatitude, tLongitude)));
    }

    blocTest<AddCollectCubit, AddCollectState>(
      '''should call the ValidateGeographicCoordinate to validate and convert the string to GeographicCoordinate''',
      build: () {
        setUpMockValidateGeographicCoordinateSuccess();
        setUpMockDurationConverterSuccess();
        when(() => mockInsertNewCollect(any()))
            .thenAnswer((_) async => const Right(unit));
        return cubit;
      },
      act: (cubit) async => await cubit.addCollect(),
      verify: (_) => verify(
        () => mockValidateGeographicCoordinate(
          ValidateGeographicCoordinateParams(
            latitudeText: cubit.textEditingLatitudeController.text,
            longitudeText: cubit.textEditingLongitudeController.text,
          ),
        ),
      ),
    );

    blocTest<AddCollectCubit, AddCollectState>(
      'should emit [AddCollectErrorDurationField] when the duration is invalid',
      build: () {
        setUpMockDurationConverterSuccess();
        when(() => mockDurationConverter.fromStringHHhMMmSSs(any()))
            .thenReturn(Left(InvalidDurationFailure()));
        return cubit;
      },
      act: (cubit) => cubit.addCollect(),
      expect: () => [AddCollectLoading(), isA<AddCollectErrorDurationField>()],
    );

    blocTest<AddCollectCubit, AddCollectState>(
      'should emit [AddCollectErrorDurationField] when the duration is zero',
      build: () {
        setUpMockDurationConverterSuccess();
        when(() => mockDurationConverter.fromStringHHhMMmSSs(any()))
            .thenReturn(const Right(Duration.zero));
        return cubit;
      },
      act: (cubit) => cubit.addCollect(),
      expect: () => [AddCollectLoading(), isA<AddCollectErrorDurationField>()],
    );
    blocTest<AddCollectCubit, AddCollectState>(
      'should emit [AddCollectErrorCoordinateLatitudeField] when the geographic coordinate latitude is invalid',
      build: () {
        setUpMockDurationConverterSuccess();
        when(() => mockValidateGeographicCoordinate(any()))
            .thenAnswer((_) async => Left(InvalidGeographicLatitudeFailure()));
        return cubit;
      },
      act: (cubit) => cubit.addCollect(),
      expect: () =>
          [AddCollectLoading(), isA<AddCollectErrorCoordinateLatitudeField>()],
    );

    blocTest<AddCollectCubit, AddCollectState>(
      'should emit [AddCollectErrorCoordinateLongitudeField] when the geographic coordinate longitude is invalid',
      build: () {
        setUpMockDurationConverterSuccess();
        when(() => mockValidateGeographicCoordinate(any()))
            .thenAnswer((_) async => Left(InvalidGeographicLongitudeFailure()));
        return cubit;
      },
      act: (cubit) => cubit.addCollect(),
      expect: () =>
          [AddCollectLoading(), isA<AddCollectErrorCoordinateLongitudeField>()],
    );

    blocTest<AddCollectCubit, AddCollectState>(
      'should emit [AddCollectErrorCoordinateLatitudeField] when the geographic coordinate latitude is invalid',
      build: () {
        setUpMockDurationConverterSuccess();
        when(() => mockValidateGeographicCoordinate(any())).thenAnswer(
            (_) async => Left(InvalidGeographicLatitudeDegreeusFailure()));
        return cubit;
      },
      act: (cubit) => cubit.addCollect(),
      expect: () =>
          [AddCollectLoading(), isA<AddCollectErrorCoordinateLatitudeField>()],
    );

    blocTest<AddCollectCubit, AddCollectState>(
      'should emit [AddCollectErrorCoordinateLongitudeField] when the geographic coordinate longitude is invalid',
      build: () {
        setUpMockDurationConverterSuccess();
        when(() => mockValidateGeographicCoordinate(any())).thenAnswer(
            (_) async => Left(InvalidGeographicLongitudeDegreeusFailure()));
        return cubit;
      },
      act: (cubit) => cubit.addCollect(),
      expect: () =>
          [AddCollectLoading(), isA<AddCollectErrorCoordinateLongitudeField>()],
    );

    blocTest<AddCollectCubit, AddCollectState>(
      'should send the data to the use case',
      build: () {
        setUpMockDurationConverterSuccess();
        setUpMockValidateGeographicCoordinateSuccess();
        when(() => mockInsertNewCollect(any()))
            .thenAnswer((_) async => const Right(unit));
        return cubit;
      },
      act: (cubit) => cubit.addCollect(dateTime: tDateTime),
      verify: (cubit) => verify(
        () => mockInsertNewCollect(
          InsertNewCollectParams(newCollect: tNewCollect),
        ),
      ),
    );

    blocTest<AddCollectCubit, AddCollectState>(
      'should emit [AddCollectLoading, AddCollectSuccess] when add collect with successfully',
      build: () {
        setUpMockDurationConverterSuccess();
        setUpMockValidateGeographicCoordinateSuccess();
        when(() => mockInsertNewCollect(any()))
            .thenAnswer((_) async => const Right(unit));
        return cubit;
      },
      act: (cubit) => cubit.addCollect(),
      expect: () => [AddCollectLoading(), AddCollectSuccess()],
    );

    blocTest<AddCollectCubit, AddCollectState>(
      'should emit [AddCollectLoading, AddCollectError] when adding a collect fails',
      build: () {
        setUpMockDurationConverterSuccess();
        setUpMockValidateGeographicCoordinateSuccess();
        when(() => mockInsertNewCollect(any()))
            .thenAnswer((_) async => Left(ServerFailure()));
        return cubit;
      },
      act: (cubit) => cubit.addCollect(),
      expect: () => [
        AddCollectLoading(),
        AddCollectError(messageError),
      ],
    );
  });
}
