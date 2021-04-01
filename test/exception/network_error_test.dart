import 'package:dio/dio.dart';
import 'package:dio/src/dio_error.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:icapps_architecture/icapps_architecture.dart';

class TestableNetworkError extends NetworkError {
  TestableNetworkError(
    DioError dioError, {
    String? statusCodeValue,
  }) : super(dioError, statusCodeValue: statusCodeValue);

  @override
  String? get getErrorCode => "Test";
}

void main() {
  late DioError source;

  setUp(() {
    source = DioError(
      requestOptions: RequestOptions(path: '/'),
      response: Response(
          requestOptions: RequestOptions(path: '/'),
          statusCode: 404,
          statusMessage: "Not found"),
      error: ArgumentError('Test'),
      type: DioErrorType.other,
    );
  });

  group('Network error tests', () {
    test('Test show in production', () async {
      expect(TestableNetworkError(source).showInProduction, true);
    });
    test('Test source', () async {
      final sut = TestableNetworkError(source, statusCodeValue: "Failed");
      expect(sut.statusCodeValue, "Failed");
      expect(sut.error, source.error);
      expect(sut.response, source.response);
      expect(sut.requestOptions, source.requestOptions);
      expect(sut.type, source.type);
    });
  });
}