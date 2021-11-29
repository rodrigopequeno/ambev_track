import 'package:equatable/equatable.dart';

import '../../../../core/error/exceptions/invalid_geographic_coordinate_exception.dart';
import 'cardinal_point.dart';

class GeographicCoordinate extends Equatable {
  final double degrees;
  final double minutes;
  final double seconds;
  final CardinalPoint cardinalPoint;

  GeographicCoordinate({
    required this.degrees,
    required this.cardinalPoint,
    this.minutes = 0,
    this.seconds = 0,
  }) {
    if (degrees.isNegative || !_isValid()) {
      throw InvalidGeographicCoordinateException(
        degrees: degrees,
        cardinalPoint: cardinalPoint,
      );
    }
  }

  double toDecimal() {
    final decimal = (degrees + (minutes / 60) + (seconds / 3600));
    if (cardinalPoint == CardinalPoint.south ||
        cardinalPoint == CardinalPoint.west) {
      return decimal * -1;
    }
    return decimal;
  }

  bool _isValid() {
    final decimal = toDecimal().abs();
    switch (cardinalPoint) {
      case CardinalPoint.south:
      case CardinalPoint.north:
        if (0 <= decimal && decimal <= 90) {
          return true;
        }
        return false;
      case CardinalPoint.west:
      case CardinalPoint.east:
        if (0 <= decimal && decimal <= 180) {
          return true;
        }
        return false;
    }
  }

  @override
  List<Object?> get props => [
        degrees.toStringAsPrecision(5),
        minutes.toStringAsPrecision(5),
        seconds.toStringAsPrecision(5),
        cardinalPoint,
      ];
}
