import 'package:flutter_test/flutter_test.dart';
import 'package:icapps_architecture/icapps_architecture.dart';

void main() {
  group('Map extension tests', () {
    test('Test remove null keys', () {
      final sut = <String?, int>{null: 39, '1': 2};
      expect(sut.removeNullKeys(), {'1': 2});
    });
    test('Test remove null values', () {
      final sut = <String, int?>{'null': 39, '1': null, '2': 1, '3': null};
      expect(sut.removeNullValues(), {'null': 39, '2': 1});
    });
  });
}
