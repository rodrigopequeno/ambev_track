import 'package:ambev_track/core/usecases/usecase.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("should return to an instance of NoParams", () {
    const tNoParams = NoParams();
    expect(tNoParams, isA<NoParams>());
  });
}
