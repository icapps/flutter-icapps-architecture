import 'dart:async';

class StreamControllerWithInitialValue<T> implements StreamController<T> {
  late final StreamController<T> _streamController;

  var hasValue = false;

  T? value;

  StreamControllerWithInitialValue({
    this.value,
    void Function()? onListen,
    void Function()? onCancel,
    bool sync = false,
  }) {
    _streamController = StreamController<T>(
      onListen: onListen,
      onCancel: onCancel,
      sync: sync,
    );
  }

  StreamControllerWithInitialValue.broadcast({
    this.value,
    void Function()? onListen,
    void Function()? onCancel,
    bool sync = false,
  }) {
    _streamController = StreamController<T>.broadcast(
      onListen: onListen,
      onCancel: onCancel,
      sync: sync,
    );
  }

  @override
  FutureOr<void> Function()? get onCancel => _streamController.onCancel;

  StreamSubscription<T> listen(
    void Function(T value) onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    final subscription = _streamController.stream.listen(
      (data) {
        value = data;
        hasValue = true;
        onData.call(data);
      },
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
    if (hasValue) onData.call(value!);
    return subscription;
  }

  @override
  set onCancel(FutureOr<void> Function()? onCancelHandler) {
    _streamController.onCancel = onCancelHandler;
  }

  @override
  void Function()? get onListen => _streamController.onListen;

  @override
  set onListen(void Function()? onListenHandler) {
    _streamController.onListen = onListenHandler;
  }

  @override
  void Function()? get onPause => _streamController.onPause;

  @override
  set onPause(void Function()? onPauseHandler) {
    _streamController.onPause = onPauseHandler;
  }

  @override
  void Function()? get onResume => _streamController.onResume;

  @override
  set onResume(void Function()? onResumeHandler) {
    _streamController.onResume = onResumeHandler;
  }

  @override
  void add(T event) => _streamController.add(event);

  @override
  void addError(Object error, [StackTrace? stackTrace]) => _streamController.addError(error, stackTrace);

  @override
  Future addStream(Stream<T> source, {bool? cancelOnError}) => _streamController.addStream(source, cancelOnError: cancelOnError);

  @override
  Future close() => _streamController.close();

  @override
  Future get done => _streamController.done;

  @override
  bool get hasListener => _streamController.hasListener;

  @override
  bool get isClosed => _streamController.isClosed;

  @override
  bool get isPaused => _streamController.isPaused;

  @override
  StreamSink<T> get sink => _streamController.sink;

  @override
  Stream<T> get stream => _streamController.stream;
}
