import 'package:flutter_test/flutter_test.dart';
import 'package:icapps_architecture/icapps_architecture.dart';

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
    test('Test sort by', () {
      sut.sortBy((e) => 10 - e);
      expect(sut, [10, 9, 8, 7, 6, 5, 4, 3, 2, 1]);
    });
    test('Test sort by null', () {
      sut.sortBy((e) => e % 2 == 0 ? null : e);
      expect(sut, [2, 4, 6, 8, 10, 1, 3, 5, 7, 9]);
    });
    test('Test sort by2', () {
      sut.sortBy2((e) => e.toString(), (e) => 10 - e);
      expect(sut, [1, 10, 2, 3, 4, 5, 6, 7, 8, 9]);
    });
    test('Test sort by2 nullable', () {
      sut.sortBy2((e) => e % 2 == 0 ? null : e.toString(),
          (e) => e % 2 == 0 ? null : 10 - e);
      expect(sut, [2, 4, 6, 8, 10, 1, 3, 5, 7, 9]);
    });
  });
}
