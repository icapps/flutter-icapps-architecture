/// Extensions for nullable types
extension NullExtension2<T> on T? {
  /// Execute the given lambda and return a result
  ///
  /// ```dart
  /// someNullableInt.let((notNull) => notNull * 2) ?? 0;
  /// ```
  R? let<R>(R? Function(T) lambda) {
    final copy = this;
    if (copy == null) return null;
    return lambda(copy);
  }
}
