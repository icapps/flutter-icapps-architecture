/// Wrapper for storing generic values based on keys. The contained
/// values are all serializable using platform channels
class Bundle {
  final _internalMap = <String, Object?>{};

  /// Creates an empty bundle
  Bundle();

  /// Creates a bundle from the provided map. The map is assumed to be of type:
  /// `Map<Object?, Object?>`. See: [asFlatStructure]
  Bundle.from(Object data) {
    final source = data as Map<Object?, Object?>;
    source.forEach((key, value) {
      if (key != null) {
        _internalMap[key.toString()] = value;
      }
    });
  }

  /// Saves the given value to the map for the given key. If the value is null,
  /// the previous mapping is removed (if any)
  void putBoolean(String key, bool? value) {
    if (value == null) {
      _internalMap.remove(key);
    } else {
      _internalMap[key] = value;
    }
  }

  /// Saves the given value to the map for the given key. If the value is null,
  /// the previous mapping is removed (if any)
  void putInt(String key, int? value) {
    if (value == null) {
      _internalMap.remove(key);
    } else {
      _internalMap[key] = value;
    }
  }

  /// Saves the given value to the map for the given key. If the value is null,
  /// the previous mapping is removed (if any)
  void putString(String key, String? value) {
    if (value == null) {
      _internalMap.remove(key);
    } else {
      _internalMap[key] = value;
    }
  }

  /// Saves the given value to the map for the given key. If the value is null,
  /// the previous mapping is removed (if any)
  void putBundle(String key, Bundle? bundle) {
    if (bundle == null) {
      _internalMap.remove(key);
    } else {
      _internalMap[key] = bundle;
    }
  }

  /// Saves the given value to the map for the given key. If the value is null,
  /// the previous mapping is removed (if any)
  void putDouble(String key, double? value) {
    if (value == null) {
      _internalMap.remove(key);
    } else {
      _internalMap[key] = value;
    }
  }

  /// Saves the given value to the map for the given key. If the value is null,
  /// the previous mapping is removed (if any)
  void putStringList(String key, List<String>? values) {
    if (values == null) {
      _internalMap.remove(key);
    } else {
      _internalMap[key] = values;
    }
  }

  /// Removes the mapping for the given key (if any)
  void remove(String key) {
    _internalMap.remove(key);
  }

  /// Force-gets the value for the given key, throws if null or wrong type
  bool getBoolean(String key) => _internalMap[key] as bool;

  /// Checks if the bundle contains a value with the given key
  bool hasKey(String key) => _internalMap.containsKey(key);

  /// Force-gets the value for the given key, throws if null or wrong type
  int getInt(String key) => _internalMap[key] as int;

  /// Force-gets the value for the given key, throws if null or wrong type
  String getString(String key) => _internalMap[key] as String;

  /// Force-gets the value for the given key, throws if null or wrong type
  double getDouble(String key) => _internalMap[key] as double;

  /// Force-gets the value for the given key, throws if null or wrong type
  List<String> getStringList(String key) =>
      (_internalMap[key] as List<Object?>).map((e) => e.toString()).toList();

  /// Force-gets the value for the given key, throws if null or wrong type
  Bundle getBundle(String key) {
    final value = _internalMap[key];
    if (value is Bundle) return value;
    if (value is Map<Object?, Object?>) return Bundle.from(value);

    throw FormatException('$value is not a bundle');
  }

  /// Gets the value for the given key, returns null if null or wrong type
  bool? optBoolean(String key) {
    final value = _internalMap[key];
    return value is bool ? value : null;
  }

  /// Gets the value for the given key, returns null if null or wrong type
  int? optInt(String key) {
    final value = _internalMap[key];
    return value is int ? value : null;
  }

  /// Gets the value for the given key, returns null if null or wrong type
  String? optString(String key) {
    final value = _internalMap[key];
    return value is String ? value : null;
  }

  /// Gets the value for the given key, returns null if null or wrong type
  double? optDouble(String key) {
    final value = _internalMap[key];
    return value is double ? value : null;
  }

  /// Gets the value for the given key, returns null if null or wrong type
  Bundle? optBundle(String key) {
    final value = _internalMap[key];
    if (value is Bundle) return value;
    if (value is Map<Object?, Object?>) return Bundle.from(value);

    return null;
  }

  /// Gets the value for the given key, returns null if null or wrong type
  List<String>? optStringList(String key) {
    final value = _internalMap[key];
    if (value is List<Object?>) return value.map((e) => e.toString()).toList();

    return null;
  }

  /// Serializes the bundle to a flat structure that is used by the restoration
  /// framework. See [RestorationMixin]
  Map<Object?, Object?> asFlatStructure() => _internalMap.map((key, value) {
        if (value is Bundle) {
          return MapEntry<Object?, Object?>(key, value.asFlatStructure());
        } else {
          return MapEntry<Object?, Object?>(key, value);
        }
      });
}
