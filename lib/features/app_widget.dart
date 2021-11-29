import 'package:asuka/asuka.dart' as asuka;
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../core/design_system/theme.dart';
import 'splash_screen/presentation/pages/splash_screen_page.dart';

const appName = 'ambev track';

class AppWidget extends StatelessWidget {
  const AppWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      initialRoute: SplashScreenPage.routerName,
      theme: ThemeSystem.get,
      builder: asuka.builder,
    ).modular();
  }
}
