import 'package:ambev_track/core/network/network_info.dart';
import 'package:ambev_track/core/network/network_info_web/network_info_web.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mocktail/mocktail.dart';

class MockInternetConnectionChecker extends Mock
    implements InternetConnectionChecker {}

void main() {
  late NetworkInfo networkInfoImpl;

  setUp(() {
    networkInfoImpl = NetworkInfoWebImpl();
  });

  group('isConnected', () {
    test(
      'should forward the call to true',
      () async {
        final result = networkInfoImpl.isConnected;
        expect(result, completion(equals(true)));
      },
    );
  });
}
