import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../core/design_system/colors.dart';
import '../../../../core/spacers/spacers.dart';
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
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    super.initState();
  }

  @override
  void dispose() {
    controller.close();
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
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
            SizedBox(
              width: 153,
              height: 153,
              child: Stack(
                children: [
                  Image.asset(
                    logoPath,
                    color: Colors.white,
                    width: 152,
                    height: 150,
                  ),
                  Image.asset(
                    logoPath,
                    width: 150,
                    height: 150,
                  ),
                ],
              ),
            ),
            const SpacerHeight(15),
            Text(
              "ambev track",
              style: Theme.of(context).textTheme.headline5?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: ColorSystem.primaryYellow,
                    fontSize: 34,
                  ),
            )
          ],
        ),
      ),
    );
  }
}
