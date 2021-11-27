class Collect {
  final DateTime dateTime;
  final Duration duration;
  final double latitude;
  final double longitude;

  Collect({
    required this.duration,
    required this.latitude,
    required this.longitude,
  }) : dateTime = DateTime.now();
}
