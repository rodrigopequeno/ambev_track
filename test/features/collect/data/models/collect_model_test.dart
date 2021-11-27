import 'dart:convert';
import 'package:ambev_track/features/collect/data/models/collect_model.dart';
import 'package:ambev_track/features/collect/domain/entities/collect.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tNewCollect = CollectModel(
    dateTime: DateTime(2021, 01, 27, 12, 00, 00),
    duration: const Duration(hours: 1, minutes: 30),
    latitude: -10.9282011,
    longitude: -37.0922412,
  );

  test('should be a subclass of Character entity', () async {
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
        "latitude": tNewCollect.latitude,
        "longitude": tNewCollect.longitude,
      };

      expect(result, expectedMap);
    });
  });
}
