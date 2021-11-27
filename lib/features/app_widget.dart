import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

const appName = 'Ambev Track';

class AppWidget extends StatelessWidget {
  const AppWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: appName,
    ).modular();
  }
}
