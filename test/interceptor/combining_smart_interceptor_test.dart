// ignore_for_file: invalid_use_of_protected_member

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:icapps_architecture/icapps_architecture.dart';

void main() {
  late CombiningSmartInterceptor sut;

  setUp(() async {
    sut = CombiningSmartInterceptor();
  });

  test('CombiningSmartInterceptor test initial', () async {
    final interceptor1 = TestInterceptor();
    final interceptor2 = TestInterceptor();
    final interceptor3 = TestInterceptor();
    sut = CombiningSmartInterceptor([interceptor1, interceptor2, interceptor3]);

    final requestOptions = RequestOptions(path: '');
    final handler = RequestInterceptorHandler();
    await sut.onRequest(requestOptions, handler);
    expect(interceptor1.onRequestCalled.isBefore(interceptor2.onRequestCalled),
        true);
    expect(interceptor2.onRequestCalled.isBefore(interceptor3.onRequestCalled),
        true);
  });

  test('CombiningSmartInterceptor test sequence onrequest', () async {
    final interceptor1 = TestInterceptor();
    final interceptor2 = TestInterceptor();
    final interceptor3 = TestInterceptor();
    sut
      ..addInterceptor(interceptor1)
      ..addInterceptor(interceptor2)
      ..addInterceptor(interceptor3);

    final requestOptions = RequestOptions(path: '');
    final handler = RequestInterceptorHandler();
    await sut.onRequest(requestOptions, handler);
    expect(interceptor1.onRequestCalled.isBefore(interceptor2.onRequestCalled),
        true);
    expect(interceptor2.onRequestCalled.isBefore(interceptor3.onRequestCalled),
        true);
  });

  test('CombiningSmartInterceptor test sequence onresponse', () async {
    final interceptor1 = TestInterceptor();
    final interceptor2 = TestInterceptor();
    final interceptor3 = TestInterceptor();
    sut
      ..addInterceptor(interceptor1)
      ..addInterceptor(interceptor2)
      ..addInterceptor(interceptor3);

    final response = Response<void>(requestOptions: RequestOptions(path: ''));
    final handler = ResponseInterceptorHandler();
    await sut.onResponse(response, handler);
    expect(interceptor1.onResponseCalled.isAfter(interceptor2.onResponseCalled),
        true);
    expect(interceptor2.onResponseCalled.isAfter(interceptor3.onResponseCalled),
        true);
  });

  test('CombiningSmartInterceptor test sequence onError', () async {
    final interceptor1 = TestInterceptor();
    final interceptor2 = TestInterceptor();
    final interceptor3 = TestInterceptor();
    sut
      ..addInterceptor(interceptor1)
      ..addInterceptor(interceptor2)
      ..addInterceptor(interceptor3);

    final error = DioException(requestOptions: RequestOptions(path: ''));
    final handler = ErrorInterceptorHandler();
    await sut.onError(error, handler);
    try {
      await handler.future;
    } catch (ignored) {
      final dynamic copy = ignored;
      expect(copy.data, error);
    }
    expect(
        interceptor1.onErrorCalled.isAfter(interceptor2.onErrorCalled), true);
    expect(
        interceptor2.onErrorCalled.isAfter(interceptor3.onErrorCalled), true);
  });

  test('CombiningSmartInterceptor test sequence onError response', () async {
    final interceptor1 = TestInterceptor(
        errorResponse: Response(requestOptions: RequestOptions(path: '/')));
    sut..addInterceptor(interceptor1);

    final error = DioException(requestOptions: RequestOptions(path: ''));
    final handler = ErrorInterceptorHandler();
    await sut.onError(error, handler);
    expect((await handler.future).data, isInstanceOf<Response>());
  });

  test('CombiningSmartInterceptor test sequence onError throws dio error',
      () async {
    final interceptor1 = TestInterceptor(
        throws: DioException(requestOptions: RequestOptions(path: '/')));
    sut..addInterceptor(interceptor1);

    final error = DioException(requestOptions: RequestOptions(path: ''));
    final handler = ErrorInterceptorHandler();
    await sut.onError(error, handler);

    try {
      await handler.future;
      // ignore: nullable_type_in_catch_clause
    } on dynamic catch (e) {
      expect(e.data, isInstanceOf<DioException>());
    }
  });

  test('CombiningSmartInterceptor test sequence onError throws error',
      () async {
    final interceptor1 =
        TestInterceptor(throws: UnimplementedError('Not implemented'));
    sut..addInterceptor(interceptor1);

    final error = DioException(requestOptions: RequestOptions(path: ''));
    final handler = ErrorInterceptorHandler();
    await sut.onError(error, handler);

    try {
      await handler.future;
      // ignore: nullable_type_in_catch_clause
    } on dynamic catch (e) {
      expect(e.data, isInstanceOf<DioException>());
      expect(
          (e.data as DioException).error, isInstanceOf<UnimplementedError>());
    }
  });

  test('CombiningSmartInterceptor test onRequest returns error', () async {
    final interceptor1 = TestInterceptor(
      requestResponse: DioException(requestOptions: RequestOptions(path: '/')),
    );
    sut..addInterceptor(interceptor1);
    final requestOptions = RequestOptions(path: '');
    final handler = RequestInterceptorHandler();
    await sut.onRequest(requestOptions, handler);
    try {
      await handler.future;
      // ignore: nullable_type_in_catch_clause
    } on dynamic catch (e) {
      expect(e.data, isInstanceOf<DioException>());
    }
  });

  test('CombiningSmartInterceptor test onRequest throws dio error', () async {
    final interceptor1 = TestInterceptor(
      throws: DioException(requestOptions: RequestOptions(path: '/')),
    );
    sut..addInterceptor(interceptor1);
    final requestOptions = RequestOptions(path: '');
    final handler = RequestInterceptorHandler();
    await sut.onRequest(requestOptions, handler);
    try {
      await handler.future;
      // ignore: nullable_type_in_catch_clause
    } on dynamic catch (e) {
      expect(e.data, isInstanceOf<DioException>());
    }
  });

  test('CombiningSmartInterceptor test onRequest throws error', () async {
    final interceptor1 = TestInterceptor(
      throws: UnimplementedError('Not implemented'),
    );
    sut..addInterceptor(interceptor1);
    final requestOptions = RequestOptions(path: '');
    final handler = RequestInterceptorHandler();
    await sut.onRequest(requestOptions, handler);
    try {
      await handler.future;
      // ignore: nullable_type_in_catch_clause
    } on dynamic catch (e) {
      expect(e.data, isInstanceOf<DioException>());
      expect(
          (e.data as DioException).error, isInstanceOf<UnimplementedError>());
    }
  });

  test('CombiningSmartInterceptor test onResponse returns error', () async {
    final interceptor1 = TestInterceptor(
      responseResponse: DioException(requestOptions: RequestOptions(path: '/')),
    );
    sut..addInterceptor(interceptor1);

    final response = Response<void>(requestOptions: RequestOptions(path: ''));
    final handler = ResponseInterceptorHandler();
    await sut.onResponse(response, handler);
    try {
      await handler.future;
      // ignore: nullable_type_in_catch_clause
    } on dynamic catch (e) {
      expect(e.data, isInstanceOf<DioException>());
    }
  });

  test('CombiningSmartInterceptor test onResponse throws dio error', () async {
    final interceptor1 = TestInterceptor(
      throws: DioException(requestOptions: RequestOptions(path: '/')),
    );
    sut..addInterceptor(interceptor1);

    final response = Response<void>(requestOptions: RequestOptions(path: ''));
    final handler = ResponseInterceptorHandler();
    await sut.onResponse(response, handler);
    try {
      await handler.future;
      // ignore: nullable_type_in_catch_clause
    } on dynamic catch (e) {
      expect(e.data, isInstanceOf<DioException>());
    }
  });

  test('CombiningSmartInterceptor test onResponse throws error', () async {
    final interceptor1 = TestInterceptor(
      throws: UnimplementedError('Not implemented'),
    );
    sut..addInterceptor(interceptor1);

    final response = Response<void>(requestOptions: RequestOptions(path: ''));
    final handler = ResponseInterceptorHandler();
    await sut.onResponse(response, handler);
    try {
      await handler.future;
      // ignore: nullable_type_in_catch_clause
    } on dynamic catch (e) {
      expect(e.data, isInstanceOf<DioException>());
      expect(
          (e.data as DioException).error, isInstanceOf<UnimplementedError>());
    }
  });
}

class TestInterceptor extends SimpleInterceptor {
  late DateTime onRequestCalled;
  late DateTime onResponseCalled;
  late DateTime onErrorCalled;

  final Object? errorResponse;
  final Object? requestResponse;
  final Object? responseResponse;
  final Object? throws;

  TestInterceptor({
    this.errorResponse,
    this.requestResponse,
    this.responseResponse,
    this.throws,
  });

  @override
  Future onRequest(RequestOptions options) async {
    onRequestCalled = DateTime.now();
    throws?.let((e) => throw e);
    return requestResponse ?? super.onRequest(options);
  }

  @override
  Future onResponse(Response response) async {
    onResponseCalled = DateTime.now();
    throws?.let((e) => throw e);
    return responseResponse ?? super.onResponse(response);
  }

  @override
  Future onError(DioException err) async {
    onErrorCalled = DateTime.now();
    throws?.let((e) => throw e);
    return errorResponse ?? super.onError(err);
  }
}
