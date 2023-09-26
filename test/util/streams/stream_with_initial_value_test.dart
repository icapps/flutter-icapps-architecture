import 'package:flutter_test/flutter_test.dart';
import 'package:icapps_architecture/icapps_architecture.dart';

void main() {
  group('Stream controller with intitial value tests', () {
    test('Test stream with initial value', () {
      final streamController = StreamControllerWithInitialValue<int>();
      streamController.add(1);
      streamController.listen((value) {
        expect(value, 1);
        expect(streamController.value, 1);
        streamController.close();
      });
    });

    test('Test stream with multiple values', () {
      final streamController = StreamControllerWithInitialValue<int>.broadcast();
      streamController.add(1);
      var subscription = streamController.listen((value) {
        expect(value, 1);
        expect(streamController.value, 1);
      });
      subscription.cancel();

      streamController.add(2);
      streamController.add(3);
      streamController.add(4);

      subscription = streamController.listen((value) {
        expect(value, 4);
        expect(streamController.value, 4);
        streamController.close();
      });
    });

    test('Test can not listen multiple times to non-broadcast stream', () {
      final streamController = StreamControllerWithInitialValue<int>();
      dynamic error;
      try {
        streamController.listen((value) {});
        streamController.listen((value) {});
      } catch (e) {
        error = e;
      }
      expect(error, isNotNull);
      expect(error, isA<StateError>());
      if (error is Exception) {
        expect(error.toString(), 'StateError:<Bad state: Stream has already been listened to.');
      }
      streamController.close();
    });

    test('Test stream without value in constructor', () {
      final streamController = StreamControllerWithInitialValue<int>(value: 1);
      expect(streamController.value, 1);
      streamController.listen((value) {
        expect(value, 1);
        streamController.close();
      });
    });
  });
}
