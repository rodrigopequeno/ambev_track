import 'package:ambev_track/core/error/exceptions/invalid_symbol_exception.dart';
import 'package:ambev_track/core/error/failure.dart';
import 'package:ambev_track/features/collect/domain/entities/cardinal_point.dart';
import 'package:ambev_track/features/collect/domain/entities/geographic_coordinate.dart';
import 'package:ambev_track/features/collect/domain/usecases/validate_geographic_coordinate.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late ValidateGeographicCoordinate usecase;

  setUp(() {
    usecase = ValidateGeographicCoordinate();
  });

  group("ValidateGeographicCoordinate", () {
    test('should return the geographic coordinates converted successfully',
        () async {
      const tLatitudeText = """11° 22' 33,44"N""";
      const tLongitudeText = """111° 22' 33,44"E""";
      final tLatitude = GeographicCoordinate(
        degrees: 11,
        minutes: 22,
        seconds: 33.44,
        cardinalPoint: CardinalPoint.north,
      );
      final tLongitude = GeographicCoordinate(
        degrees: 111,
        minutes: 22,
        seconds: 33.44,
        cardinalPoint: CardinalPoint.east,
      );
      final result = await usecase(
        const ValidateGeographicCoordinateParams(
            latitudeText: tLatitudeText, longitudeText: tLongitudeText),
      );

      expect(result, Right(Tuple2(tLatitude, tLongitude)));
    });

    test(
        'should return [InvalidGeographicCardinalLatitudeFailure] when the latitude coordinate does not have a valid cardinal point',
        () async {
      const tLatitudeText = """11° 22' 33,44\"""";
      const tLongitudeText = """111° 22' 33,44"E""";
      final result = await usecase(
        const ValidateGeographicCoordinateParams(
            latitudeText: tLatitudeText, longitudeText: tLongitudeText),
      );

      expect(result, Left(InvalidGeographicCardinalLatitudeFailure()));
    });

    test(
        'should return [InvalidGeographicCardinalLongitudeFailure] when the longitude coordinate does not have a valid cardinal point',
        () async {
      const tLatitudeText = """11° 22' 33,44"N""";
      const tLongitudeText = """111° 22' 33,44\"""";
      final result = await usecase(
        const ValidateGeographicCoordinateParams(
            latitudeText: tLatitudeText, longitudeText: tLongitudeText),
      );

      expect(result, Left(InvalidGeographicCardinalLongitudeFailure()));
    });

    test(
        'should return [InvalidGeographicCardinalLatitudeFailure] when the latitude coordinate does not have a valid cardinal point',
        () async {
      const tLatitudeText = """11° 22' 33,44\"""";
      const tLongitudeText = """111° 22' 33,44"E""";
      final result = await usecase(
        const ValidateGeographicCoordinateParams(
            latitudeText: tLatitudeText, longitudeText: tLongitudeText),
      );

      expect(result, Left(InvalidGeographicCardinalLatitudeFailure()));
    });

    test(
        'should return [InvalidGeographicCardinalLongitudeFailure] when the longitude coordinate does not have a valid cardinal point',
        () async {
      const tLatitudeText = """11° 22' 33,44"N""";
      const tLongitudeText = """111° 22' 33,44\"""";
      final result = await usecase(
        const ValidateGeographicCoordinateParams(
            latitudeText: tLatitudeText, longitudeText: tLongitudeText),
      );

      expect(result, Left(InvalidGeographicCardinalLongitudeFailure()));
    });

    test(
        'should return [InvalidGeographicLatitudeFailure] when the latitude coordinate is invalid',
        () async {
      const tLatitudeText = """11° 22' 33,44N""";
      const tLongitudeText = """111° 22' 33,44"E""";
      final result = await usecase(
        const ValidateGeographicCoordinateParams(
            latitudeText: tLatitudeText, longitudeText: tLongitudeText),
      );

      expect(result, Left(InvalidGeographicLatitudeFailure()));
    });

    test(
        'should return [InvalidGeographicLongitudeFailure] when the longitude coordinate is invalid',
        () async {
      const tLatitudeText = """11° 22' 33,44"N""";
      const tLongitudeText = """111° 22' 33,44E""";
      final result = await usecase(
        const ValidateGeographicCoordinateParams(
            latitudeText: tLatitudeText, longitudeText: tLongitudeText),
      );

      expect(result, Left(InvalidGeographicLongitudeFailure()));
    });

    test(
        'should return [InvalidGeographicLatitudeDegreesFailure] when the latitude coordinate does not have a valid degree',
        () async {
      const tLatitudeText = """91° 00' 00,00"N""";
      const tLongitudeText = """111° 22' 33,44"E""";
      final result = await usecase(
        const ValidateGeographicCoordinateParams(
            latitudeText: tLatitudeText, longitudeText: tLongitudeText),
      );

      expect(result, Left(InvalidGeographicLatitudeDegreesFailure()));
    });

    test(
        'should return [InvalidGeographicLongitudeDegreesFailure] when the longitude coordinate does not have a valid degree',
        () async {
      const tLatitudeText = """11° 22' 33,44"N""";
      const tLongitudeText = """181° 00' 00,00"E""";
      final result = await usecase(
        const ValidateGeographicCoordinateParams(
            latitudeText: tLatitudeText, longitudeText: tLongitudeText),
      );

      expect(result, Left(InvalidGeographicLongitudeDegreesFailure()));
    });
  });

  group('fromText', () {
    test(
        'should return [InvalidGeographicLongitudeDegreesFailure] when the longitude coordinate does not have a valid degree',
        () async {
      const tCoordinateText = """11° 22' 33,44""";
      expect(
        () => usecase.fromText(coordinateText: tCoordinateText),
        throwsA(isA<InvalidSymbolException>()),
      );
    });
  });
}
