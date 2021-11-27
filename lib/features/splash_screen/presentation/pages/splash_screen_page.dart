import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../cubit/splash_screen_cubit.dart';

const logoPath = 'assets/images/logo.png';

class SplashScreenPage extends StatefulWidget {
  static const routerName = "/splash-screen";
  const SplashScreenPage({Key? key}) : super(key: key);

  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState
    extends ModularState<SplashScreenPage, SplashScreenCubit> {
  @override
  void initState() {
    controller.initialize();
    super.initState();
  }

  @override
  void dispose() {
    controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SplashScreenCubit>(
      create: (context) => controller,
      child: BlocConsumer<SplashScreenCubit, SplashScreenState>(
        listener: (context, state) => controller.listenerState(state),
        builder: (context, state) => _buildLogo(),
      ),
    );
  }

  Widget _buildLogo() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              logoPath,
              width: 150,
              height: 150,
            ),
            const Text(
              "Ambev Track",
              style: TextStyle(fontSize: 28),
            )
          ],
        ),
      ),
    );
  }
}
