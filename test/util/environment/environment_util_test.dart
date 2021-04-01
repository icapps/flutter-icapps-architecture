import 'package:flutter_test/flutter_test.dart';
import 'package:icapps_architecture/icapps_architecture.dart';
import 'package:icapps_architecture/src/util/environment/impl/environment_util_stub.dart'
    as stub;

void main() {
  group('Environment util tests', () {
    test('IO Test during tests', () {
      expect(isInTest, true);
    });
    test('Web never in test', () {
      expect(stub.runInTest, false);
    });
  });
}
