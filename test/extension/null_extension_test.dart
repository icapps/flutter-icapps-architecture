import 'package:flutter_test/flutter_test.dart';
import 'package:icapps_architecture/icapps_architecture.dart';

void main() {
  group('Null extension tests', () {
    test('Test let null', () {
      int? value;
      expect(value.let((i) => i * 2) ?? -129, -129);
      expect(value?.let((i) => i * 2) ?? -129, -129);
    });
    test('Test let value', () {
      int? value = 2;
      expect(value.let((i) => i * 2) ?? -129, 4);
    });
  });
}
