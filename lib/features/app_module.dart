import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../core/database/database.dart';
import '../core/database/hive_database.dart';
import '../core/network/network_info.dart';
import '../core/network/network_info_native/network_info_native.dart';
import '../core/network/network_info_web/network_info_web.dart';
import '../core/service/dio_service.dart';
import '../core/service/service.dart';
import 'collect/collect_module.dart';
import 'splash_screen/presentation/cubit/splash_screen_cubit.dart';
import 'splash_screen/presentation/pages/splash_screen_page.dart';

class AppModule extends Module {
  @override
  final List<Bind> binds = [
    AsyncBind<Database>((i) => HiveDatabaseImpl(hive: Hive).initialize()),
    Bind.lazySingleton(
      (i) => InternetConnectionChecker()
        ..addresses = <AddressCheckOptions>[
          AddressCheckOptions(
            InternetAddress(
              '1.1.1.1', // CloudFlare
              type: InternetAddressType.IPv4,
            ),
          ),
          AddressCheckOptions(
            InternetAddress(
              '8.8.4.4', // Google
              type: InternetAddressType.IPv4,
            ),
          ),
          AddressCheckOptions(
            InternetAddress(
              '208.67.222.222', // OpenDNS
              type: InternetAddressType.IPv4,
            ), // OpenDNS
          ),
          // OpenDNS
        ],
    ),
    Bind.lazySingleton<Service>((i) {
      return DioServiceImpl(
        dio: Dio(
          BaseOptions(
            baseUrl: "https://run.mocky.io/v3",
          ),
        ),
      );
    }),
    Bind.lazySingleton<NetworkInfo>((i) {
      if (kIsWeb) {
        return NetworkInfoWebImpl();
      } else {
        return NetworkInfoNativeImpl(i.get());
      }
    }),
    Bind.lazySingleton((i) => SplashScreenCubit()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(
      SplashScreenPage.routerName,
      child: (_, args) => const SplashScreenPage(),
    ),
    ModuleRoute(
      CollectModule.routerName,
      module: CollectModule(),
    ),
  ];
}
