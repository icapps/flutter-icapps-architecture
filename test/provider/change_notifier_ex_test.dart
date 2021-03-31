import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:icapps_architecture/icapps_architecture.dart';

class TestableChangeNotifier with ChangeNotifierEx {
  @visibleForTesting
  bool get isDisposed => disposed;
}

void main() {
  group('Change notifier dispose tests', () {
    test('Not disposed flag', () {
      expect(TestableChangeNotifier().isDisposed, false);
    });
    test('Disposed flag', () {
      expect((TestableChangeNotifier()..dispose()).isDisposed, true);
    });
  });
}
