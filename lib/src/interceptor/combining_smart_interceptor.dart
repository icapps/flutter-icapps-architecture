import 'dart:async';

import 'package:dio/dio.dart';
import 'package:icapps_architecture/src/exception/network_error.dart';

/// Base class for simple [Dio] interceptors to be used in conjunction with
/// [CombiningSmartInterceptor].
///
/// Upon returning an instance of [DioError] from [onRequest] or [onResponse],
/// the error interceptors will NOT be called
abstract class SimpleInterceptor {
  /// Called when the interceptor should process the request ([options])
  ///
  /// Return a future with (modified) [RequestOptions] to continue the chain
  /// or an instance of [DioError] (or subclasses) to halt processing.
  ///
  /// Any other values will simply call the next interceptor with [options]
  Future<Object?> onRequest(RequestOptions options) {
    return Future.value(options);
  }

  /// Called when the interceptor should process the request ([options])
  ///
  /// Return a future with (modified) [RequestOptions] to continue the chain
  /// or an instance of [DioError] (or subclasses) to halt processing.
  ///
  /// Any other values will simply call the next interceptor with [options]
  Future<Object?> onResponse(Response response) {
    return Future.value(response);
  }

  /// Called when the interceptor should process an [error]
  ///
  /// Return a future with (modified) [DioError] to continue the chain
  /// or an instance of [Response] (or subclasses) to halt processing and
  /// mark the request as successful. NOTE: When returning [Response], no other
  /// interceptors will be called.
  ///
  /// Any other values will simply call the next interceptor with [error]
  Future<Object?> onError(DioError error) {
    return Future.value(error);
  }
}

/// Dio [Interceptor] implementation which calls the interceptors in the logical
/// order (request in the interceptor order, responses and errors in the reverse
/// order)
class CombiningSmartInterceptor implements Interceptor {
  final _interceptors = <SimpleInterceptor>[];

  /// Constructor taking an optional [initial] collection of interceptors to
  /// pre-fill the interceptors
  CombiningSmartInterceptor([Iterable<SimpleInterceptor>? initial]) {
    if (initial != null) {
      _interceptors.addAll(initial);
    }
  }

  /// Adds an interceptor at the end of the chain (called LAST)
  void addInterceptor(SimpleInterceptor interceptor) {
    _interceptors.add(interceptor);
  }

  @override
  Future<void> onError(DioError err, ErrorInterceptorHandler handler) async {
    NetworkError? finalResult;
    for (final interceptor in _interceptors.reversed) {
      final dynamic res = await interceptor
          .onError(finalResult is DioError ? finalResult! : err);
      if (res is Response) {
        handler.resolve(res);
        return;
      }
      if (res is NetworkError) {
        finalResult = res;
      }
    }
    handler.next(finalResult ?? err);
  }

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    var intermediate = options;
    for (final interceptor in _interceptors) {
      final dynamic res = await interceptor.onRequest(intermediate);
      if (res is RequestOptions) {
        intermediate = res;
        continue;
      } else if (res is DioError) {
        handler.reject(res, false);
        return;
      }
    }
    handler.next(intermediate);
  }

  @override
  Future<void> onResponse(
      Response response, ResponseInterceptorHandler handler) async {
    var intermediate = response;
    for (final interceptor in _interceptors.reversed) {
      final dynamic res = await interceptor.onResponse(intermediate);
      if (res is Response) {
        intermediate = res;
        continue;
      } else if (res is DioError) {
        handler.reject(res, false);
        return;
      }
    }
    handler.next(intermediate);
  }
}
