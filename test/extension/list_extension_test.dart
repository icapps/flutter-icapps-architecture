import 'package:flutter_test/flutter_test.dart';
import 'package:icapps_architecture/icapps_architecture.dart';
import 'package:tuple/tuple.dart';

void main() {
  late List<int> sut;

  setUp(() {
    sut = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  });
  group('List extension tests', () {
    test('Test replace all', () {
      expect(sut, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);
      expect(sut..replaceAll([11, 12, 13]), [11, 12, 13]);
    });
    test('Test replaceFirstWhere', () {
      expect(sut, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);
      expect(sut..replaceFirstWhere((item) => item == 2, 100),
          [1, 100, 3, 4, 5, 6, 7, 8, 9, 10]);
    });
    test('Test sort by', () {
      sut.sortBy((e) => 10 - e);
      expect(sut, [10, 9, 8, 7, 6, 5, 4, 3, 2, 1]);
    });
    test('Test sort by null', () {
      sut.sortBy((e) => e % 2 == 0 ? null : e);
      expect(sut, [2, 4, 6, 8, 10, 1, 3, 5, 7, 9]);
    });
    test('Test sort by descending', () {
      sut.sortBy((e) => e, ascending: false);
      expect(sut, [10, 9, 8, 7, 6, 5, 4, 3, 2, 1]);
    });
    test('Test sort by null descending', () {
      sut.sortBy((e) => e % 2 == 0 ? null : e, ascending: false);
      expect(sut, [9, 7, 5, 3, 1, 10, 8, 6, 4, 2]);
    });
    test('Test sort by2', () {
      final complexSut = <Tuple2<String, int>>[
        Tuple2("ABC", 2),
        Tuple2("ABC", 1),
        Tuple2("BCD", 25),
        Tuple2("ABCDE", 25),
      ];

      complexSut.sortBy2((e) => e.item1, (e) => e.item2);
      expect(complexSut, <Tuple2<String, int>>[
        Tuple2("ABC", 1),
        Tuple2("ABC", 2),
        Tuple2("ABCDE", 25),
        Tuple2("BCD", 25),
      ]);
    });
    test('Test sort by2, descending', () {
      final complexSut = <Tuple2<String, int>>[
        Tuple2("ABC", 2),
        Tuple2("ABC", 1),
        Tuple2("BCD", 25),
        Tuple2("ABCDE", 25),
      ];

      complexSut.sortBy2((e) => e.item1, (e) => e.item2, ascending: false);
      expect(complexSut, <Tuple2<String, int>>[
        Tuple2("BCD", 25),
        Tuple2("ABCDE", 25),
        Tuple2("ABC", 2),
        Tuple2("ABC", 1),
      ]);
    });
    test('Test sort by2 nullable', () {
      final complexSut = <Tuple2<String?, int?>>[
        Tuple2("ABC", 2),
        Tuple2("ABC", 1),
        Tuple2("BCD", 25),
        Tuple2(null, null),
        Tuple2("ABCDE", 25),
        Tuple2(null, 25),
        Tuple2(null, 24),
        Tuple2("ABC", null),
      ];

      complexSut.sortBy2((e) => e.item1, (e) => e.item2);
      expect(complexSut, <Tuple2<String?, int?>>[
        Tuple2(null, null),
        Tuple2(null, 24),
        Tuple2(null, 25),
        Tuple2("ABC", null),
        Tuple2("ABC", 1),
        Tuple2("ABC", 2),
        Tuple2("ABCDE", 25),
        Tuple2("BCD", 25),
      ]);
    });
    test('Test sort by2 nullable descending', () {
      final complexSut = <Tuple2<String?, int?>>[
        Tuple2("ABC", 2),
        Tuple2("ABC", 1),
        Tuple2(null, null),
        Tuple2("BCD", 25),
        Tuple2("ABCDE", 25),
        Tuple2(null, 25),
        Tuple2(null, 24),
        Tuple2("ABC", null),
      ];

      complexSut.sortBy2((e) => e.item1, (e) => e.item2, ascending: false);
      expect(complexSut, <Tuple2<String?, int?>>[
        Tuple2("BCD", 25),
        Tuple2("ABCDE", 25),
        Tuple2("ABC", 2),
        Tuple2("ABC", 1),
        Tuple2("ABC", null),
        Tuple2(null, 25),
        Tuple2(null, 24),
        Tuple2(null, null),
      ]);
    });
  });
}
