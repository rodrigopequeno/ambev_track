import 'package:ambev_track/core/utils/duration_converter/duration_converter.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late DurationConverter durationConverter;

  setUp(() {
    durationConverter = DurationConverter();
  });

  group('toStringFormattedHHhMMmSSs', () {
    test('''should return string duration in HHh MMm SSs format''', () async {
      const duration = Duration(hours: 11, minutes: 33, seconds: 22);
      final result = durationConverter.toStringFormattedHHhMMmSSs(duration);
      expect(result, equals("11h 33m 22s"));
    });
  });

  group('fromStringHHhMMmSSs', () {
    test('''should return Duration from HHh MMm SSs format''', () async {
      const durationText = "11h 33m 22s";
      final result = durationConverter.fromStringHHhMMmSSs(durationText);
      expect(result,
          equals(const Right(Duration(hours: 11, minutes: 33, seconds: 22))));
    });

    test(
        '''should return a Failure when the string is not HHh MMm SSs format''',
        () async {
      const durationText = "11:33:22";
      final result = durationConverter.fromStringHHhMMmSSs(durationText);
      expect(result, Left(InvalidDurationFailure()));
    });

//     test('''
// should return a Failure when the string is a negative integer''', () async {
//       const str = '-123';
//       final result = inputConverter.stringToUnsignedInteger(str);
//       expect(result, Left(InvalidInputFailure()));
//     });
  });
}
