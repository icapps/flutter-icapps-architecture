import 'package:flutter_test/flutter_test.dart';
import 'package:icapps_architecture/icapps_architecture.dart';

void main() {
  group('Key value cache tests', () {
    test('Requesting the same value in value mode should return the same value',
        () async {
      var counter = 0;
      final cache = KeyValueCache<int, String>(
          provider: (key) async => 'Value: $key ${counter++}');

      expect(await cache.get(0), 'Value: 0 0');
      expect(await cache.get(0), 'Value: 0 0');
      expect(await cache[0], 'Value: 0 0');
      expect(await cache[1], 'Value: 1 1');
      expect(await cache.get(1), 'Value: 1 1');
    });
    test(
        'Requesting the same value in provider mode should return the same value',
        () async {
      final cache = KeyValueCache<int, String>();

      var counter = 0;
      expect(await cache.getOrFetch(0, () async => 'Value: ${counter++}'),
          'Value: 0');
      expect(await cache.getOrFetch(0, () async => 'Value: ${counter++}'),
          'Value: 0');
      expect(await cache.getOrFetch(1, () async => 'Value: ${counter++}'),
          'Value: 1');
      expect(await cache.getOrFetch(1, () async => 'Value: ${counter++}'),
          'Value: 1');
    });
    test('Calling get or [] should throw in normal mode', () async {
      final cache = KeyValueCache<int, String>();

      expect(() async => await cache.get(0), throwsA(isA<ArgumentError>()));
      expect(() async => await cache[0], throwsA(isA<ArgumentError>()));
    });
    test('Calling getOrFetch in value mode should throw', () async {
      var counter = 0;
      final cache = KeyValueCache<int, String>(
          provider: (key) async => 'Value: $key ${counter++}');

      expect(
          () async =>
              await cache.getOrFetch(0, () async => 'Value: ${counter++}'),
          throwsA(isA<ArgumentError>()));
    });
    test('Calling remove should remove the value', () async {
      var counter = 0;
      final cache = KeyValueCache<int, String>(
          provider: (key) async => 'Value: $key ${counter++}');

      expect(await cache.get(0), 'Value: 0 0');
      expect(await cache[0], 'Value: 0 0');
      expect(await cache[1], 'Value: 1 1');
      cache.remove(0);
      expect(await cache.get(1), 'Value: 1 1');
      expect(await cache.get(0), 'Value: 0 2');
    });
    test('Calling clear should remove all values', () async {
      var counter = 0;
      final cache = KeyValueCache<int, String>(
          provider: (key) async => 'Value: $key ${counter++}');

      expect(await cache.get(0), 'Value: 0 0');
      expect(await cache[0], 'Value: 0 0');
      expect(await cache[1], 'Value: 1 1');
      cache.clear();
      expect(await cache.get(1), 'Value: 1 2');
      expect(await cache.get(0), 'Value: 0 3');
    });
    test('When a value times out, it should be fetched again', () async {
      var counter = 0;
      final cache = KeyValueCache<int, String>(
          maxAge: const Duration(seconds: 0),
          provider: (key) async => 'Value: $key ${counter++}');

      expect(await cache.get(0), 'Value: 0 0');
      await Future.delayed(const Duration(milliseconds: 1));
      expect(await cache[0], 'Value: 0 1');
      expect(await cache[1], 'Value: 1 2');
    });
  });
}
