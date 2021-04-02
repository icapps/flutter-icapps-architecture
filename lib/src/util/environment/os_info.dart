import 'impl/os_info_stub.dart' if (dart.library.io) 'impl/os_info_io.dart';

class OsInfo {
  final int androidSdk;
  final double iosVersion;
  final bool isWeb;
  static OsInfo? _instance;

  static Future<void> init() async {
    final config = await initOsConfig();
    _instance ??=
        OsInfo._internal(config.androidSdk, config.iosVersion, config.isWeb);
  }

  OsInfo._internal(this.androidSdk, this.iosVersion, this.isWeb);

  static OsInfo get instance => _instance!;

  //Android
  static bool get isAtLeastAndroid10 {
    return instance.androidSdk >= 29;
  }

  static bool get isAtLeastPie {
    return instance.androidSdk >= 28;
  }

  //iOS
  static bool get isIOS13OrAbove {
    return instance.iosVersion >= 13;
  }
}
