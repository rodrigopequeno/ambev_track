import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../network_info.dart';

class NetworkInfoNativeImpl implements NetworkInfo {
  final InternetConnectionChecker connectionChecker;

  NetworkInfoNativeImpl(this.connectionChecker);

  @override
  Future<bool> get isConnected => connectionChecker.hasConnection;
}
