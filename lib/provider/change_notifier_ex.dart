import 'dart:async';
import 'dart:collection';

import 'package:flutter/foundation.dart';

mixin ChangeNotifierEx implements ChangeNotifier {
  LinkedList<_ListenerEntry>? _listeners = LinkedList<_ListenerEntry>();
  var _disposed = false;
  final _cleanupList = <DisposeAware>[];

  @protected
  bool get disposed => _disposed;

  @override
  @mustCallSuper
  void dispose() {
    assert(_debugAssertNotDisposed());
    _listeners = null;

    _disposed = true;

    _cleanupList
      ..forEach((element) => element.dispose())
      ..clear();
  }

  @protected
  bool get hasListeners {
    assert(_debugAssertNotDisposed());
    return _listeners!.isNotEmpty;
  }

  @override
  void addListener(VoidCallback listener) {
    assert(_debugAssertNotDisposed());
    _listeners!.add(_ListenerEntry(listener));
  }

  @override
  void removeListener(VoidCallback listener) {
    assert(_debugAssertNotDisposed());
    for (final _ListenerEntry entry in _listeners!) {
      if (entry.listener == listener) {
        entry.unlink();
        return;
      }
    }
  }

  void registerDispose(DisposeAware toDispose) {
    if (_disposed) {
      toDispose.dispose();
      return;
    }
    _cleanupList.add(toDispose);
  }

  void registerDisposeStream<T>(StreamSubscription<T> subscription) {
    registerDispose(_StreamDisposer(subscription));
  }

  @protected
  @visibleForTesting
  void notifyListeners() {
    assert(_debugAssertNotDisposed());
    if (_listeners!.isEmpty) return;

    final List<_ListenerEntry> localListeners = List<_ListenerEntry>.from(_listeners!);

    for (final _ListenerEntry entry in localListeners) {
      try {
        if (entry.list != null) entry.listener();
      } catch (exception, stack) {
        FlutterError.reportError(FlutterErrorDetails(
          exception: exception,
          stack: stack,
          library: 'foundation library',
          context: ErrorDescription('while dispatching notifications for $runtimeType'),
          informationCollector: () sync* {
            yield DiagnosticsProperty<ChangeNotifier>(
              'The $runtimeType sending notification was',
              this,
              style: DiagnosticsTreeStyle.errorProperty,
            );
          },
        ));
      }
    }
  }

  bool _debugAssertNotDisposed() {
    assert(() {
      if (_listeners == null) {
        throw FlutterError('A $runtimeType was used after being disposed.\n'
            'Once you have called dispose() on a $runtimeType, it can no longer be used.');
      }
      return true;
    }());
    return true;
  }
}

class _ListenerEntry extends LinkedListEntry<_ListenerEntry> {
  _ListenerEntry(this.listener);

  final VoidCallback listener;
}

abstract class DisposeAware {
  void dispose();
}

class _StreamDisposer implements DisposeAware {
  final StreamSubscription _toDispose;

  _StreamDisposer(this._toDispose);

  @override
  void dispose() {
    _toDispose.cancel();
  }
}
