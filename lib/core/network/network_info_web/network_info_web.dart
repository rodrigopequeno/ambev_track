import '../network_info.dart';

class NetworkInfoWebImpl implements NetworkInfo {
  NetworkInfoWebImpl();

  @override
  Future<bool> get isConnected async => Future.value(true);
}
