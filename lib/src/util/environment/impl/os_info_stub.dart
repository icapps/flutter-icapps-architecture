Future<OsConfigInfo> initOsConfig() => Future.value(OsConfigInfo(
      androidSdk: 0,
      iosVersion: 0,
      isWeb: true,
    ));

class OsConfigInfo {
  final int androidSdk;
  final double iosVersion;
  final bool isWeb;

  OsConfigInfo({
    required this.androidSdk,
    required this.iosVersion,
    required this.isWeb,
  });
}

final bool platformIsAndroid = false;
final bool platformIsIOS = false;
