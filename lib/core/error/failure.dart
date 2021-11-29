import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final List properties;

  const Failure([this.properties = const <dynamic>[]]);

  @override
  List<Object?> get props => properties;
}

class SaveCollectFailure extends Failure {}

class ServerFailure extends Failure {}

class InvalidGeographicLatitudeFailure extends Failure {}

class InvalidGeographicLongitudeFailure extends Failure {}

class InvalidGeographicCardinalLatitudeFailure extends Failure {}

class InvalidGeographicCardinalLongitudeFailure extends Failure {}

class InvalidGeographicLatitudeDegreesFailure extends Failure {}

class InvalidGeographicLongitudeDegreesFailure extends Failure {}
