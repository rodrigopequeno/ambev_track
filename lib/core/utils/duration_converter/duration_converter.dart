import 'package:dartz/dartz.dart';

import '../../error/failure.dart';

const _regexDurationExpression = r"""(\d+)h\s?(\d{2})m\s?(\d{2})s""";
const _regexHoursExpression = r"""(\d+)h""";
const _regexMinutesExpression = r"""(\d+)m""";
const _regexSecondsExpression = r'''(\d{1,}\.?\,?\d{0,}?)s''';

class DurationConverter {
  String toStringFormattedHHhMMmSSs(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}h ${twoDigitMinutes}m ${twoDigitSeconds}s";
  }

  Either<Failure, Duration> fromStringHHhMMmSSs(String durationText) {
    final durationRegExp = RegExp(_regexDurationExpression);
    final durationTextFormatted = durationText.replaceAll(" ", "");
    if (!durationRegExp.hasMatch(durationText)) {
      return Left(InvalidDurationFailure());
    }
    final hoursRegExp = RegExp(_regexHoursExpression);
    final minutesRegExp = RegExp(_regexMinutesExpression);
    final secondsRegExp = RegExp(_regexSecondsExpression);

    final hours = int.parse(
        hoursRegExp.stringMatch(durationTextFormatted)?.replaceAll("h", "") ??
            "0");
    final minutes = int.parse(
        minutesRegExp.stringMatch(durationTextFormatted)?.replaceAll("m", "") ??
            "0");
    final seconds = int.parse(
        secondsRegExp.stringMatch(durationTextFormatted)?.replaceAll("s", "") ??
            "0");
    return Right(
      Duration(
        hours: hours,
        minutes: minutes,
        seconds: seconds,
      ),
    );
  }
}

class InvalidDurationFailure extends Failure {}
