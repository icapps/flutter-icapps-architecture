import 'dart:async';

import 'pool/compute_pool_native.dart'
    if (dart.library.js) 'pool/compute_pool_web.dart';

typedef ComputeCallback<Q, R> = FutureOr<R> Function(Q message);

/// A pool of isolate workers that will handle passed work.
/// Using a compute pool will greatly reduce the dart isolate startup overhead
///
/// Compute pools will eagerly spin up the specified number of workers but will
/// ensure that work can still be submitted in the startup phase.
///
/// Note: Isolates are only destroyed when calling shutdown
/// Note: On web this falls back to using [scheduleMicrotask]
abstract class ComputePool {
  /// Create a new compute pool with the requested number of worker isolates
  factory ComputePool.createWith({int workersCount = 2}) =>
      ComputePoolImpl.createWith(workersCount: workersCount);

  /// Shuts down the compute pool. Submitting new work will result in an
  /// error future being returned
  ///
  /// Note: Non-started work may be cancelled (but this is not guaranteed)
  /// and the future will return an error
  /// Note: Currently running work may or may not be cancelled with an error
  void shutdown();

  /// Submit a task to be executed on an isolate in this pool
  Future<R> compute<Q, R>(ComputeCallback<Q, R> callback, Q message,
      {String? debugLabel});
}
