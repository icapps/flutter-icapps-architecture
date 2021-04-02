import 'package:flutter_test/flutter_test.dart';
import 'package:icapps_architecture/icapps_architecture.dart';
import 'package:tuple/tuple.dart';

void main() {
  group('Future helper tests', () {
    test('Test wait2', () async {
      expect(await await2(Future.value(1), Future.value(2)), Tuple2(1, 2));
    });
    test('Test wait3', () async {
      expect(await await3(Future.value(1), Future.value(2), Future.value(3)),
          Tuple3(1, 2, 3));
    });
    test('Test wait4', () async {
      expect(
          await await4(Future.value(1), Future.value(2), Future.value(3),
              Future.value(4)),
          Tuple4(1, 2, 3, 4));
    });
    test('Test wait5', () async {
      expect(
          await await5(Future.value(1), Future.value(2), Future.value(3),
              Future.value(4), Future.value(5)),
          Tuple5(1, 2, 3, 4, 5));
    });
    test('Test wait6', () async {
      expect(
          await await6(Future.value(1), Future.value(2), Future.value(3),
              Future.value(4), Future.value(5), Future.value(6)),
          Tuple6(1, 2, 3, 4, 5, 6));
    });
    test('Test wait7', () async {
      expect(
          await await7(
              Future.value(1),
              Future.value(2),
              Future.value(3),
              Future.value(4),
              Future.value(5),
              Future.value(6),
              Future.value(7)),
          Tuple7(1, 2, 3, 4, 5, 6, 7));
    });
  });
}
