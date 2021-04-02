import 'package:flutter/cupertino.dart';

import 'impl/os_info_stub.dart' if (dart.library.io) 'impl/os_info_io.dart';

/// Helper class containing information about the OS that the app
/// is currently running on
@immutable
class OsInfo {
  /// The android sdk version int (if the app is running native). Eg: 21
  final int androidSdk;

  /// The ios major and minor version (if the app is running native). Eg: 14.4
  final double iosVersion;

  /// Indicates that this is a non-native application
  final bool isWeb;
  static OsInfo? _instance;

  /// Returns true if the app is running natively on android
  bool get isAndroid => androidSdk > 0;

  /// Returns true if the app is running natively on ios
  bool get isIOS => iosVersion > 0;

  /// Returns true if the app is running natively on android 10 and higher
  bool get isAtLeastAndroid10 => androidSdk >= 29;

  /// Returns true if the app is running natively on android P and higher
  bool get isAtLeastPie => androidSdk >= 28;

  /// Returns true if the app is running natively on at least ios 13
  bool get isIOS13OrAbove => iosVersion >= 13;

  /// Initializes the os info
  static Future<void> init() async {
    if (_instance == null) {
      final config = await initOsConfig();
      _instance ??= OsInfo(config.androidSdk, config.iosVersion, config.isWeb);
    }
  }

  @visibleForTesting
  OsInfo(this.androidSdk, this.iosVersion, this.isWeb);

  /// Returns the [OsInfo] instance. Call [init] first!
  static OsInfo get instance => _instance!;
}
