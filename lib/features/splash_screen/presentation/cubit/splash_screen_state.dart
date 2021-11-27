part of 'splash_screen_cubit.dart';

abstract class SplashScreenState extends Equatable {
  final List properties;

  const SplashScreenState([this.properties = const <dynamic>[]]);

  @override
  List<Object> get props => [properties];
}

class SplashScreenInitial extends SplashScreenState {}

class SplashScreenSuccess extends SplashScreenState {}
