import 'package:icapps_architecture/icapps_architecture.dart';

class StreamTestViewModel with ChangeNotifierEx {
  final _counterStream = StreamControllerWithInitialValue<int>.broadcast(value: 0);
  var _current = 0;

  int get current => _current;

  Stream get counterStream => _counterStream.stream;

  void init() {
    addStream();
  }

  void _onCounterUpdated(int value) {
    _current = value;
    logger.d('On increment tapped. Current value: $_current');
    notifyListeners();
  }

  void onIncrementTapped() => _counterStream.add(_current + 1);

  void addStream() => registerDisposeStream(_counterStream.stream.listen(_onCounterUpdated));

  @override
  void dispose() {
    _counterStream.close();
    super.dispose();
  }
}
