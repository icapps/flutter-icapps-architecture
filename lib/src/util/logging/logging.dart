import 'package:flutter/cupertino.dart';
import 'package:icapps_architecture/icapps_architecture.dart';
import 'package:logger/logger.dart';

import 'impl/LoggerPrinter.dart';

abstract class Log {
  void verbose(String message);

  void debug(String message);

  void info(String message);

  void warning(String message);

  void error(String message, {dynamic? error, StackTrace? trace});

  void v(String message) => verbose(message);

  void d(String message) => debug(message);

  void i(String message) => info(message);

  void w(String message) => warning(message);

  void e(String message, {dynamic? error, StackTrace? trace}) =>
      this.error(message, error: error, trace: trace);
}

Log get logger => LoggingFactory.provide();

class LoggingFactory {
  static Log? _instance;

  static Log provide() {
    return _instance ?? reset();
  }

  static Log reset({bool enabled = isInDebug}) {
    return resetWithLogger(
        enabled ? LoggerLogImpl(_makeLogger()) : VoidLogger());
  }

  static Log resetWithLogger(Log logger) {
    return _instance = logger;
  }

  static Logger _makeLogger() {
    return Logger(printer: _makeLogPrinter());
  }

  static LogPrinter _makeLogPrinter() {
    return OurPrettyPrinter(
        methodCount: 0,
        errorMethodCount: 5,
        lineLength: 50,
        colors: true,
        printEmojis: true,
        printTime: true);
  }
}

@visibleForTesting
class LoggerLogImpl extends Log {
  final Logger logger;

  LoggerLogImpl(this.logger);

  @override
  void debug(String message) => logger.d(message);

  @override
  void error(String message, {error, StackTrace? trace}) =>
      logger.e(message, error, trace);

  @override
  void info(String message) => logger.i(message);

  @override
  void verbose(String message) => logger.v(message);

  @override
  void warning(String message) => logger.w(message);
}

@visibleForTesting
class VoidLogger implements Log {
  @override
  void d(String message) {}

  @override
  void debug(String message) {}

  @override
  void e(String message, {error, StackTrace? trace}) {}

  @override
  void error(String message, {error, StackTrace? trace}) {}

  @override
  void i(String message) {}

  @override
  void info(String message) {}

  @override
  void v(String message) {}

  @override
  void verbose(String message) {}

  @override
  void w(String message) {}

  @override
  void warning(String message) {}
}
