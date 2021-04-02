import 'package:flutter/foundation.dart';
import 'impl/environment_util_stub.dart'
    if (dart.library.io) 'impl/environment_util_io.dart';

/// Returns true if the code is currently being execute by unit tests
bool get isInTest => !kReleaseMode && runInTest;
