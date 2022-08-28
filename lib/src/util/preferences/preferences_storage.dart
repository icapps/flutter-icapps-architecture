import 'package:icapps_architecture/src/util/storage/simple_key_value_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Utility class to facilitate storing shared preferences
abstract class SharedPreferenceStorage implements SimpleKeyValueStorage {
  /// Create a new instance of SharedPreferenceStorage
  factory SharedPreferenceStorage(Future<SharedPreferences> preferences) =
      _SharedPreferenceStorage;

  /// Saves the given string [value] to the storage with [key]
  Future<void> saveString({required String key, required String value});

  /// Saves the given boolean [value] to the storage with [key]
  Future<void> saveBoolean({required String key, required bool value});

  /// Saves the given integer [value] to the storage with [key]
  Future<void> saveInt({required String key, required int value});

  /// Saves the given double [value] to the storage with [key]
  Future<void> saveDouble({required String key, required double value});

  /// Retrieves the stored string value for [key].
  /// Returns null if the value is not found
  Future<String?> getString(String key);

  /// Retrieves the stored boolean value for [key].
  /// Returns null if the value is not found
  Future<bool?> getBoolean(String key);

  /// Retrieves the stored integer value for [key].
  /// Returns null if the value is not found
  Future<int?> getInt(String key);

  /// Retrieves the stored double value for [key].
  /// Returns null if the value is not found
  Future<double?> getDouble(String key);

  /// Deletes the value stored for [key]
  Future<void> deleteKey(String key);

  /// Returns true if there is a value for [key]
  Future<bool> containsKey(String key);
}

class _SharedPreferenceStorage implements SharedPreferenceStorage {
  final Future<SharedPreferences> _sharedPreferences;

  _SharedPreferenceStorage(this._sharedPreferences);

  @override
  Future<void> saveString({required String key, required String value}) =>
      _sharedPreferences.then((prefs) => prefs.setString(key, value));

  @override
  Future<void> saveBoolean({required String key, required bool value}) =>
      _sharedPreferences.then((prefs) => prefs..setBool(key, value));

  @override
  Future<void> saveInt({required String key, required int value}) =>
      _sharedPreferences.then((prefs) => prefs..setInt(key, value));

  @override
  Future<void> saveDouble({required String key, required double value}) =>
      _sharedPreferences.then((prefs) => prefs.setDouble(key, value));

  @override
  Future<String?> getString(String key) =>
      _sharedPreferences.then((prefs) => prefs.getString(key));

  @override
  Future<bool?> getBoolean(String key) =>
      _sharedPreferences.then((prefs) => prefs.getBool(key));

  @override
  Future<int?> getInt(String key) =>
      _sharedPreferences.then((prefs) => prefs.getInt(key));

  @override
  Future<double?> getDouble(String key) =>
      _sharedPreferences.then((prefs) => prefs.getDouble(key));

  @override
  Future<void> deleteKey(String key) =>
      _sharedPreferences.then((prefs) => prefs.remove(key));

  @override
  Future<bool> containsKey(String key) =>
      _sharedPreferences.then((prefs) => prefs.containsKey(key));

  @override
  Future<String?> getValue({required String key}) => getString(key);

  @override
  Future<bool> hasValue({required String key}) => containsKey(key);

  @override
  Future<void> removeValue({required String key}) => deleteKey(key);

  @override
  Future<void> setValue({required String key, required String value}) =>
      saveString(key: key, value: value);
}
