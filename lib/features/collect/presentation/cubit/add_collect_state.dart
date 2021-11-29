part of 'add_collect_cubit.dart';

abstract class AddCollectState extends Equatable {
  final List properties;

  const AddCollectState([this.properties = const <dynamic>[]]);

  @override
  List<Object> get props => [properties];
}

class AddCollectInitial extends AddCollectState {}

class AddCollectLoading extends AddCollectState {}

class AddCollectSuccess extends AddCollectState {}

class AddCollectError extends AddCollectState {
  final String message;

  AddCollectError(this.message) : super([message]);
}

class AddCollectErrorDurationField extends AddCollectError {
  AddCollectErrorDurationField(String message) : super(message);
}

class AddCollectErrorCoordinateLatitudeField extends AddCollectError {
  AddCollectErrorCoordinateLatitudeField(String message) : super(message);
}

class AddCollectErrorCoordinateLongitudeField extends AddCollectError {
  AddCollectErrorCoordinateLongitudeField(String message) : super(message);
}
