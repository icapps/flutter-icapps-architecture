extension ListExtensions<T> on List<T> {
  ///Replaces all data in the list with [newData]
  void replaceAll(List<T> newData) {
    clear();
    addAll(newData);
  }

  ///Replaces all items that matches where  with [newData]
  void replaceWhere(bool Function(T) where, T newData, {int? count}) {
    final replaceCount = count ?? length;
    var currentReplaceCount = 0;
    for (var i = 0; i < length; ++i) {
      if (where(this[i])) {
        this[i] = newData;
        ++currentReplaceCount;
      }
      if (currentReplaceCount >= replaceCount) break;
    }
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
  void sortBy2<R, V>(
    Comparable<R>? by(T item),
    Comparable<V>? by2(T item), {
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
