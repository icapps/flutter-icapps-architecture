import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:icapps_architecture/icapps_architecture.dart';
import 'package:icapps_architecture/src/util/logging/impl/LoggerPrinter.dart';
import 'package:logger/logger.dart';

class MockNetworkError extends NetworkError {
  MockNetworkError(DioError dioError) : super(dioError);

  @override
  String? get getErrorCode => throw UnimplementedError();
}

void main() {
  group('Logging tests', () {
    test('Test get logger, unset', () {
      expect(logger, isInstanceOf<LoggerLogImpl>());
    });
    test('Test get logger, custom set', () {
      LoggingFactory.resetWithLogger(VoidLogger());
      expect(logger, isInstanceOf<VoidLogger>());
    });
    test('Test get logger, reset disable', () {
      LoggingFactory.reset(enabled: false);
      expect(logger, isInstanceOf<VoidLogger>());
    });
    test('Test get logger, reset enable', () {
      LoggingFactory.reset(enabled: true);
      expect(logger, isInstanceOf<LoggerLogImpl>());
    });
    test('Test logger methods default', () {
      final buffer = MemoryOutput();
      LoggingFactory.resetWithLogger(LoggerLogImpl(
          Logger(
            printer: SimplePrinter(printTime: false, colors: false),
            output: buffer,
          ),
          logNetworkInfo: false));
      logger.v('Verbose message');
      logger.d('Debug message');
      logger.i('Info message');
      logger.w('Warning message');
      logger.e('Error message');
      final messages = buffer.buffer.toList(growable: false);
      expect(messages[0].lines[0], '[V]  Verbose message');
      expect(messages[1].lines[0], '[D]  Debug message');
      expect(messages[2].lines[0], '[I]  Info message');
      expect(messages[3].lines[0], '[W]  Warning message');
      expect(messages[4].lines[0], '[E]  Error message');
    });
    test('Test logger methods void', () {
      LoggingFactory.resetWithLogger(VoidLogger());
      logger.v('Verbose message');
      logger.d('Debug message');
      logger.i('Info message');
      logger.w('Warning message');
      logger.e('Error message');
      logger.verbose('Verbose message');
      logger.debug('Debug message');
      logger.info('Info message');
      logger.warning('Warning message');
      logger.error('Error message');
      logger.logNetworkRequest(RequestOptions(path: '/'));
      logger.logNetworkResponse(
          Response(requestOptions: RequestOptions(path: '/')));
      logger.logNetworkError(MockNetworkError(
          DioError(requestOptions: RequestOptions(path: '/'))));
    });
    test('Test logger methods default pretty', () {
      final buffer = MemoryOutput();
      LoggingFactory.resetWithLogger(LoggerLogImpl(
          Logger(
            printer: OurPrettyPrinter(
                methodCount: 0,
                errorMethodCount: 5,
                stackTraceBeginIndex: 1,
                lineLength: 50,
                colors: false,
                printEmojis: true,
                printTime: true),
            output: buffer,
          ),
          logNetworkInfo: false));
      logger.v('Verbose message');
      logger.d('Debug message');
      logger.i('Info message');
      logger.w('Warning message');
      logger.e('Error message',
          error: ArgumentError(), trace: StackTrace.current);
      final messages = buffer.buffer.toList(growable: false);
      expect(messages[0].lines.join(" "),
          matches(' \\d+:\\d+:\\d+\\.\\d+\\s+Verbose message'));
      expect(messages[1].lines.join(" "),
          matches(' \\d+:\\d+:\\d+\\.\\d+\\s+🐛 Debug message'));
      expect(messages[2].lines.join(" "),
          matches(' \\d+:\\d+:\\d+\\.\\d+\\s+💡 Info message'));
      expect(messages[3].lines.join(" "),
          matches(' \\d+:\\d+:\\d+\\.\\d+\\s+⚠️ Warning message'));
      expect(messages[4].lines[0],
          matches('\\d+:\\d+:\\d+\\.\\d+\\s+Invalid argument\\(s\\)'));
      expect(
          messages[4].lines[1],
          matches(
              '\\d+:\\d+:\\d+\\.\\d+\\s+#0   Declarer.test.<anonymous closure>.<anonymous closure> \\(package:test_api/src/backend/declarer.dart:\\d+:\\d+\\)'));
      expect(messages[4].lines[2],
          matches(' \\d+:\\d+:\\d+\\.\\d+\\s+#1   <asynchronous suspension>'));
      expect(
          messages[4].lines[3],
          matches(
              '\\d+:\\d+:\\d+\\.\\d+\\s+#2   StackZoneSpecification._registerUnaryCallback.<anonymous closure> \\(package:stack_trace/src/stack_zone_specification.dart\\)'));
      expect(messages[4].lines[4],
          matches('\\d+:\\d+:\\d+\\.\\d+\\s+#3   <asynchronous suspension>'));
      expect(messages[4].lines[5],
          matches(' \\d+:\\d+:\\d+\\.\\d+\\s+⛔ Error message'));
    });
    test('Test logger methods default pretty include method', () {
      final buffer = MemoryOutput();
      LoggingFactory.resetWithLogger(LoggerLogImpl(
          Logger(
            printer: OurPrettyPrinter(
                methodCount: 1,
                errorMethodCount: 5,
                stackTraceBeginIndex: 0,
                lineLength: 50,
                colors: false,
                printEmojis: true,
                printTime: false),
            output: buffer,
          ),
          logNetworkInfo: false));
      logger.d('Debug message');
      final messages = buffer.buffer.toList(growable: false);
      expect(
          messages[0].lines[0],
          matches(
              ' #0   OurPrettyPrinter.log \\(package:icapps_architecture/src/util/logging/impl/LoggerPrinter.dart:\\d+:\\d+\\)'));
      expect(messages[0].lines[1], ' 🐛 Debug message');
    });
    test('Test logger methods default json', () {
      final lines = OurPrettyPrinter(
              methodCount: 0,
              errorMethodCount: 5,
              stackTraceBeginIndex: 1,
              lineLength: 50,
              colors: true,
              printEmojis: true,
              printTime: false)
          .log(LogEvent(Level.wtf, ['Some', 'body'], null, null));

      expect(lines[0], '\x1B[38;5;199m 👾 [\x1B[0m');
      expect(lines[1], '\x1B[38;5;199m 👾   "Some",\x1B[0m');
      expect(lines[2], '\x1B[38;5;199m 👾   "body"\x1B[0m');
      expect(lines[3], '\x1B[38;5;199m 👾 ]\x1B[0m');
    });
    test('Test logger methods default error color', () {
      final lines = OurPrettyPrinter(
              methodCount: 0,
              errorMethodCount: 1,
              stackTraceBeginIndex: 0,
              lineLength: 50,
              colors: true,
              printEmojis: true,
              printTime: false)
          .log(LogEvent(Level.error, 'Error', ArgumentError(), null));

      expect(
          lines[0], '\x1B[39m\x1B[48;5;196mInvalid argument(s)\x1B[0m\x1B[49m');
      expect(lines[1], '\x1B[38;5;196m ⛔ Error\x1B[0m');
    });
    test('Test logger methods default error color wtf', () {
      final lines = OurPrettyPrinter(
              methodCount: 0,
              errorMethodCount: 1,
              stackTraceBeginIndex: 0,
              lineLength: 50,
              colors: true,
              printEmojis: true,
              printTime: false)
          .log(LogEvent(Level.wtf, 'WTF', ArgumentError(), null));

      expect(
          lines[0], '\x1B[39m\x1B[48;5;199mInvalid argument(s)\x1B[0m\x1B[49m');
      expect(lines[1], '\x1B[38;5;199m 👾 WTF\x1B[0m');
    });
    test('Test logger methods default build stack trace', () {
      final formatted = OurPrettyPrinter(
              methodCount: 0,
              errorMethodCount: 1,
              stackTraceBeginIndex: 0,
              lineLength: 50,
              colors: true,
              printEmojis: true,
              printTime: true)
          .formatStackTrace(
              StackTrace.fromString(
                  '#1      Logger.log (package:logger/src/logger.dart:115:29)\npackages/logger/src/printers/pretty_printer.dart 91:37\npackage:logger/lib'),
              3);

      expect(formatted,
          '#0   packages/logger/src/printers/pretty_printer.dart 91:37\n#1   package:logger/lib');
    });
  });
  group('Test network logging', () {
    test('Test logger network disabled', () {
      final buffer = MemoryOutput();
      LoggingFactory.resetWithLogger(LoggerLogImpl(
          Logger(
            printer: SimplePrinter(printTime: false, colors: false),
            output: buffer,
          ),
          logNetworkInfo: false));
      logger.logNetworkRequest(RequestOptions(path: '/'));
      logger.logNetworkResponse(
          Response(requestOptions: RequestOptions(path: '/')));
      logger.logNetworkError(MockNetworkError(
          DioError(requestOptions: RequestOptions(path: '/'))));
      expect(buffer.buffer.isEmpty, true);
    });
    test('Test logger network enabled', () {
      final buffer = MemoryOutput();
      LoggingFactory.resetWithLogger(LoggerLogImpl(
          Logger(
            printer: SimplePrinter(printTime: false, colors: false),
            output: buffer,
          ),
          logNetworkInfo: true));
      logger.logNetworkRequest(
          RequestOptions(path: '/', baseUrl: 'https://www.example.com'));
      logger.logNetworkResponse(Response(
          requestOptions:
              RequestOptions(path: '/', baseUrl: 'https://www.example.com')));
      logger.logNetworkResponse(Response(
          requestOptions:
              RequestOptions(path: '/', baseUrl: 'https://www.example.com'),
          statusCode: 404));
      logger.logNetworkError(MockNetworkError(DioError(
          requestOptions:
              RequestOptions(path: '/', baseUrl: 'https://www.example.com'))));
      logger.logNetworkError(MockNetworkError(DioError(
          requestOptions:
              RequestOptions(path: '/', baseUrl: 'https://www.example.com'),
          response: Response(
              requestOptions: RequestOptions(
                  path: '/', baseUrl: 'https://www.example.com')))));
      logger.logNetworkError(MockNetworkError(DioError(
          requestOptions:
              RequestOptions(path: '/', baseUrl: 'https://www.example.com'),
          response: Response(
              requestOptions:
                  RequestOptions(path: '/', baseUrl: 'https://www.example.com'),
              statusCode: 404))));

      final messages = buffer.buffer.toList(growable: false);
      expect(messages[0].lines[0],
          '[D]  ---------------> GET - url: https://www.example.com/');
      expect(messages[1].lines[0],
          '[D]  <--------------- GET - url: https://www.example.com/ - status code: N/A');
      expect(messages[2].lines[0],
          '[D]  <--------------- GET - url: https://www.example.com/ - status code: 404');
      expect(messages[3].lines[0],
          '[E]  request | GET - url: https://www.example.com/\nmessage | \n<--------------- GET - url: https://www.example.com/ - status code: N/A\n');
      expect(messages[4].lines[0],
          '[E]  response.data | null\nresponse.headers | \n<--------------- GET - url: https://www.example.com/ - status code: N/A\n');
      expect(messages[5].lines[0],
          '[E]  response.data | null\nresponse.headers | \n<--------------- GET - url: https://www.example.com/ - status code: 404\n');
    });
  });
}
