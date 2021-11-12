import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:icapps_architecture/icapps_architecture.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Restorable viewmodel tests', () {
    test('Test viewmodel instance', () {
      var counter = 0;
      var restoreCalledAt = -1;
      var saveCalledAt = -1;
      var initCalledAt = -1;
      var whenCreatedCalledAt = -1;
      final viewModelHolder = RestorableViewModelHolder<_TestViewModel>(
        create: () => _TestViewModel(
          restoreCalled: () => restoreCalledAt = ++counter,
          saveCalled: () => saveCalledAt = ++counter,
        ),
        init: (vm) => initCalledAt = ++counter,
        whenCreated: (vm) => whenCreatedCalledAt = ++counter,
      );

      viewModelHolder.initWithValue(viewModelHolder.createDefaultValue());
      expect(viewModelHolder.viewModel.restoredValue, null);
      expect(whenCreatedCalledAt, 1);
      expect(restoreCalledAt, 2);
      expect(initCalledAt, 3);
      expect(saveCalledAt, -1);
    });

    test('Test viewmodel from primitives', () {
      var counter = 0;
      var restoreCalledAt = -1;
      var saveCalledAt = -1;
      var initCalledAt = -1;
      var whenCreatedCalledAt = -1;
      final viewModelHolder = RestorableViewModelHolder<_TestViewModel>(
        create: () => _TestViewModel(
          restoreCalled: () => restoreCalledAt = ++counter,
          saveCalled: () => saveCalledAt = ++counter,
        ),
        init: (vm) => initCalledAt = ++counter,
        whenCreated: (vm) => whenCreatedCalledAt = ++counter,
      );

      viewModelHolder.initWithValue(
          viewModelHolder.fromPrimitives(<Object?, Object?>{'test': 2}));
      expect(viewModelHolder.viewModel.restoredValue, 2);
      expect(whenCreatedCalledAt, 1);
      expect(restoreCalledAt, 2);
      expect(initCalledAt, 3);
      expect(saveCalledAt, -1);
    });

    test('Test viewmodel to primitives', () {
      var counter = 0;
      var restoreCalledAt = -1;
      var saveCalledAt = -1;
      var initCalledAt = -1;
      var whenCreatedCalledAt = -1;
      final viewModelHolder = RestorableViewModelHolder<_TestViewModel>(
        create: () => _TestViewModel(
          restoreCalled: () => restoreCalledAt = ++counter,
          saveCalled: () => saveCalledAt = ++counter,
        ),
        init: (vm) => initCalledAt = ++counter,
        whenCreated: (vm) => whenCreatedCalledAt = ++counter,
      );

      viewModelHolder.initWithValue(viewModelHolder.createDefaultValue());
      expect(viewModelHolder.viewModel.restoredValue, null);
      expect(whenCreatedCalledAt, 1);
      expect(restoreCalledAt, 2);
      expect(initCalledAt, 3);

      expect(viewModelHolder.toPrimitives(), <Object?, Object?>{'test': 2});

      expect(saveCalledAt, 4);
    });

    test('Test dispose', () {
      final viewModelHolder = RestorableViewModelHolder<_TestViewModel>(
        create: () => _TestViewModel(
          restoreCalled: () {},
          saveCalled: () {},
        ),
        init: (vm) {},
        whenCreated: (vm) {},
      );
      viewModelHolder.initWithValue(viewModelHolder.createDefaultValue());
      expect(viewModelHolder.viewModel.restoredValue, null);

      viewModelHolder.dispose();
    });

    test('Test default no ops', () {
      final viewModelHolder = RestorableViewModelHolder<_TestViewModel>(
        create: () => _TestViewModel(
          restoreCalled: () {},
          saveCalled: () {},
        ),
      );
      viewModelHolder.initWithValue(viewModelHolder.createDefaultValue());

      expect(viewModelHolder.viewModel.restoredValue, null);
    });

    test('Test lifecycle change triggers save', () {
      var notifyCalled = false;
      final viewModelHolder = RestorableViewModelHolder<_TestViewModel>(
        create: () => _TestViewModel(
          restoreCalled: () {},
          saveCalled: () {},
        ),
      );
      viewModelHolder.addListener(() {
        notifyCalled = true;
      });
      expect(notifyCalled, false);
      viewModelHolder.initWithValue(viewModelHolder.createDefaultValue());
      expect(notifyCalled, true);
      notifyCalled = false;
      expect(notifyCalled, false);

      viewModelHolder.didChangeAppLifecycleState(AppLifecycleState.resumed);
      expect(notifyCalled, false);
      viewModelHolder.didChangeAppLifecycleState(AppLifecycleState.inactive);

      expect(notifyCalled, true);
    });
  });
}

class _TestViewModel with ChangeNotifierEx implements Restorable {
  final VoidCallback restoreCalled;
  final VoidCallback saveCalled;

  int? restoredValue;

  _TestViewModel({required this.restoreCalled, required this.saveCalled});

  @override
  void restoreState(Bundle? data) {
    restoreCalled();
    restoredValue = data?.getInt('test');
  }

  @override
  void saveState(Bundle target) {
    target.putInt('test', 2);
    saveCalled();
  }
}
