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