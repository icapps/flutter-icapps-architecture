import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:icapps_architecture/icapps_architecture.dart';
import 'package:logger/logger.dart';

import 'impl/LoggerPrinter.dart';

abstract class Log {
  void verbose(String message, {dynamic error, StackTrace? trace});

  void debug(String message, {dynamic error, StackTrace? trace});

  void info(String message, {dynamic error, StackTrace? trace});

  void warning(String message, {dynamic error, StackTrace? trace});

  void error(String message, {dynamic error, StackTrace? trace});

  void v(String message, {dynamic error, StackTrace? trace}) =>
      verbose(message, error: error, trace: trace);

  void d(String message, {dynamic error, StackTrace? trace}) =>
      debug(message, error: error, trace: trace);

  void i(String message, {dynamic error, StackTrace? trace}) =>
      info(message, error: error, trace: trace);

  void w(String message, {dynamic error, StackTrace? trace}) =>
      warning(message, error: error, trace: trace);

  void e(String message, {dynamic error, StackTrace? trace}) =>
      this.error(message, error: error, trace: trace);

  void logNetworkError(NetworkError error);

  void logNetworkRequest(RequestOptions request);

  void logNetworkResponse(Response response);
}

extension LoggerExtension on Object {
  Log get logger => PrefixLogger(
        runtimeType.toString(),
        LoggingFactory.provide(),
      );
}

Log get staticLogger => LoggingFactory.provide();

class LoggingFactory {
  static Log? _instance;

  static Log provide() {
    return _instance ?? reset();
  }

  static Log reset({bool enabled = isInDebug, bool logNetworkInfo = false}) {
    return resetWithLogger(enabled
        ? LoggerLogImpl(
            _makeLogger(),
            logNetworkInfo: logNetworkInfo,
          )
        : VoidLogger());
  }

  static Log resetWithLogger(Log logger) {
    return _instance = logger;
  }

  static Logger _makeLogger() {
    return Logger(
      printer: _makeLogPrinter(),
      output: WrappingOutput(print),
    );
  }

  static LogPrinter _makeLogPrinter() {
    return OurPrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 50,
      colors: isDeviceAndroid,
      printEmojis: true,
      printTime: true,
    );
  }
}

@visibleForTesting
class WrappingOutput extends LogOutput {
  final void Function(String) printer;

  WrappingOutput(this.printer);

  @override
  void output(OutputEvent event) {
    event.lines.forEach(_printWrapped);
  }

  void _printWrapped(String line) {
    final pattern = RegExp('.{1,800}');
    pattern.allMatches(line).forEach((match) => printer(match.group(0)!));
  }
}

@visibleForTesting
class LoggerLogImpl extends Log {
  final Logger logger;
  final bool logNetworkInfo;

  LoggerLogImpl(this.logger, {required this.logNetworkInfo});

  @override
  void debug(String message, {dynamic error, StackTrace? trace}) =>
      logger.d(message, error, trace);

  @override
  void error(String message, {error, StackTrace? trace}) =>
      logger.e(message, error, trace);

  @override
  void info(String message, {dynamic error, StackTrace? trace}) =>
      logger.i(message, error, trace);

  @override
  void verbose(String message, {dynamic error, StackTrace? trace}) =>
      logger.v(message, error, trace);

  @override
  void warning(String message, {dynamic error, StackTrace? trace}) =>
      logger.w(message, error, trace);

  @override
  void logNetworkError(NetworkError error) {
    if (!logNetworkInfo) return;

    final dioError = error;
    final message = StringBuffer();
    final response = dioError.response;
    final request = dioError.requestOptions;
    if (response == null) {
      message
        ..writeln('request | ${request.method} - url: ${request.uri}')
        ..writeln('message | ${dioError.message}');
    } else {
      message
        ..writeln('response.data | ${response.data}')
        ..writeln('response.headers | ${response.headers}');
    }
    message.writeln(
        '<--------------- ${request.method} - url: ${request.uri} - status code: ${response?.statusCode ?? 'N/A'}');
    this.error(message.toString());
  }

  @override
  void logNetworkRequest(RequestOptions request) {
    if (!logNetworkInfo) return;
    debug('---------------> ${request.method} - url: ${request.uri}');
  }

  @override
  void logNetworkResponse(Response response) {
    if (!logNetworkInfo) return;
    debug(
        '<--------------- ${response.requestOptions.method} - url: ${response.requestOptions.uri} - status code: ${response.statusCode ?? 'N/A'}');
  }
}

@visibleForTesting
class VoidLogger implements Log {
  @override
  void d(String message, {error, StackTrace? trace}) {}

  @override
  void debug(String message, {error, StackTrace? trace}) {}

  @override
  void e(String message, {error, StackTrace? trace}) {}

  @override
  void error(String message, {error, StackTrace? trace}) {}

  @override
  void i(String message, {error, StackTrace? trace}) {}

  @override
  void info(String message, {error, StackTrace? trace}) {}

  @override
  void v(String message, {error, StackTrace? trace}) {}

  @override
  void verbose(String message, {error, StackTrace? trace}) {}

  @override
  void w(String message, {error, StackTrace? trace}) {}

  @override
  void warning(String message, {error, StackTrace? trace}) {}

  @override
  void logNetworkError(NetworkError error) {}

  @override
  void logNetworkRequest(RequestOptions request) {}

  @override
  void logNetworkResponse(Response<dynamic> response) {}
}

@visibleForTesting
class PrefixLogger extends Log {
  final Log _delegate;
  final String _name;

  @visibleForTesting
  PrefixLogger(this._name, this._delegate);

  @override
  void debug(String message, {error, StackTrace? trace}) =>
      _delegate.debug('[$_name] $message', error: error, trace: trace);

  @override
  void error(String message, {Object? error, StackTrace? trace}) =>
      _delegate.error('[$_name] $message', error: error, trace: trace);

  @override
  void info(String message, {error, StackTrace? trace}) =>
      _delegate.info('[$_name] $message', error: error, trace: trace);

  @override
  void logNetworkError(NetworkError error) => _delegate.logNetworkError(error);

  @override
  void logNetworkRequest(RequestOptions request) =>
      _delegate.logNetworkRequest(request);

  @override
  void logNetworkResponse(Response<dynamic> response) =>
      _delegate.logNetworkResponse(response);

  @override
  void verbose(String message, {error, StackTrace? trace}) =>
      _delegate.verbose('[$_name] $message', error: error, trace: trace);

  @override
  void warning(String message, {error, StackTrace? trace}) =>
      _delegate.warning('[$_name] $message', error: error, trace: trace);
}
