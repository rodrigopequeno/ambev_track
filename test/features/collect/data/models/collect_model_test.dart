import 'dart:convert';
import 'package:ambev_track/features/collect/data/models/collect_model.dart';
import 'package:ambev_track/features/collect/data/models/geographic_coordinate_model.dart';
import 'package:ambev_track/features/collect/domain/entities/cardinal_point.dart';
import 'package:ambev_track/features/collect/domain/entities/collect.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
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
    dateTime: DateTime(2021, 01, 27, 12, 00, 00),
    duration: const Duration(hours: 1, minutes: 30),
    latitude: tLatitude,
    longitude: tLongitude,
  );

  test('should be a subclass of Collect entity', () async {
    expect(tNewCollect, isA<Collect>());
  });

  group("fromMap", () {
    test('should return a valid model when from JSON', () async {
      final jsonMap =
          json.decode(fixture("collect.json")) as Map<String, dynamic>;

      final result = CollectModel.fromMap(jsonMap);

      expect(result, tNewCollect);
    });
  });

  group("toJson", () {
    test('should return a JSON map containing the proper data', () async {
      final result = tNewCollect.toMap();

      final expectedMap = {
        "dateTime": tNewCollect.dateTime.millisecondsSinceEpoch,
        "duration": tNewCollect.duration.inMilliseconds,
        "latitude": {
          "degrees": 10.0,
          "minutes": 50.0,
          "seconds": 30.0,
          "cardinalPoint": "S",
        },
        "longitude": {
          "degrees": 37.0,
          "minutes": 10.0,
          "seconds": 30.0,
          "cardinalPoint": "W",
        }
      };

      expect(result, expectedMap);
    });
  });
}
