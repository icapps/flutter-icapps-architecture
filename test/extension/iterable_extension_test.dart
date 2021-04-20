import 'package:flutter_test/flutter_test.dart';
import 'package:icapps_architecture/icapps_architecture.dart';

void main() {
  late List<int> sut;
  late List<double> sut2;

  setUp(() {
    sut = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
    sut2 = [1.1, 2.1, 3.1, 4.1, 5.1, 6.1, 7.1, 8.1, 9.1, 10.1];
  });
  group('Iterable extension tests', () {
    test('Test count', () {
      expect(sut.count((e) => e < 100), 10);
      expect(sut.count((e) => e < 5), 4);
    });
    test('Test sum', () {
      expect(sut.sum((e) => e), 55);
      expect(sut2.sum((e) => e).round(), 56);
    });
    test('Test find', () {
      expect(sut.find((e) => e == 2), 2);
      expect(sut.find((e) => e == 102), null);
    });
    test('Test all', () {
      expect(sut.all((e) => e < 100), true);
      expect(sut.all((e) => e < 5), false);
    });
    test('Test associate by', () {
      expect(sut.associateBy((e) => e.toString()), {
        '1': 1,
        '2': 2,
        '3': 3,
        '4': 4,
        '5': 5,
        '6': 6,
        '7': 7,
        '8': 8,
        '9': 9,
        '10': 10,
      });
    });
    test('Test split', () {
      final result = sut.split((e) => e <= 7);
      expect(result.item1, [1, 2, 3, 4, 5, 6, 7]);
      expect(result.item2, [8, 9, 10]);
    });
    test('Test map indexed', () {
      final seenIndexes = <int>[];
      final seenValues = <int>[];
      sut.mapIndexed((index, e) {
        seenIndexes.add(index);
        seenValues.add(e);
      }).toList(growable: false);
      expect(seenIndexes, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]);
      expect(seenValues, sut);
    });
    test('Test foreach indexed', () {
      final seenIndexes = <int>[];
      final seenValues = <int>[];
      sut.forEachIndexed((index, e) {
        seenIndexes.add(index);
        seenValues.add(e);
      });
      expect(seenIndexes, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]);
      expect(seenValues, sut);
    });
    test('Test flatten', () {
      final Iterable<Iterable<String>> list = [
        ['1', '2'],
        ['3', '4'],
      ];
      expect(list.flatten(), ['1', '2', '3', '4']);
    });
  });
}
