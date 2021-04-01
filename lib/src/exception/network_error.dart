import 'package:dio/dio.dart';

/// Base class for network errors
abstract class NetworkError extends DioError {
  final String? statusCodeValue;

  NetworkError(DioError dioError, {this.statusCodeValue})
      : super(
          requestOptions: dioError.requestOptions,
          response: dioError.response,
          error: dioError.error,
          type: dioError.type,
        );

  /// Flag indicating if this error should be shown in production
  bool get showInProduction => true;

  /// The error code associated with this error
  String? get getErrorCode;
}
