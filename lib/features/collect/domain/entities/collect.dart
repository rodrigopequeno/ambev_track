import 'package:equatable/equatable.dart';

import 'geographic_coordinate.dart';

class Collect extends Equatable {
  final DateTime dateTime;
  final Duration duration;
  final GeographicCoordinate latitude;
  final GeographicCoordinate longitude;

  const Collect({
    required this.dateTime,
    required this.duration,
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object?> get props => [
        dateTime,
        duration,
        latitude,
        longitude,
      ];
}
