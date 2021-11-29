import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/cardinal_point.dart';
import '../entities/geographic_coordinate.dart';

const _regexCoordinateExpression =
    r"""(\d+)\s?\°\s?(\d+)\s?\'\s?(\d{1,}\.?\,?\d{0,}?)\"\s?(N|W|S|E)""";
const _regexCoordinateDegreesExpression = r"""(\d+)\°""";
const _regexCoordinateMinutesExpression = r"""(\d+)\'""";
const _regexCoordinateSecondsExpression = r'''(\d{1,}\.?\,?\d{0,}?)\"''';
const _regexCoordinateCardinalExpression = r"""(N|S|E|W)\'""";

class ValidateGeographicCoordinate
    implements
        UseCase<Tuple2<GeographicCoordinate, GeographicCoordinate>,
            ValidateGeographicCoordinateParams> {
  ValidateGeographicCoordinate();

  @override
  Future<Either<Failure, Tuple2<GeographicCoordinate, GeographicCoordinate>>>
      call(ValidateGeographicCoordinateParams params) async {
    final coordinateRegExp = RegExp(_regexCoordinateExpression);
    if (!coordinateRegExp.hasMatch(params.latitudeText) ||
        !coordinateRegExp.hasMatch(params.longitudeText)) {
      if (!coordinateRegExp.hasMatch(params.latitudeText)) {
        return Left(InvalidGeographicLatitudeFailure());
      } else {
        return Left(InvalidGeographicLongitudeFailure());
      }
    }

    GeographicCoordinate geographicCoordinateLatitude;
    GeographicCoordinate geographicCoordinateLongitude;
    try {
      geographicCoordinateLatitude = fromText(
        coordinateText: params.latitudeText,
        cardinalPointDefault: CardinalPoint.north,
      );
    } catch (e) {
      return Left(InvalidGeographicLatitudeDegreeusFailure());
    }
    try {
      geographicCoordinateLongitude = fromText(
        coordinateText: params.longitudeText,
        cardinalPointDefault: CardinalPoint.east,
      );
    } catch (e) {
      return Left(InvalidGeographicLongitudeDegreeusFailure());
    }

    return Right(
      Tuple2<GeographicCoordinate, GeographicCoordinate>(
        geographicCoordinateLatitude,
        geographicCoordinateLongitude,
      ),
    );
  }

  GeographicCoordinate fromText({
    required String coordinateText,
    required CardinalPoint cardinalPointDefault,
  }) {
    final degreesRegExp = RegExp(_regexCoordinateDegreesExpression);
    final minutesRegExp = RegExp(_regexCoordinateMinutesExpression);
    final secondsRegExp = RegExp(_regexCoordinateSecondsExpression);
    final cardinalRegExp = RegExp(_regexCoordinateCardinalExpression);
    final degrees = double.tryParse(
        degreesRegExp.stringMatch(coordinateText)?.replaceAll("°", "") ?? "0");
    final minutes = double.tryParse(
        minutesRegExp.stringMatch(coordinateText)?.replaceAll("'", "") ?? "0");
    final seconds = double.tryParse(secondsRegExp
            .stringMatch(coordinateText)
            ?.replaceAll('"', "")
            .replaceAll(",", ".") ??
        "0");
    final cardinalPoint = CardinalPointExtension.fromSymbol(
        cardinalRegExp.stringMatch(coordinateText) ??
            cardinalPointDefault.symbol);

    return GeographicCoordinate(
      degrees: degrees ?? 0,
      minutes: minutes ?? 0,
      seconds: seconds ?? 0,
      cardinalPoint: cardinalPoint,
    );
  }
}

class ValidateGeographicCoordinateParams extends Equatable {
  final String _latitudeText;
  final String _longitudeText;

  const ValidateGeographicCoordinateParams({
    required String latitudeText,
    required String longitudeText,
  })  : _latitudeText = latitudeText,
        _longitudeText = longitudeText;

  String get latitudeText => _latitudeText.replaceAll(" ", "");
  String get longitudeText => _longitudeText.replaceAll(" ", "");

  @override
  List<Object?> get props => [];
}
