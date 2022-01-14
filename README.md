# Flutter icapps architecture
Architecture components used in icapps flutter projects

[![Build Status](https://travis-ci.com/icapps/flutter-icapps-architecture.svg?branch=main)](https://travis-ci.com/icapps/flutter-icapps-architecture)
[![Coverage Status](https://coveralls.io/repos/github/icapps/flutter-icapps-architecture/badge.svg)](https://coveralls.io/github/icapps/flutter-icapps-architecture)
[![pub package](https://img.shields.io/pub/v/icapps-architecture.svg)](https://pub.dartlang.org/packages/icapps-architecture)

### Custom Error handling
#### Localized error
This error can be used to map a localization key/localization to an Exception. So when the exception is thrown you don't have to do an extra mapping to get the correct text.

#### Network Error
A NetworkError is used simplify the DioErrors. A NetworkError is also a LocalizedError so it is easy to get the correct localization/localizationKey

### Extensions

#### Context
- `bool isAndroidTheme` (Returns true if the current theme is targeting the android platform)
- `bool isIOSTheme` (Returns true if the current theme is targeting the ios platform)
- `bool isTablet` (Returns true if the device indicates it is a tablet.)
- `bool isLandscape` (Returns true if the device indicates it is in landscape mode.)

#### MediaQueryData
- `bool isTablet` (Returns true if the device indicates it is a tablet.)
- `bool isLandscap` (Returns true if the device indicates it is in landscape mode.)

#### Iterable<T>
- `int count(bool Function(T) where)` (Counts all elements for which [where] returns true)
- `E sum<E extends num>(E Function(T) valueProducer)` (Sums the result of [valueProvider] for each item)
- `T? find(bool Function(T) where)` (Finds the first item that matches [where], if no such item could be found)
- `bool all(bool Function(T) where)` (Returns `true` if every item matches [where])
- `Map<S, T> associateBy<S>(S Function(T) key)` (Create a map by mapping every element using [key]. Duplicate values discarded)
- `Tuple2<List<T>, List<T>> split(bool Function(T) on)` (Splits the elements according to [on]. Items for which [on] is true will be stored in [Tuple2.item1], other items in [Tuple2.item2])
- `Iterable<R> mapIndexed<R>(R Function(int, T) mapper)` (Same as [Iterable.map] except that the [mapper] function also receives the index of the item being mapped)
- `void forEachIndexed(Function(int, T) f)` (Same as [Iterable.foreach] except that the [f] function also receives the index of the item)

##### Iterable<Iterable<T>>
- `List<T> flatten()` (Flattens the list of lists to a single flat list of items)

#### List<T>
- `void replaceAll(List<T> newData)` (Replaces all data in the list with [newData])
- `void replaceWhere(bool Function(T) where, T newData, {int? count})` (Replaces all items that matches where with [newData])
- `void sortBy<R>(Comparable<R>? by(T item), {bool ascending = true})` (Sorts the list based on the comparable returned by [by]. By default the sorting is [ascending])
- `void sortBy2<R, V>( Comparable<R>? by(T item), Comparable<V>? by2(T item), {bool ascending = true})` (Sorts the list by comparing first comparing using [by] and if the items are equal, by comparing them using [by2]. By default the sorting is [ascending])

#### Map<K?,V>
- `Map<K, V> removeNullKeys()` (Removes all null keys from the map)

#### Map<K,V?>
- `Map<K, V> removeNullValues()` (Removes all null values from the map)

#### T?
- `R? let<R>(R? Function(T) lambda)` (Execute the given lambda and return a result)

#### String?
- `bool isNullOrEmpty` (Will return if the string is null or empty)
- `bool isNotNullOrEmpty` (Will return if the string is not null and not empty)

### Interceptor
#### CombiningSmartInterceptor
Base class for simple [Dio] interceptors to be used in conjunction with CombiningSmartInterceptor
Upon returning an instance of [DioError] from [onRequest] or [onResponse], the error interceptors will NOT be called

### ChangeNotifierEx
Extended version of the foundation's [ChangeNotifier].
Has helper methods to determine if it has been disposed ([disposed]) and convenience methods to register listeners that will be cleaned up when the change notifier is disposed [registerDispose()] and [registerDisposeStream()]

### Routes
#### FadeInRoute
Page route that fades in the child page

### Theme
#### BaseThemeData
Holder class for the theme base. Fills in basic shared properties
- `baseTheme` (Gets the base theme to use to build new themes on)
- `PageTransitionsBuilder getCorrectPageTransitionBuilder(OsInfo info)` (Builds the correct page transition based on the current OS)

### Connectivity
#### ConnectivityHelper
Helper to determine if a device has connectivity
- `Future<bool> hasConnection()` (Returns true if the device is connected to an IP network)
- `Stream<bool> monitorConnection()` (Returns a stream that monitors the connectivity state of the device)

### Environment global variables
- `bool isInTest` (Returns true if the code is currently being execute by unit tests)
- `bool isInRelease` (Returns true if the current code is executing in release mode)
- `bool isInDebug` (Returns true if the current code is executing in debug mode)
- `bool isInProfile` (Returns true if the current code is executing in profile mode)

### OsInfo
- `int androidSdk` (The android sdk version int (if the app is running native). Eg: 21)
- `double iosVersion` (The ios major and minor version (if the app is running native). Eg: 14.4)
- `bool isWeb` (Indicates that this is a non-native application)
- `bool isAndroid` (Returns true if the app is running natively on android)
- `bool isIOS` (Returns true if the app is running natively on ios)
- `bool isAtLeastAndroid10` (Returns true if the app is running natively on android 10 and higher)
- `bool isAtLeastPie` (Returns true if the app is running natively on android P and higher)
- `bool isIOS13OrAbove` (Returns true if the app is running natively on at least ios 13)
- `Future<void> init` (Initializes the os info)
- `bool isDeviceAndroid` (Platform.isAndroid)
- `bool isDeviceIOS` (Platform.isIOS)

### ComputePool
A pool of isolate workers that will handle passed work.
Using a compute pool will greatly reduce the dart isolate startup overhead
- `ComputePool.createWith({int workersCount = 2})` (Create a new compute pool with the requested number of worker isolates)
- `void shutdown()` (Shuts down the compute pool. Submitting new work will result in an error future being returned)
- `ComputePool.createWith({int workersCount = 2})` (Submit a task to be executed on an isolate in this pool)

### FutureHelpers
Waits for n futures and returns a future containing a [TupleN] with the results for n futures
- `await2`
- `await3`
- `await4`
- `await5`
- `await6`
- `await7`

### Logger
Send logs, via the `staticLogger` or `logger`
You can specific when you you want to actualy print someting using the `Level`
- `void debug(String message)`
- `void info(String message)`
- `void warning(String message)`
- `void error(String message, {dynamic error, StackTrace? trace})`

### SharedPreferenceStorage
Utility class to facilitate storing shared preferences
- `Future<void> saveString({required String key, required String value})` (Saves the given string [value] to the storage with [key])
- `Future<void> saveBoolean({required String key, required bool value})` (Saves the given boolean [value] to the storage with [key])
- `Future<void> saveInt({required String key, required int value})` (Saves the given integer [value] to the storage with [key])
- `Future<void> saveDouble({required String key, required double value})` (Saves the given double [value] to the storage with [key])
- `String? getString(String key)` (Retrieves the stored string value for [key]/ Returns null if the value is not found)
- `bool? getBoolean(String key)` (Retrieves the stored boolean value for [key]. Returns null if the value is not found)
- `int? getInt(String key)` (Retrieves the stored integer value for [key]. Returns null if the value is not found)
- `double? getDouble(String key)` (Retrieves the stored double value for [key]. Returns null if the value is not found)
- `Future<void> deleteKey(String key)` (Deletes the value stored for [key])
- `bool containsKey(String key)` (Returns true if there is a value for [key])

### Restorable state
#### Bundle
Wrapper for storing generic values based on keys. The contained values are all serializable using platform channels
- `Bundle.from(Object data)` (Creates a bundle from the provided map. The map is assumed to be of type: `Map<Object?, Object?>`. See: [asFlatStructure])
- `void putBoolean(String key, bool? value)` (Saves the given value to the map for the given key. If the value is null, the previous mapping is removed (if any))
- `void putInt(String key, int? value)` (Saves the given value to the map for the given key. If the value is null, the previous mapping is removed (if any))
- `void putString(String key, String? value)` (Saves the given value to the map for the given key. If the value is null, the previous mapping is removed (if any))
- `void putBundle(String key, Bundle? bundle)` (Saves the given value to the map for the given key. If the value is null, the previous mapping is removed (if any))
- `void putDouble(String key, double? value)` (Saves the given value to the map for the given key. If the value is null, the previous mapping is removed (if any))
- `void putStringList(String key, List<String>? values)` (Saves the given value to the map for the given key. If the value is null, the previous mapping is removed (if any))
- `void remove(String key)` (Removes the mapping for the given key (if any))
- `bool getBoolean(String key)` (Force-gets the value for the given key, throws if null or wrong type)
- `bool hasKey(String key)` (Checks if the bundle contains a value with the given key)
- `int getInt(String key)` (Force-gets the value for the given key, throws if null or wrong type)
- `String getString(String key)` (Force-gets the value for the given key, throws if null or wrong type)
- `double getDouble(String key)` (Force-gets the value for the given key, throws if null or wrong type)
- `List<String> getStringList(String key)` (Force-gets the value for the given key, throws if null or wrong type)
- `Bundle getBundle(String key)` (Force-gets the value for the given key, throws if null or wrong type)
- `bool? optBoolean(String key)` (Gets the value for the given key, returns null if null or wrong type)
- `int? optInt(String key)` (Gets the value for the given key, returns null if null or wrong type)
- `String? optString(String key)` (Gets the value for the given key, returns null if null or wrong type)
- `double? optDouble(String key)` (Gets the value for the given key, returns null if null or wrong type)
- `Bundle? optBundle(String key)` (Gets the value for the given key, returns null if null or wrong type)
- `List<String>? optStringList(String key)` (Gets the value for the given key, returns null if null or wrong type)
- `Map<Object?, Object?> asFlatStructure() => _internalMap.map((key, value)` (Serializes the bundle to a flat structure that is used by the restoration framework. See [RestorationMixin])

### Restorable
Base class for restorable change view models
- `void restoreState(Bundle? data)` (Called when the system is restoring or creating a new instance. If the passed bundle is null, it is assumed to be a clean restoration without previous state)
- `void saveState(Bundle target)` (Called when the system needs to prepare data for later restoration. You should save all relevant required data to restore from later. Keep in mind that the system has only a limited amount of space reserved for this data: avoid storing large objects.)

#### RestorableViewModelHolder
Holder class for restorable view models, use with the flutter restoration
Provies you with some helper functions to make sure you can

### SimpleKeyValueStorage
- `Future<String?> getValue({required String key})` (Get the value associated with the given key. Returns null if the value does not exist.)
- `Future<void> setValue({required String key, required String value})` (Sets the value to be associated with the given key)
- `Future<bool> hasValue({required String key})`` (Check if there is a value associated with the given key)
- `Future<void> removeValue({required String key})` (Removes the value associated with the given key)