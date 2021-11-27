import 'package:equatable/equatable.dart';

import '../../data/models/geographic_coordinate_model.dart';

class Collect extends Equatable {
  final DateTime dateTime;
  final Duration duration;
  final GeographicCoordinateModel latitude;
  final GeographicCoordinateModel longitude;

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
