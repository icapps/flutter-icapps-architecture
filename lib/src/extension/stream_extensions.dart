import 'dart:async';

extension StreamExtension<T> on Stream<T> {
  /// Transforms the stream to a different stream by mapping events using
  /// [mapper]. The new stream will listen to this stream and fire the
  /// appropriate lifecycle events ([StreamController.onPause],
  /// [StreamController.onResume] and [StreamController.onCancel])
  Stream<S> mapStream<S>(Stream<S> Function(T) mapper) {
    StreamSubscription<S> _listen(Stream<T> input, bool cancelOnError) {
      late StreamSubscription<T> subscription;
      StreamSubscription<S>? innerSubscription;
      final controller = StreamController<S>(
        onPause: () {
          subscription.pause();
          innerSubscription?.pause();
        },
        onResume: () {
          subscription.resume();
          innerSubscription?.resume();
        },
        onCancel: () {
          innerSubscription?.cancel();
          return subscription.cancel();
        },
        sync: true,
      );

      subscription = input.listen((data) {
        innerSubscription?.cancel();
        innerSubscription = mapper(data).listen(controller.add,
            onError: controller.addError,
            onDone: controller.close,
            cancelOnError: cancelOnError);
      },
          onError: controller.addError,
          onDone: controller.close,
          cancelOnError: cancelOnError);

      return controller.stream.listen(null);
    }

    return transform(StreamTransformer(_listen));
  }

  /// Combines this stream with [withStream] and map the resulting events
  /// using [combine]. Note that combine is called every time an event is
  /// emitted from EITHER this or [withStream]. This means that [combine] will
  /// NOT wait until at least one event has been received from both streams
  Stream<R> combine<S, R>(Stream<S> withStream, R Function(T?, S?) combine) {
    StreamSubscription<R> _listen(Stream<T> input, bool cancelOnError) {
      late StreamSubscription<T> thisSubscription;
      late StreamSubscription<S> thatSubscription;
      final controller = StreamController<R>(
        onPause: () {
          thisSubscription.pause();
          thatSubscription.pause();
        },
        onResume: () {
          thisSubscription.resume();
          thatSubscription.resume();
        },
        onCancel: () {
          thisSubscription.cancel();
          return thatSubscription.cancel();
        },
        sync: true,
      );

      T? thisValue;
      S? thatValue;

      thisSubscription = input.listen((data) {
        thisValue = data;
        controller.add(combine(thisValue, thatValue));
      },
          onError: controller.addError,
          onDone: controller.close,
          cancelOnError: cancelOnError);
      thatSubscription = withStream.listen((data) {
        thatValue = data;
        controller.add(combine(thisValue, thatValue));
      },
          onError: controller.addError,
          onDone: controller.close,
          cancelOnError: cancelOnError);

      return controller.stream.listen(null);
    }

    return transform(StreamTransformer(_listen));
  }
}
