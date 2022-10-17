import 'package:flutter_test/flutter_test.dart';
import 'package:icapps_architecture/icapps_architecture.dart';

void main() {
  group('SingleValueCache', () {
    test('Cache should return the cached value in value mode', () async {
      var counter = 0;
      final cache =
          SingleValueCache<String>(provider: () async => 'test ${++counter}');

      expect(await cache.value, 'test 1');
      expect(await cache.value, 'test 1');
    });
    test('Cache should return the cached value in normal mode', () async {
      var counter = 0;
      final cache = SingleValueCache<String>();

      expect(await cache.getOrFetch(() async => 'test ${++counter}'), 'test 1');
      expect(await cache.getOrFetch(() async => 'test ${++counter}'), 'test 1');
    });
    test('Using value in normal mode should throw', () async {
      final cache = SingleValueCache<String>();
      expect(() async => await cache.value, throwsA(isA<ArgumentError>()));
    });
    test('Using getOrFetch in value mode should throw', () async {
      final cache = SingleValueCache<String>(provider: () async => 'test');
      expect(() async => await cache.getOrFetch(() async => 'test2'),
          throwsA(isA<ArgumentError>()));
    });
    test('Cache should return a new value after clear', () async {
      var counter = 0;
      final cache =
          SingleValueCache<String>(provider: () async => 'test ${++counter}');

      expect(await cache.value, 'test 1');
      cache.clear();
      expect(await cache.value, 'test 2');
    });
    test('Cache should return the cached value if not expired', () async {
      var counter = 0;
      final cache = SingleValueCache<String>(
        maxAge: const Duration(seconds: 10),
        provider: () async => 'test ${++counter}',
      );

      expect(await cache.value, 'test 1');
      expect(await cache.value, 'test 1');
    });
    test('Cache should return a new cached value if expired', () async {
      var counter = 0;
      final cache = SingleValueCache<String>(
        maxAge: const Duration(seconds: 0),
        provider: () async => 'test ${++counter}',
      );

      expect(await cache.value, 'test 1');
      await Future.delayed(const Duration(milliseconds: 1));
      expect(await cache.value, 'test 2');
    });
  });
}
