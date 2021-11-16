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

extension NullStringExtension<T> on String? {
  /// Will return if the string is null or empty
  bool get isNullOrEmpty => this == null || this?.isEmpty == true;

  /// Will return if the string is not null and not empty
  bool get isNotNullAndNotEmpty => !isNullOrEmpty;
}
