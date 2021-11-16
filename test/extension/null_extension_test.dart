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
  group('Null String extension tests', () {
    test('Test isNullOrEmpty null', () {
      String? value;
      expect(value.isNullOrEmpty, true);
      expect(value.isNotNullOrEmpty, false);
    });
    test('Test isNullOrEmpty empty', () {
      String? value = '';
      expect(value.isNullOrEmpty, true);
      expect(value.isNotNullOrEmpty, false);
    });
    test('Test isNullOrEmpty not empty & not null', () {
      String? value = 'Hello World';
      expect(value.isNullOrEmpty, false);
      expect(value.isNotNullOrEmpty, true);
    });
  });
}
