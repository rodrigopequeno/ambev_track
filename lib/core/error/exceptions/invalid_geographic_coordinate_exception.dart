import '../../../features/collect/domain/entities/cardinal_point.dart';

class InvalidGeographicCoordinateException implements Exception {
  final double degrees;
  final CardinalPoint cardinalPoint;

  InvalidGeographicCoordinateException({
    required this.degrees,
    required this.cardinalPoint,
  });

  @override
  String toString() {
    switch (cardinalPoint) {
      case CardinalPoint.south:
      case CardinalPoint.north:
        return "InvalidGeographicCoordinate for cardinal point $cardinalPoint. Degree must range between 0 and 90 and current value is $degrees";
      case CardinalPoint.west:
      case CardinalPoint.east:
        return "InvalidGeographicCoordinate for cardinal point $cardinalPoint. Degree must range between 0 and 180 and current value is $degrees";
    }
  }
}
