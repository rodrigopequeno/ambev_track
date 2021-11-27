import 'dart:convert';
import 'package:ambev_track/core/error/exceptions/invalid_geographic_coordinate_exception.dart';
import 'package:ambev_track/features/collect/data/models/geographic_coordinate_model.dart';
import 'package:ambev_track/features/collect/domain/entities/cardinal_point.dart';
import 'package:ambev_track/features/collect/domain/entities/geographic_coordinate.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tGeographicCoordinate = GeographicCoordinateModel(
    cardinalPoint: CardinalPoint.south,
    degrees: 10,
    minutes: 50,
    seconds: 30,
  );

  test('should be a subclass of GeographicCoordinate entity', () async {
    expect(tGeographicCoordinate, isA<GeographicCoordinate>());
  });

  group("InvalidGeographicCoordinate", () {
    test(
        'should throw InvalidGeographicCoordinateException when latitude coordinate is greater than 90 degrees',
        () async {
      expect(
        () => GeographicCoordinateModel(
          cardinalPoint: CardinalPoint.south,
          degrees: 91,
          minutes: 50,
          seconds: 30,
        ),
        throwsA(isA<InvalidGeographicCoordinateException>()),
      );
      expect(
        () => GeographicCoordinateModel(
          cardinalPoint: CardinalPoint.north,
          degrees: 91,
          minutes: 50,
          seconds: 30,
        ),
        throwsA(isA<InvalidGeographicCoordinateException>()),
      );
    });

    test(
        'should throw InvalidGeographicCoordinateException when latitude coordinate is less than 0 degrees',
        () async {
      expect(
        () => GeographicCoordinateModel(
          cardinalPoint: CardinalPoint.south,
          degrees: -1,
          minutes: 50,
          seconds: 30,
        ),
        throwsA(isA<InvalidGeographicCoordinateException>()),
      );
      expect(
        () => GeographicCoordinateModel(
          cardinalPoint: CardinalPoint.north,
          degrees: -1,
          minutes: 50,
          seconds: 30,
        ),
        throwsA(isA<InvalidGeographicCoordinateException>()),
      );
    });
    test(
        'should throw InvalidGeographicCoordinateException when longitude coordinate is greater than 180 degrees',
        () async {
      expect(
        () => GeographicCoordinateModel(
          cardinalPoint: CardinalPoint.south,
          degrees: 181,
          minutes: 50,
          seconds: 30,
        ),
        throwsA(isA<InvalidGeographicCoordinateException>()),
      );
      expect(
        () => GeographicCoordinateModel(
          cardinalPoint: CardinalPoint.north,
          degrees: 181,
          minutes: 50,
          seconds: 30,
        ),
        throwsA(isA<InvalidGeographicCoordinateException>()),
      );
    });

    test(
        'should throw InvalidGeographicCoordinateException when longitude coordinate is less than 0 degrees',
        () async {
      expect(
        () => GeographicCoordinateModel(
          cardinalPoint: CardinalPoint.south,
          degrees: -1,
          minutes: 50,
          seconds: 30,
        ),
        throwsA(isA<InvalidGeographicCoordinateException>()),
      );
      expect(
        () => GeographicCoordinateModel(
          cardinalPoint: CardinalPoint.north,
          degrees: -1,
          minutes: 50,
          seconds: 30,
        ),
        throwsA(isA<InvalidGeographicCoordinateException>()),
      );
    });
  });

  group("fromMap", () {
    test('should return a valid model when from JSON', () async {
      final jsonMap = json.decode(fixture("geographic_coordinate.json"))
          as Map<String, dynamic>;

      final result = GeographicCoordinateModel.fromMap(jsonMap);

      expect(result, tGeographicCoordinate);
    });
  });

  group("toJson", () {
    test('should return a JSON map containing the proper data', () async {
      final result = tGeographicCoordinate.toMap();

      final expectedMap = {
        "degrees": 10.0,
        "minutes": 50.0,
        "seconds": 30.0,
        "cardinalPoint": "S",
      };

      expect(result, expectedMap);
    });
  });

  group("toDecimal", () {
    test('should return geographic coordinate in decimal', () async {
      final result = tGeographicCoordinate.toDecimal();
      const expectedDecimal = -10.841666666666667;
      expect(result, expectedDecimal);
    });
  });

  group("fromDecimal", () {
    test(
        'should return a valid model when giving a decimal value and the cardinal point',
        () async {
      const decimalCoordinate = -10.841666666666667;
      const cardinalPoint = CardinalPoint.south;

      final result = GeographicCoordinateModel.fromDecimal(
        decimalCoordinate: decimalCoordinate,
        cardinalPoint: cardinalPoint,
      );

      expect(result, tGeographicCoordinate);
    });
  });
}
