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

    test('Test stream with multiple value', () async {
      final streamController = StreamControllerWithInitialValue<int>();
      var testValue = 1;
      streamController.add(testValue);
      streamController.listen((value) {
        expect(value, testValue);
      });
      // waiting to execute the listen before continuing
      await Future.value();
      testValue = 2;
      streamController.add(testValue);
      await Future.value();
      expect(streamController.value, testValue);
      testValue = 3;
      streamController.add(testValue);
      await Future.value();
      expect(streamController.value, testValue);
      streamController.close();
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

    test('Test stream with value in constructor', () {
      final streamController = StreamControllerWithInitialValue<int>(value: 1);
      expect(streamController.value, 1);
      streamController.listen((value) {
        expect(value, 1);
        streamController.close();
      });
    });
  });
}
