import 'package:icapps_architecture/icapps_architecture.dart';

class CounterViewModel with ChangeNotifierEx {
  var _current = 0;

  int get current => _current;

  void onIncrementTapped() {
    ++_current;
    logger.d('On increment tapped. Current value: $_current');
    notifyListeners();
  }
}
