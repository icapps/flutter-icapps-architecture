import 'package:icapps_architecture/icapps_architecture.dart';
import 'package:logger/logger.dart';

class LoggerViewModel with ChangeNotifierEx {
  var _current = 0;
  var _logLine = '';

  int get current => _current;

  String get logLine => _logLine;

  void init() {
    LoggingFactory.configure(
      LoggingConfiguration(
        isEnabled: true,
        shouldLogNetworkInfo: true,
        loggingLevel: Level.verbose,
        onLog: _onLog,
      ),
    );
  }

  void _onLog(String logLine) {
    _logLine = logLine;
    notifyListeners();
  }

  void onIncrementTapped() {
    ++_current;
    logger.d('On increment tapped. Current value: $_current');
    notifyListeners();
  }
}
