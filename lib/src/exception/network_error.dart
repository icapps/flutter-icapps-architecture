import 'package:dio/dio.dart';

abstract class NetworkError extends DioError {
  final String? statusCodeValue;

  NetworkError(DioError dioError, {this.statusCodeValue})
      : super(
          requestOptions: dioError.requestOptions,
          response: dioError.response,
          error: dioError.error,
          type: dioError.type,
        );

  bool get showInProduction => true;

  String? get getErrorCode;
}
