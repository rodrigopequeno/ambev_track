import 'package:asuka/asuka.dart' as asuka;
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'splash_screen/presentation/pages/splash_screen_page.dart';

const appName = 'Ambev Track';

class AppWidget extends StatelessWidget {
  const AppWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: appName,
      initialRoute: SplashScreenPage.routerName,
      builder: asuka.builder,
    ).modular();
  }
}
