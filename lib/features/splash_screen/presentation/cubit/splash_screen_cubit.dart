import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_modular/flutter_modular.dart';

part 'splash_screen_state.dart';

const splashScreenTimeInMilliseconds = 4000;

class SplashScreenCubit extends Cubit<SplashScreenState> {
  SplashScreenCubit() : super(SplashScreenInitial());

  Future<void> initialize() async {
    Future.delayed(const Duration(milliseconds: 4000)).then((_) {
      emit(SplashScreenSuccess());
    });
  }

  void listenerState(SplashScreenState state) {
    if (state is SplashScreenSuccess) {
      Modular.to.navigate('/');
    }
  }
}
