import 'package:equatable/equatable.dart';

class Collect extends Equatable {
  final DateTime dateTime;
  final Duration duration;
  final double latitude;
  final double longitude;

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
