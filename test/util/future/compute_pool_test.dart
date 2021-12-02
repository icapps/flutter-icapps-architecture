import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:icapps_architecture/icapps_architecture.dart';
import 'package:icapps_architecture/src/util/future/pool/compute_pool_native.dart'
    as native;
import 'package:icapps_architecture/src/util/future/pool/compute_pool_web.dart'
    as web;

String _makeMessage(String message) {
  return 'Hello $message';
}

String _errorMessage(String message) {
  throw SocketException('Hello $message');
}

void main() {
  group('Compute pool tests', () {
    test('Test default pool is native pool', () {
      final pool = ComputePool.createWith(workersCount: 2);
      expect(pool is native.ComputePoolImpl, true);
      pool.shutdown();
    });

    runTestsOnPool(
        'native', () => native.ComputePoolImpl.createWith(workersCount: 2));
    runTestsOnPool(
        'web', () => web.ComputePoolImpl.createWith(workersCount: 2));
  });
}

void runTestsOnPool(String name, ComputePool Function() create) {
  group('Compute pool $name tests', () {
    test('Test create pool', () {
      final pool = create();
      pool.shutdown();
    });
    test('Test pool compute', () async {
      final pool = create();
      final result = await pool.compute(_makeMessage, 'world');

      expect(result, 'Hello world');
      pool.shutdown();
    });
    test('Test pool multiple compute', () async {
      final pool = create();
      final result1Future = pool.compute(_makeMessage, 'world');
      final result2Future = pool.compute(_makeMessage, 'world');

      expect(await result1Future, 'Hello world');
      expect(await result2Future, 'Hello world');
      pool.shutdown();
    });
    test('Test pool multiple compute sequential', () async {
      final pool = create();
      final result1 = await pool.compute(_makeMessage, 'world');
      final result2 = await pool.compute(_makeMessage, 'world');

      expect(result1, 'Hello world');
      expect(result2, 'Hello world');
      pool.shutdown();
    });
    test('Test pool shutdown throws on compute', () {
      final pool = create();
      pool.shutdown();

      expect(() async => pool.compute(_makeMessage, 'world'),
          throwsA(isA<ArgumentError>()));
    });
    test('Test pool shutdown throws on compute after success', () async {
      final pool = create();
      final result = await pool.compute(_makeMessage, 'world');
      pool.shutdown();

      expect(result, 'Hello world');
      expect(() async => pool.compute(_makeMessage, 'world'),
          throwsA(isA<ArgumentError>()));
    });
    test('Test pool propagates errors', () async {
      final pool = create();

      dynamic e;
      try {
        await pool.compute(_errorMessage, 'world');
      } catch (err) {
        e = err;
      }
      expect(e, isA<Exception>());
      pool.shutdown();
    });
  });
}
