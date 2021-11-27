import 'package:ambev_track/features/splash_screen/presentation/cubit/splash_screen_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class ModularNavigatorMock extends Mock implements IModularNavigator {}

void main() {
  late SplashScreenCubit cubit;
  late ModularNavigatorMock navigatorMock;

  setUp(() {
    navigatorMock = ModularNavigatorMock();
    Modular.navigatorDelegate = navigatorMock;
    cubit = SplashScreenCubit();
  });

  tearDown(() {
    cubit.close();
  });

  test('initialState should be SplashScreenInitial', () async {
    expect(cubit.state, isA<SplashScreenInitial>());
  });

  group('initialize', () {
    blocTest<SplashScreenCubit, SplashScreenState>(
      'should emit [SplashScreenSuccess] after 4 seconds',
      build: () {
        return cubit;
      },
      act: (cubit) async {
        await cubit.initialize();
        await Future.delayed(
            const Duration(milliseconds: splashScreenTimeInMilliseconds));
      },
      expect: () => [SplashScreenSuccess()],
    );
  });

  group('listenerState', () {
    blocTest<SplashScreenCubit, SplashScreenState>(
      'should navigate when issuing SplashScreenSuccess',
      build: () {
        when(() => navigatorMock.navigate(any())).thenAnswer((_) async => {});
        return cubit;
      },
      act: (cubit) async {
        cubit.listenerState(SplashScreenSuccess());
        await untilCalled(() => Modular.to.navigate(any()));
      },
      verify: (cubit) async {
        return verify(() => navigatorMock.navigate(any())).called(1);
      },
    );
  });
}
