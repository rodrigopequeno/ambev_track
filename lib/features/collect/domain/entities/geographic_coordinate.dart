import 'package:equatable/equatable.dart';

import 'cardinal_point.dart';

class GeographicCoordinate extends Equatable {
  final double degrees;
  final double minutes;
  final double seconds;
  final CardinalPoint cardinalPoint;

  const GeographicCoordinate({
    required this.degrees,
    required this.cardinalPoint,
    this.minutes = 0,
    this.seconds = 0,
  });

  @override
  List<Object?> get props => [
        degrees.toStringAsPrecision(5),
        minutes.toStringAsPrecision(5),
        seconds.toStringAsPrecision(5),
        cardinalPoint,
      ];
}
