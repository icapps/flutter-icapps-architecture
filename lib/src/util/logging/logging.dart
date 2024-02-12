import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:icapps_architecture/icapps_architecture.dart';
import 'package:logger/logger.dart';

import 'impl/LoggerPrinter.dart';

class LoggingConfiguration {
  final bool shouldLogNetworkInfo;
  final bool isEnabled;
  final bool printTime;
  final Level loggingLevel;
  final ValueChanged<String>? onLog;

  LoggingConfiguration({
    this.shouldLogNetworkInfo = false,
    this.printTime = true,
    this.onLog,
    this.isEnabled = true,
    this.loggingLevel = Level.trace,
  });
}

abstract class Log {
  void trace(String message, {dynamic error, StackTrace? stackTrace});

  void debug(String message, {dynamic error, StackTrace? stackTrace});

  void info(String message, {dynamic error, StackTrace? stackTrace});

  void warning(String message, {dynamic error, StackTrace? stackTrace});

  void error(String message, {dynamic error, StackTrace? stackTrace});

  void t(String message, {dynamic error, StackTrace? stackTrace}) => trace(message, error: error, stackTrace: stackTrace);

  void d(String message, {dynamic error, StackTrace? stackTrace}) => debug(message, error: error, stackTrace: stackTrace);

  void i(String message, {dynamic error, StackTrace? stackTrace}) => info(message, error: error, stackTrace: stackTrace);

  void w(String message, {dynamic error, StackTrace? stackTrace}) => warning(message, error: error, stackTrace: stackTrace);

  void e(String message, {dynamic error, StackTrace? stackTrace}) => this.error(message, error: error, stackTrace: stackTrace);

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
    return _instance ?? configure(LoggingConfiguration());
  }

  static Log configure(LoggingConfiguration configuration) {
    return resetWithLogger(configuration.isEnabled
        ? LoggerLogImpl(
            _makeLogger(configuration),
            logNetworkInfo: configuration.shouldLogNetworkInfo,
          )
        : VoidLogger());
  }

  static Log resetWithLogger(Log logger) {
    return _instance = logger;
  }

  static Logger _makeLogger(LoggingConfiguration configuration) {
    return Logger(
      printer: _makeLogPrinter(configuration),
      output: WrappingOutput((line) {
        if (isInDebug) print(line);
        configuration.onLog?.call(line);
      }),
      level: configuration.loggingLevel,
    );
  }

  static LogPrinter _makeLogPrinter(LoggingConfiguration configuration) {
    return OurPrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 50,
      colors: isDeviceAndroid,
      printEmojis: true,
      printTime: configuration.printTime,
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
  void debug(String message, {dynamic error, StackTrace? stackTrace}) => logger.d(message, error: error, stackTrace: stackTrace);

  @override
  void error(String message, {error, StackTrace? stackTrace}) => logger.e(message, error: error, stackTrace: stackTrace);

  @override
  void info(String message, {dynamic error, StackTrace? stackTrace}) => logger.i(message, error: error, stackTrace: stackTrace);

  @override
  void trace(String message, {dynamic error, StackTrace? stackTrace}) => logger.t(message, error: error, stackTrace: stackTrace);

  @override
  void warning(String message, {dynamic error, StackTrace? stackTrace}) => logger.w(message, error: error, stackTrace: stackTrace);

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
        ..writeln('message | ${dioError.message ?? ''}');
    } else {
      message
        ..writeln('response.data | ${response.data}')
        ..writeln('response.headers | ${response.headers}');
    }
    message.writeln('<--------------- ${request.method} - url: ${request.uri} - status code: ${response?.statusCode ?? 'N/A'}');
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
    debug('<--------------- ${response.requestOptions.method} - url: ${response.requestOptions.uri} - status code: ${response.statusCode ?? 'N/A'}');
  }
}

@visibleForTesting
class VoidLogger implements Log {
  @override
  void d(String message, {error, StackTrace? stackTrace}) {}

  @override
  void debug(String message, {error, StackTrace? stackTrace}) {}

  @override
  void e(String message, {error, StackTrace? stackTrace}) {}

  @override
  void error(String message, {error, StackTrace? stackTrace}) {}

  @override
  void i(String message, {error, StackTrace? stackTrace}) {}

  @override
  void info(String message, {error, StackTrace? stackTrace}) {}

  @override
  void t(String message, {error, StackTrace? stackTrace}) {}

  @override
  void trace(String message, {error, StackTrace? stackTrace}) {}

  @override
  void w(String message, {error, StackTrace? stackTrace}) {}

  @override
  void warning(String message, {error, StackTrace? stackTrace}) {}

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
  void debug(String message, {error, StackTrace? stackTrace}) => _delegate.debug('[$_name] $message', error: error, stackTrace: stackTrace);

  @override
  void error(String message, {Object? error, StackTrace? stackTrace}) => _delegate.error('[$_name] $message', error: error, stackTrace: stackTrace);

  @override
  void info(String message, {error, StackTrace? stackTrace}) => _delegate.info('[$_name] $message', error: error, stackTrace: stackTrace);

  @override
  void logNetworkError(NetworkError error) => _delegate.logNetworkError(error);

  @override
  void logNetworkRequest(RequestOptions request) => _delegate.logNetworkRequest(request);

  @override
  void logNetworkResponse(Response<dynamic> response) => _delegate.logNetworkResponse(response);

  @override
  void trace(String message, {error, StackTrace? stackTrace}) => _delegate.trace('[$_name] $message', error: error, stackTrace: stackTrace);

  @override
  void warning(String message, {error, StackTrace? stackTrace}) => _delegate.warning('[$_name] $message', error: error, stackTrace: stackTrace);
}
