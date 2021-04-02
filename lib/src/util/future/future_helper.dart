import 'package:tuple/tuple.dart';

/// Waits for both futures and returns a future containing a [Tuple2] with the
/// results of both futures
Future<Tuple2<A, B>> await2<A, B>(Future<A> a, Future<B> b) {
  return Future.wait([a, b]).then((values) => Tuple2.fromList(values));
}

/// Waits for all futures and returns a future containing a [Tuple3] with the
/// results of all futures
Future<Tuple3<A, B, C>> await3<A, B, C>(
  Future<A> a,
  Future<B> b,
  Future<C> c,
) {
  return Future.wait([a, b, c]).then((values) => Tuple3.fromList(values));
}

/// Waits for all futures and returns a future containing a [Tuple4] with the
/// results of all futures
Future<Tuple4<A, B, C, D>> await4<A, B, C, D>(
  Future<A> a,
  Future<B> b,
  Future<C> c,
  Future<D> d,
) {
  return Future.wait([a, b, c, d]).then((values) => Tuple4.fromList(values));
}

/// Waits for all futures and returns a future containing a [Tuple5] with the
/// results of all futures
Future<Tuple5<A, B, C, D, E>> await5<A, B, C, D, E>(
  Future<A> a,
  Future<B> b,
  Future<C> c,
  Future<D> d,
  Future<E> e,
) {
  return Future.wait([a, b, c, d, e]).then((values) => Tuple5.fromList(values));
}

/// Waits for all futures and returns a future containing a [Tuple6] with the
/// results of all futures
Future<Tuple6<A, B, C, D, E, F>> await6<A, B, C, D, E, F>(Future<A> a,
    Future<B> b, Future<C> c, Future<D> d, Future<E> e, Future<F> f) {
  return Future.wait([a, b, c, d, e, f])
      .then((values) => Tuple6.fromList(values));
}

/// Waits for all futures and returns a future containing a [Tuple7] with the
/// results of all futures
Future<Tuple7<A, B, C, D, E, F, G>> await7<A, B, C, D, E, F, G>(
  Future<A> a,
  Future<B> b,
  Future<C> c,
  Future<D> d,
  Future<E> e,
  Future<F> f,
  Future<G> g,
) {
  return Future.wait([a, b, c, d, e, f, g])
      .then((values) => Tuple7.fromList(values));
}
