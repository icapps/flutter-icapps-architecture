import 'package:icapps_architecture/icapps_architecture.dart';

/// A cache implementation that caches values based on keys
///
/// [maxAge] can be used to control how long values remain cached
/// If [provider] is set, the cache will be filled with values from the provider
/// and [[]] and [get] can be used to retrieve values from the cache.
/// If [provider] is not set, only [getOrFetch] can be used to retrieve values
/// from the cache.
class KeyValueCache<K, V> {
  /// The maximum duration a value will be cached. Null means no expiration.
  final Duration? maxAge;

  /// A provider function that takes the key of the value to be provided
  /// and returns the value future. If this is set, [getOrFetch] cannot be used
  /// but [[]] and [get] can be used
  final Future<V> Function(K key)? provider;

  final _cache = <K, SingleValueCache<V>>{};

  KeyValueCache({
    this.maxAge,
    this.provider,
  });

  /// Convenience operator that delegates to [get]
  Future<V> operator [](K key) => get(key);

  /// Gets the value for the given [key] from the cache or uses the [provider]
  /// set in the constructor to calculate (and store) the value.
  ///
  /// Can only be used if [provider] is set, if not set, this will throw an
  /// exception
  Future<V> get(K key) {
    if (provider == null) {
      throw ArgumentError(
        '[] and get can only be used if a provider is set in the constructor',
      );
    }
    return _cache
        .putIfAbsent(
            key,
            () => SingleValueCache(
                maxAge: maxAge, provider: () => provider!(key)))
        .value;
  }

  /// Gets or computes the value for the provided [key] using the provided
  /// [provider] function and store it in the cache using the provided [key].
  ///
  /// If provider is set in the constructor this method will throw
  Future<V> getOrFetch(K key, Future<V> Function() provider) {
    if (this.provider != null) {
      throw ArgumentError(
        'getOrFetch can only be used if a provider is not in the constructor',
      );
    }
    return _cache
        .putIfAbsent(
          key,
          () => SingleValueCache(maxAge: maxAge),
        )
        .getOrFetch(provider);
  }

  /// Remove a single value from the cache
  void remove(K key) {
    _cache.remove(key);
  }

  /// Clears all cached values
  void clear() {
    _cache.clear();
  }
}
