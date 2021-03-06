// Mocks generated by Mockito 5.2.0 from annotations
// in icapps_architecture/test/util/logging/logging_test.dart.
// Do not manually edit this file.

import 'package:dio/dio.dart' as _i3;
import 'package:icapps_architecture/icapps_architecture.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types

/// A class which mocks [Log].
///
/// See the documentation for Mockito's code generation for more information.
class MockLog extends _i1.Mock implements _i2.Log {
  @override
  void verbose(String? message) =>
      super.noSuchMethod(Invocation.method(#verbose, [message]),
          returnValueForMissingStub: null);
  @override
  void debug(String? message) =>
      super.noSuchMethod(Invocation.method(#debug, [message]),
          returnValueForMissingStub: null);
  @override
  void info(String? message) =>
      super.noSuchMethod(Invocation.method(#info, [message]),
          returnValueForMissingStub: null);
  @override
  void warning(String? message) =>
      super.noSuchMethod(Invocation.method(#warning, [message]),
          returnValueForMissingStub: null);
  @override
  void error(String? message, {dynamic error, StackTrace? trace}) =>
      super.noSuchMethod(
          Invocation.method(#error, [message], {#error: error, #trace: trace}),
          returnValueForMissingStub: null);
  @override
  void v(String? message) =>
      super.noSuchMethod(Invocation.method(#v, [message]),
          returnValueForMissingStub: null);
  @override
  void d(String? message) =>
      super.noSuchMethod(Invocation.method(#d, [message]),
          returnValueForMissingStub: null);
  @override
  void i(String? message) =>
      super.noSuchMethod(Invocation.method(#i, [message]),
          returnValueForMissingStub: null);
  @override
  void w(String? message) =>
      super.noSuchMethod(Invocation.method(#w, [message]),
          returnValueForMissingStub: null);
  @override
  void e(String? message, {dynamic error, StackTrace? trace}) =>
      super.noSuchMethod(
          Invocation.method(#e, [message], {#error: error, #trace: trace}),
          returnValueForMissingStub: null);
  @override
  void logNetworkError(_i2.NetworkError? error) =>
      super.noSuchMethod(Invocation.method(#logNetworkError, [error]),
          returnValueForMissingStub: null);
  @override
  void logNetworkRequest(_i3.RequestOptions? request) =>
      super.noSuchMethod(Invocation.method(#logNetworkRequest, [request]),
          returnValueForMissingStub: null);
  @override
  void logNetworkResponse(_i3.Response<dynamic>? response) =>
      super.noSuchMethod(Invocation.method(#logNetworkResponse, [response]),
          returnValueForMissingStub: null);
}
