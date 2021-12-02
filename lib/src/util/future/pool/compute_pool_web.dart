import 'dart:async';

import 'package:icapps_architecture/src/util/future/compute_pool.dart';

class ComputePoolImpl implements ComputePool {
  factory ComputePoolImpl.createWith({int workersCount = 2}) =>
      ComputePoolImpl._();

  var _shutdown = false;

  ComputePoolImpl._();

  @override
  Future<R> compute<Q, R>(ComputeCallback<Q, R> callback, Q message,
      {String? debugLabel}) {
    if (_shutdown)
      return Future.error(ArgumentError('Compute pool has been shut down'));

    final completer = Completer<R>();
    scheduleMicrotask(() {
      try {
        completer.complete(callback(message));
      } catch (e, trace) {
        completer.completeError(e, trace);
      }
    });
    return completer.future;
  }

  @override
  void shutdown() {
    _shutdown = true;
  }
}
