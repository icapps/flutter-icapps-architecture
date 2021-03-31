extension ListExtensions<T> on List<T> {
  ///Replaces all data in the list with [newData]
  void replaceAll(List<T> newData) {
    clear();
    addAll(newData);
  }

  /// Sorts the list based on the comparable returned by [by]
  void sortBy<R>(Comparable<R>? by(T item)) {
    sort((a, b) {
      final byA = by(a);
      final byB = by(b);
      if (byA == null) return -1;
      if (byB == null) return 1;
      return _compareValues(byA, byB);
    });
  }

  /// Sorts the list by comparing first comparing using [by] and if the items
  /// are equal, by comparing them using [by2]
  void sortBy2<R>(Comparable<R>? by(T item), Comparable<R>? by2(T item)) {
    sort((a, b) {
      final byA = by(a);
      final byB = by(b);
      if (byA == null) return -1;
      if (byB == null) return 1;
      final result = _compareValues(byA, byB);
      if (result != 0) return result;

      final byA2 = by2(a);
      final byB2 = by2(b);
      if (byA2 == null) return -1;
      if (byB2 == null) return 1;
      return _compareValues(byA2, byB2);
    });
  }
}

int _compareValues<T extends Comparable<dynamic>>(T a, T b) {
  if (identical(a, b)) return 0;
  return a.compareTo(b);
}
