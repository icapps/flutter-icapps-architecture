import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:icapps_architecture/icapps_architecture.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'change_notifier_ex_test.mocks.dart';

class TestableChangeNotifier with ChangeNotifierEx {
  @visibleForTesting
  bool get isDisposed => disposed;

  @visibleForTesting
  bool get testHasListeners => hasListeners;

  @visibleForTesting
  void callListeners() {
    notifyListeners();
  }
}

@GenerateMocks([StreamSubscription, DisposeAware])
void main() {
  group('Change notifier dispose tests', () {
    test('Not disposed flag', () {
      expect(TestableChangeNotifier().isDisposed, false);
    });
    test('Disposed flag', () {
      expect((TestableChangeNotifier()
        ..dispose()).isDisposed, true);
    });
    test('DisposeAware did not run', () {
      final disposeAware = MockDisposeAware();
      expect(
          (TestableChangeNotifier()
            ..registerDispose(disposeAware)).isDisposed,
          false);
      verifyNever(disposeAware.dispose());
    });
    test('DisposeAware did run', () {
      final disposeAware = MockDisposeAware();
      when(disposeAware.dispose()).thenReturn(null);
      final notifier = TestableChangeNotifier()
        ..registerDispose(disposeAware);
      expect(notifier.isDisposed, false);
      verifyNever(disposeAware.dispose());
      notifier.dispose();
      expect(notifier.isDisposed, true);
      verify(disposeAware.dispose()).called(1);
    });
    test('DisposeAware did run immediately', () {
      final disposeAware = MockDisposeAware();
      when(disposeAware.dispose()).thenReturn(null);
      final notifier = TestableChangeNotifier();
      expect(notifier.isDisposed, false);
      notifier.dispose();
      expect(notifier.isDisposed, true);
      notifier.registerDispose(disposeAware);
      verify(disposeAware.dispose()).called(1);
    });
    test('Stream cancel did not run', () {
      final subscription = MockStreamSubscription();
      expect(
          (TestableChangeNotifier()
            ..registerDisposeStream(subscription))
              .isDisposed,
          false);
      verifyNever(subscription.cancel());
    });
    test('Stream cancel did run', () {
      final subscription = MockStreamSubscription();
      final notifier = TestableChangeNotifier()
        ..registerDisposeStream(subscription);
      expect(notifier.isDisposed, false);
      verifyNever(subscription.cancel());
      notifier.dispose();
      expect(notifier.isDisposed, true);
      verify(subscription.cancel()).called(1);
    });
    test('Stream cancel did run immediately', () {
      final subscription = MockStreamSubscription();
      final notifier = TestableChangeNotifier();
      expect(notifier.isDisposed, false);
      notifier.dispose();
      expect(notifier.isDisposed, true);
      notifier.registerDisposeStream(subscription);
      verify(subscription.cancel()).called(1);
    });
    test('Double dispose throws', () {
      expect(() =>
      TestableChangeNotifier()
        ..dispose()..dispose(),
          throwsA(isInstanceOf<FlutterError>()));
    });
  });
  group('Change notifier listeners', () {
    test('Initially no listeners', () {
      expect(TestableChangeNotifier().testHasListeners, false);
    });
    test('Set any listener', () {
      expect((TestableChangeNotifier()
        ..addListener(() {})).testHasListeners, true);
    });
    test('Remove listener', () {
      final listener = () {};
      expect((TestableChangeNotifier()
        ..addListener(listener)
        ..removeListener(listener)).testHasListeners, false);
    });
    test('Add listener after dispose not allowed', () {
        expect(() =>
        TestableChangeNotifier()
          ..dispose()..addListener(() {}),
            throwsA(isInstanceOf<FlutterError>()));
    });
    test('Listener called', () {
      var counter = 0;
      TestableChangeNotifier()
        ..addListener(() { ++counter; })..callListeners();
      expect(counter, 1);
    });
    test('Removed listener not called', () {
      var counter = 0;
      final listener = () { ++counter; };
      TestableChangeNotifier()
        ..addListener(listener)..removeListener(listener)..callListeners();
      expect(counter, 0);
    });
  });

}
