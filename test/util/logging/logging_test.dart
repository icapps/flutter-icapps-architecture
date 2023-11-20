import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:icapps_architecture/icapps_architecture.dart';
import 'package:icapps_architecture/src/util/logging/impl/LoggerPrinter.dart';
import 'package:logger/logger.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'logging_test.mocks.dart';

class MockNetworkError extends NetworkError {
  MockNetworkError(DioException dioError) : super(dioError);

  @override
  String? get getErrorCode => throw UnimplementedError();

  @override
  String getLocalizedKey() => 'mock_network_error';
}

class TestPrefixHelper {
  Log get getLogger => logger;
}

@GenerateMocks([], customMocks: [
  MockSpec<Log>(onMissingStub: OnMissingStub.returnDefault),
])
void main() {
  group('Static logger', () {
    testWithLogger();
  });
  group('Prefix logger', () {
    test('Test logs with prefix', () {
      final mock = MockLog();
      final log = PrefixLogger('TestPrefix', mock);
      log.v('Test');
      log.d('Test');
      log.w('Test');
      log.i('Test');
      log.e('Test');
      log.logNetworkRequest(RequestOptions(path: '/'));
      log.logNetworkResponse(
          Response(requestOptions: RequestOptions(path: '/')));
      log.logNetworkError(MockNetworkError(
          DioException(requestOptions: RequestOptions(path: '/'))));

      verify(mock.verbose(argThat(startsWith('[TestPrefix] ')))).called(1);
      verify(mock.debug(argThat(startsWith('[TestPrefix] ')))).called(1);
      verify(mock.info(argThat(startsWith('[TestPrefix] ')))).called(1);
      verify(mock.warning(argThat(startsWith('[TestPrefix] ')))).called(1);
      verify(mock.error(argThat(startsWith('[TestPrefix] ')),
              trace: anyNamed('trace'), error: anyNamed('error')))
          .called(1);
      verify(mock.logNetworkResponse(any)).called(1);
      verify(mock.logNetworkRequest(any)).called(1);
      verify(mock.logNetworkError(any)).called(1);
    });
    test('Get prefix', () {
      expect(TestPrefixHelper().getLogger, isInstanceOf<PrefixLogger>());
    });
  });
  group('Logging output', () {
    test('Output logger does not split short items', () {
      final lines = <String>[];
      final output = WrappingOutput((str) => lines.add(str));
      output.output(OutputEvent(LogEvent(Level.info, 'Short string'),
          ['Short string', 'Longer string that does not need to be split']));
      expect(lines,
          ['Short string', 'Longer string that does not need to be split']);
    });
    test('Output logger does splits long items', () {
      final inputString =
          base64Encode(List<int>.generate(1000, (i) => i % 255));
      final lines = <String>[];
      final output = WrappingOutput((str) => lines.add(str));
      output.output(OutputEvent(
          LogEvent(Level.info, 'Short string'), ['Short string', inputString]));
      expect(lines, [
        'Short string',
        'AAECAwQFBgcICQoLDA0ODxAREhMUFRYXGBkaGxwdHh8gISIjJCUmJygpKissLS4vMDEyMzQ1Njc4OTo7PD0+P0BBQkNERUZHSElKS0xNTk9QUVJTVFVWV1hZWltcXV5fYGFiY2RlZmdoaWprbG1ub3BxcnN0dXZ3eHl6e3x9fn+AgYKDhIWGh4iJiouMjY6PkJGSk5SVlpeYmZqbnJ2en6ChoqOkpaanqKmqq6ytrq+wsbKztLW2t7i5uru8vb6/wMHCw8TFxsfIycrLzM3Oz9DR0tPU1dbX2Nna29zd3t/g4eLj5OXm5+jp6uvs7e7v8PHy8/T19vf4+fr7/P3+AAECAwQFBgcICQoLDA0ODxAREhMUFRYXGBkaGxwdHh8gISIjJCUmJygpKissLS4vMDEyMzQ1Njc4OTo7PD0+P0BBQkNERUZHSElKS0xNTk9QUVJTVFVWV1hZWltcXV5fYGFiY2RlZmdoaWprbG1ub3BxcnN0dXZ3eHl6e3x9fn+AgYKDhIWGh4iJiouMjY6PkJGSk5SVlpeYmZqbnJ2en6ChoqOkpaanqKmqq6ytrq+wsbKztLW2t7i5uru8vb6/wMHCw8TFxsfIycrLzM3Oz9DR0tPU1dbX2Nna29zd3t/g4eLj5OXm5+jp6uvs7e7v8PHy8/T19vf4+fr7/P3+AAECAwQFBgcICQoLDA0ODxAREhMUFRYXGBkaGxwdHh8gISIjJCUmJygpKissLS4vMDEyMzQ1Njc4OTo7PD0+P0BBQkNERUZHSElKS0xNTk9QUVJTVFVWV1hZ',
        'WltcXV5fYGFiY2RlZmdoaWprbG1ub3BxcnN0dXZ3eHl6e3x9fn+AgYKDhIWGh4iJiouMjY6PkJGSk5SVlpeYmZqbnJ2en6ChoqOkpaanqKmqq6ytrq+wsbKztLW2t7i5uru8vb6/wMHCw8TFxsfIycrLzM3Oz9DR0tPU1dbX2Nna29zd3t/g4eLj5OXm5+jp6uvs7e7v8PHy8/T19vf4+fr7/P3+AAECAwQFBgcICQoLDA0ODxAREhMUFRYXGBkaGxwdHh8gISIjJCUmJygpKissLS4vMDEyMzQ1Njc4OTo7PD0+P0BBQkNERUZHSElKS0xNTk9QUVJTVFVWV1hZWltcXV5fYGFiY2RlZmdoaWprbG1ub3BxcnN0dXZ3eHl6e3x9fn+AgYKDhIWGh4iJiouMjY6PkJGSk5SVlpeYmZqbnJ2en6ChoqOkpaanqKmqq6ytrq+wsbKztLW2t7i5uru8vb6/wMHCw8TFxsfIycrLzM3Oz9DR0tPU1dbX2Nna29zd3t/g4eLj5OXm5+jp6g=='
      ]);
    });
  });
}

void testWithLogger() {
  void _logAllLevels() {
    staticLogger.v('Verbose message');
    staticLogger.d('Debug message');
    staticLogger.i('Info message');
    staticLogger.w('Warning message');
    staticLogger.e('Error message');
  }

  group('Logging tests', () {
    test('Test get logger, unset', () {
      expect(staticLogger, isInstanceOf<LoggerLogImpl>());
    });
    test('Test get logger, custom set', () {
      LoggingFactory.resetWithLogger(VoidLogger());
      expect(staticLogger, isInstanceOf<VoidLogger>());
    });
    test('Test get logger, configure disable', () {
      LoggingFactory.configure(LoggingConfiguration(isEnabled: false));
      expect(staticLogger, isInstanceOf<VoidLogger>());
    });
    test('Test get logger, configure enable', () {
      LoggingFactory.configure(LoggingConfiguration(isEnabled: true));
      expect(staticLogger, isInstanceOf<LoggerLogImpl>());
    });
    test('Test logger methods default', () {
      final buffer = <String>[];
      LoggingFactory.configure(LoggingConfiguration(
        printTime: false,
        shouldLogNetworkInfo: false,
        onLog: (logLine) => buffer.add(logLine),
      ));
      _logAllLevels();
      expect(buffer[0], ' Verbose message');
      expect(buffer[1], ' 🐛 Debug message');
      expect(buffer[2], ' 💡 Info message');
      expect(buffer[3], ' ⚠️ Warning message');
      expect(buffer[4], ' ⛔ Error message');
    });

    void _testLogLevel({
      required Level logLevel,
      required Function(List<String> messages) expectLogs,
    }) {
      final buffer = <String>[];
      LoggingFactory.configure(LoggingConfiguration(
        printTime: false,
        shouldLogNetworkInfo: false,
        loggingLevel: logLevel,
        onLog: (logLine) => buffer.add(logLine),
      ));
      _logAllLevels();
      expectLogs(buffer);
    }

    test(
      'Test logger level verbose',
      () => _testLogLevel(
        logLevel: Level.verbose,
        expectLogs: (messages) {
          expect(messages[0], ' Verbose message');
          expect(messages[1], ' 🐛 Debug message');
          expect(messages[2], ' 💡 Info message');
          expect(messages[3], ' ⚠️ Warning message');
          expect(messages[4], ' ⛔ Error message');
        },
      ),
    );

    test(
      'Test logger level debug',
      () => _testLogLevel(
        logLevel: Level.debug,
        expectLogs: (messages) {
          expect(messages[0], ' 🐛 Debug message');
          expect(messages[1], ' 💡 Info message');
          expect(messages[2], ' ⚠️ Warning message');
          expect(messages[3], ' ⛔ Error message');
        },
      ),
    );
    test(
      'Test logger level info',
      () => _testLogLevel(
        logLevel: Level.info,
        expectLogs: (messages) {
          expect(messages[0], ' 💡 Info message');
          expect(messages[1], ' ⚠️ Warning message');
          expect(messages[2], ' ⛔ Error message');
        },
      ),
    );

    test(
      'Test logger level warning',
      () => _testLogLevel(
        logLevel: Level.warning,
        expectLogs: (messages) {
          expect(messages[0], ' ⚠️ Warning message');
          expect(messages[1], ' ⛔ Error message');
        },
      ),
    );

    test(
      'Test logger level error',
      () => _testLogLevel(
        logLevel: Level.error,
        expectLogs: (messages) {
          expect(messages[0], ' ⛔ Error message');
        },
      ),
    );

    test('Test logger methods void', () {
      LoggingFactory.resetWithLogger(VoidLogger());
      staticLogger.v('Verbose message');
      staticLogger.d('Debug message');
      staticLogger.i('Info message');
      staticLogger.w('Warning message');
      staticLogger.e('Error message');
      staticLogger.verbose('Verbose message');
      staticLogger.debug('Debug message');
      staticLogger.info('Info message');
      staticLogger.warning('Warning message');
      staticLogger.error('Error message');
      staticLogger.logNetworkRequest(RequestOptions(path: '/'));
      staticLogger.logNetworkResponse(
          Response(requestOptions: RequestOptions(path: '/')));
      staticLogger.logNetworkError(MockNetworkError(
          DioException(requestOptions: RequestOptions(path: '/'))));
    });
    test('Test logger methods default pretty', () {
      final buffer = MemoryOutput();
      LoggingFactory.resetWithLogger(
        LoggerLogImpl(
            Logger(
              printer: OurPrettyPrinter(
                methodCount: 0,
                errorMethodCount: 5,
                stackTraceBeginIndex: 1,
                lineLength: 50,
                colors: false,
                printEmojis: true,
                printTime: true,
              ),
              output: buffer,
            ),
            logNetworkInfo: false),
      );
      staticLogger.v('Verbose message');
      staticLogger.d('Debug message');
      staticLogger.i('Info message');
      staticLogger.w('Warning message');
      staticLogger.e('Error message',
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
          matches(' \\d+:\\d+:\\d+\\.\\d+\\s+⛔ Error message'));
      expect(messages[4].lines[1],
          matches('\\d+:\\d+:\\d+\\.\\d+\\s+Invalid argument\\(s\\)'));
      expect(
          messages[4].lines[2],
          matches(
              '\\d+:\\d+:\\d+\\.\\d+\\s+#0   Declarer.test.<anonymous closure>.<anonymous closure> \\(package:test_api/src/backend/declarer.dart:\\d+:\\d+\\)'));
      expect(messages[4].lines[3],
          matches('\\d+:\\d+:\\d+\\.\\d+\\s+#1   <asynchronous suspension>'));
      expect(
          messages[4].lines[4],
          matches(
              '\\d+:\\d+:\\d+\\.\\d+\\s+#2   Declarer.test.<anonymous closure> \\(package:test_api/src/backend/declarer.dart:\\d+:\\d+\\)'));
      expect(messages[4].lines[5],
          matches('\\d+:\\d+:\\d+\\.\\d+\\s+#3   <asynchronous suspension>'));
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
      staticLogger.d('Debug message');
      final messages = buffer.buffer.toList(growable: false);
      expect(
          messages[0].lines[1],
          matches(
              '#0   OurPrettyPrinter.log \\(package:icapps_architecture/src/util/logging/impl/LoggerPrinter.dart:\\d+:\\d+\\)'));
      expect(messages[0].lines[0], ' 🐛 Debug message');
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
          lines[1], '\x1B[39m\x1B[48;5;196mInvalid argument(s)\x1B[0m\x1B[49m');
      expect(lines[0], '\x1B[38;5;196m ⛔ Error\x1B[0m');
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
          lines[1], '\x1B[39m\x1B[48;5;199mInvalid argument(s)\x1B[0m\x1B[49m');
      expect(lines[0], '\x1B[38;5;199m 👾 WTF\x1B[0m');
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
      final buffer = <String>[];
      LoggingFactory.configure(LoggingConfiguration(
        shouldLogNetworkInfo: false,
        onLog: (logLine) => buffer.add(logLine),
      ));
      staticLogger.logNetworkRequest(RequestOptions(path: '/'));
      staticLogger.logNetworkResponse(
          Response(requestOptions: RequestOptions(path: '/')));
      staticLogger.logNetworkError(MockNetworkError(
          DioException(requestOptions: RequestOptions(path: '/'))));
      expect(buffer.isEmpty, true);
    });
    test('Test logger network enabled', () {
      final buffer = <String>[];
      LoggingFactory.configure(LoggingConfiguration(
        shouldLogNetworkInfo: true,
        printTime: false,
        onLog: (logLine) => buffer.add(logLine),
      ));
      staticLogger.logNetworkRequest(
          RequestOptions(path: '/', baseUrl: 'https://www.example.com'));
      staticLogger.logNetworkResponse(Response(
          requestOptions:
              RequestOptions(path: '/', baseUrl: 'https://www.example.com')));
      staticLogger.logNetworkResponse(Response(
          requestOptions:
              RequestOptions(path: '/', baseUrl: 'https://www.example.com'),
          statusCode: 404));
      staticLogger.logNetworkError(MockNetworkError(DioException(
          requestOptions:
              RequestOptions(path: '/', baseUrl: 'https://www.example.com'))));
      staticLogger.logNetworkError(MockNetworkError(DioException(
          requestOptions:
              RequestOptions(path: '/', baseUrl: 'https://www.example.com'),
          response: Response(
              requestOptions: RequestOptions(
                  path: '/', baseUrl: 'https://www.example.com')))));
      staticLogger.logNetworkError(MockNetworkError(DioException(
          requestOptions:
              RequestOptions(path: '/', baseUrl: 'https://www.example.com'),
          response: Response(
              requestOptions:
                  RequestOptions(path: '/', baseUrl: 'https://www.example.com'),
              statusCode: 404))));

      expect(buffer[0],
          ' 🐛 ---------------> GET - url: https://www.example.com/');
      expect(buffer[1],
          ' 🐛 <--------------- GET - url: https://www.example.com/ - status code: N/A');
      expect(buffer[2],
          ' 🐛 <--------------- GET - url: https://www.example.com/ - status code: 404');
      expect(buffer[3], ' ⛔ request | GET - url: https://www.example.com/');
      expect(buffer[4], ' ⛔ message | ');
      expect(buffer[5],
          ' ⛔ <--------------- GET - url: https://www.example.com/ - status code: N/A');
      expect(buffer[6], ' ⛔ ');
      expect(buffer[7], ' ⛔ response.data | null');
      expect(buffer[8], ' ⛔ response.headers | ');
      expect(buffer[9],
          ' ⛔ <--------------- GET - url: https://www.example.com/ - status code: N/A');
      expect(buffer[10], ' ⛔ ');
      expect(buffer[11], ' ⛔ response.data | null');
      expect(buffer[12], ' ⛔ response.headers | ');
      expect(buffer[13],
          ' ⛔ <--------------- GET - url: https://www.example.com/ - status code: 404');
    });
  });
}
