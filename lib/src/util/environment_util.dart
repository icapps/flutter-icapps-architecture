import 'package:flutter/foundation.dart';
import 'environment/environment_util_stub.dart'
    if (dart.library.io) 'environment/environment_util_io.dart';

bool get isInTest => !kReleaseMode && runInTest;
