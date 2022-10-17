import 'dart:async';

/// Simple single-value cache with an optional [maxAge] expiration time for
/// cached items
class SingleValueCache<T> {
  /// The maximum duration a value will be cached. Null means no expiration.
  final Duration? maxAge;

  /// If provided, the cache will get the value by using this [provider]
  /// function when [value] is called and the value is not cached.
  /// If this is not set, [value] cannot be called, and [getOrFetch] must be
  /// used
  final Future<T> Function()? provider;

  Completer<T>? _currentCompleter;
  DateTime? _lastFetch;

  // Used to ensure [_lastFetch] is not updated when clear has been called or
  // when the cache has expired
  var _generationCount = 0;

  SingleValueCache({
    this.maxAge,
    this.provider,
  });

  /// Uses [provider] to get the value if it is not cached, or returns the
  /// cached value if it was. If [provider] is not set, this will throw an
  /// exception
  Future<T> get value async {
    if (provider == null) {
      throw ArgumentError('Cannot call get when provider is not set');
    }
    return _getUsingProvider(provider!);
  }

  /// Gets or computes the value using the provided [provider] function.
  ///
  /// Note: This cannot be called if a provider was set using the constructor.
  /// Attempting to call this method in that case will result in an exception.
  Future<T> getOrFetch(Future<T> Function() provider) async {
    if (this.provider != null) {
      throw ArgumentError(
          'Cannot call getOrFetch when provider is set in the constructor');
    }
    return _getUsingProvider(provider);
  }

  /// Clear the cached value. Calling [value] or [getOrFetch] will cause the
  /// provider to be run again. Calls which are already in progress and not
  /// finished will NOT be cancelled and still receive the value when they
  /// complete
  void clear() {
    _currentCompleter = null;
    _lastFetch = null;
    ++_generationCount;
  }

  Future<T> _getUsingProvider(Future<T> Function() provider) {
    if (_isExpired()) {
      _currentCompleter = null;
    }
    if (_currentCompleter != null) return _currentCompleter!.future;

    final completer = Completer<T>();
    _currentCompleter = completer;

    final generation = ++_generationCount;

    _lastFetch = DateTime.now();
    completer.complete(provider().then((value) {
      if (generation == _generationCount) {
        _lastFetch = DateTime.now();
      }
      return value;
    }));
    return completer.future;
  }

  bool _isExpired() {
    final max = maxAge;
    if (max == null) return false;
    final time = _lastFetch;
    if (time == null) return false; // Never fetched
    return DateTime.now().difference(time) >= max;
  }
}
