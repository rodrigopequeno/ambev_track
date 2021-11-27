import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'splash_screen/presentation/cubit/splash_screen_cubit.dart';
import 'splash_screen/presentation/pages/splash_screen_page.dart';

class AppModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => SplashScreenCubit()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(
      SplashScreenPage.routerName,
      child: (_, args) => const SplashScreenPage(),
    ),
    ChildRoute(
      '/',
      child: (_, args) => const SizedBox(),
    ),
  ];
}
