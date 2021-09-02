/// Simple abstraction for saving / retrieving string values based on string key
abstract class SimpleKeyValueStorage {
  /// Get the value associated with the given key. Returns null if the value does not exist.
  Future<String?> getValue({required String key});

  /// Sets the value to be associated with the given key
  Future<void> setValue({required String key, required String value});

  /// Check if there is a value associated with the given key
  Future<bool> hasValue({required String key});

  /// Removes the value associated with the given key
  Future<void> removeValue({required String key});
}
