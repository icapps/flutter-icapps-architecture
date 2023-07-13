import 'package:dio/dio.dart';
import 'package:icapps_architecture/src/exception/localized_error.dart';

/// Base class for network errors
abstract class NetworkError extends DioException with LocalizedError {
  final String? statusCodeValue;

  NetworkError(DioException dioException, {this.statusCodeValue})
      : super(
          requestOptions: dioException.requestOptions,
          response: dioException.response,
          error: dioException.error,
          type: dioException.type,
        );

  /// Flag indicating if this error should be shown in production
  bool get showInProduction => true;

  /// The error code associated with this error
  String? get getErrorCode;
}
