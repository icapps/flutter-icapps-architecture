import 'package:shared_preferences/shared_preferences.dart';

/// Utility class to facilitate storing shared preferences
abstract class SharedPreferenceStorage {

  /// Create a new instance of SharedPreferenceStorage
  factory SharedPreferenceStorage(SharedPreferences preferences) =>
      _SharedPreferenceStorage(preferences);

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
  String? getString(String key);

  /// Retrieves the stored boolean value for [key].
  /// Returns null if the value is not found
  bool? getBoolean(String key);

  /// Retrieves the stored integer value for [key].
  /// Returns null if the value is not found
  int? getInt(String key);

  /// Retrieves the stored double value for [key].
  /// Returns null if the value is not found
  double? getDouble(String key);

  /// Deletes the value stored for [key]
  Future<void> deleteKey(String key);

  /// Returns true if there is a value for [key]
  bool containsKey(String key);
}

class _SharedPreferenceStorage implements SharedPreferenceStorage {
  final SharedPreferences _sharedPreferences;

  _SharedPreferenceStorage(this._sharedPreferences);

  @override
  Future<void> saveString({required String key, required String value}) =>
      _sharedPreferences.setString(key, value);

  @override
  Future<void> saveBoolean({required String key, required bool value}) =>
      _sharedPreferences.setBool(key, value);

  @override
  Future<void> saveInt({required String key, required int value}) =>
      _sharedPreferences.setInt(key, value);

  @override
  Future<void> saveDouble({required String key, required double value}) =>
      _sharedPreferences.setDouble(key, value);

  @override
  String? getString(String key) => _sharedPreferences.getString(key);

  @override
  bool? getBoolean(String key) => _sharedPreferences.getBool(key);

  @override
  int? getInt(String key) => _sharedPreferences.getInt(key);

  @override
  double? getDouble(String key) => _sharedPreferences.getDouble(key);

  @override
  Future<void> deleteKey(String key) => _sharedPreferences.remove(key);

  @override
  bool containsKey(String key) => _sharedPreferences.containsKey(key);
}
