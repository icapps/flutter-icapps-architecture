import 'package:icapps_architecture/src/extension/iterable_extensions.dart';

extension ListExtensions<T> on List<T> {
  ///Replaces all data in the list with [newData]
  void replaceAll(List<T> newData) {
    clear();
    addAll(newData);
  }

  ///Replaces first item that matches where with [newData]
  void replaceFirstWhere(bool Function(T) where, T newData) {
    final result = find(where);
    if (result == null) return;
    final index = indexOf(result);
    removeAt(index);
    insert(index, newData);
  }

  ///Replaces all items that matches where  with [newData]
  void replaceWhere(bool Function(T) where, T newData) {
    final whereResult = this.where(where);
    print(whereResult);
    whereResult.forEach((result) {
      if (result == null) return;
      final index = indexOf(result);
      removeAt(index);
      insert(index, newData);
    });
  }

  /// Sorts the list based on the comparable returned by [by]. By default
  /// the sorting is [ascending]
  void sortBy<R>(Comparable<R>? by(T item), {bool ascending = true}) {
    sort((a, b) {
      final byA = by(a);
      final byB = by(b);
      if (byA == null) return ascending ? -1 : 1;
      if (byB == null) return ascending ? 1 : -1;
      return _compareValues(byA, byB, ascending);
    });
  }

  /// Sorts the list by comparing first comparing using [by] and if the items
  /// are equal, by comparing them using [by2]. By default
  /// the sorting is [ascending]
  void sortBy2<R>(
    Comparable<R>? by(T item),
    Comparable<R>? by2(T item), {
    bool ascending = true,
  }) {
    sort((a, b) {
      final byA = by(a);
      final byB = by(b);
      if (byA == null && byB != null) return ascending ? -1 : 1;
      if (byB == null && byA != null) return ascending ? 1 : -1;
      if (byA != null && byB != null) {
        final result = _compareValues(byA, byB, ascending);
        if (result != 0) return result;
      }

      final byA2 = by2(a);
      final byB2 = by2(b);
      if (byA2 == null && byB2 == null) return 0;
      if (byA2 == null) return ascending ? -1 : 1;
      if (byB2 == null) return ascending ? 1 : -1;
      return _compareValues(byA2, byB2, ascending);
    });
  }
}

int _compareValues<T extends Comparable<dynamic>>(T a, T b, bool ascending) {
  if (identical(a, b)) return 0;
  if (ascending) return a.compareTo(b);
  return -a.compareTo(b);
}
