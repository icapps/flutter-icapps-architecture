abstract class SimpleKeyValueStorage {
  Future<String?> getValue({required String key});

  Future<void> setValue({required String key, required String value});

  Future<bool> hasValue({required String key});

  Future<void> removeValue({required String key});
}
