import 'dart:async';

import 'package:computer/computer.dart';
import 'package:icapps_architecture/src/util/future/compute_pool.dart';

class ComputePoolImpl implements ComputePool {
  final Future<Computer> _computerFuture;
  final _pending = <_Task>[];
  Computer? _computer;
  var _shutdown = false;

  factory ComputePoolImpl.createWith({int workersCount = 2}) =>
      ComputePoolImpl._(_createComputer(workersCount: workersCount));

  ComputePoolImpl._(this._computerFuture) {
    _computerFuture.then((value) {
      _computer = value;
      if (_shutdown) {
        value.turnOff();
        _computer = null;
        _pending.clear();
      } else {
        _schedulePendingTasks();
      }
    });
  }

  @override
  void shutdown() {
    _shutdown = true;
    _computer?.turnOff();
    _computer = null;
  }

  @override
  Future<R> compute<Q, R>(ComputeCallback<Q, R> callback, Q message,
      {String? debugLabel}) {
    if (_shutdown)
      return Future.error(ArgumentError('Compute pool has been shut down'));

    final computer = _computer;
    if (computer != null) return computer.compute(callback, param: message);

    final completer = Completer<R>();
    final task = _Task(task: callback, param: message, completer: completer);
    _pending.add(task);

    return completer.future;
  }

  void _schedulePendingTasks() {
    final computer = _computer!;

    for (final task in _pending) {
      computer
          .compute<dynamic, dynamic>(task.task, param: task.param)
          .then(task.completer.complete, onError: task.completer.completeError);
    }
    _pending.clear();
  }
}

Future<Computer> _createComputer({required int workersCount}) async {
  final c = Computer.create();
  await c.turnOn(workersCount: 2);
  return c;
}

class _Task {
  final Function task;
  final dynamic param;
  final Completer completer;

  _Task({
    required this.task,
    required this.completer,
    this.param,
  });
}
