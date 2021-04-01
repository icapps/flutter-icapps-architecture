import 'dart:io';

import 'package:device_info/device_info.dart';

Future<OsConfigInfo> initOsConfig({
  DeviceInfoPlugin? Function()? deviceInfoPluginProvider,
  bool? isAndroidOverride,
  bool? isIOSOverride,
}) async {
  if (isAndroidOverride ?? Platform.isAndroid) {
    final deviceInfo = deviceInfoPluginProvider?.call() ?? DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;
    final androidSdk = androidInfo.version.sdkInt;
    return OsConfigInfo(androidSdk: androidSdk, iosVersion: 0, isWeb: false);
  } else if (isIOSOverride ?? Platform.isIOS) {
    final deviceInfo = deviceInfoPluginProvider?.call() ?? DeviceInfoPlugin();
    final iosInfo = await deviceInfo.iosInfo;
    final iosVersion = iosInfo.systemVersion;
    final lastIndexPoint = iosVersion.lastIndexOf('.');
    final versionLength = iosVersion.length;
    final version = iosVersion.replaceRange(lastIndexPoint, versionLength, '');
    final iosVersionValue = double.tryParse(version) ?? 0;
    return OsConfigInfo(
        androidSdk: 0, iosVersion: iosVersionValue, isWeb: false);
  } else {
    return OsConfigInfo(androidSdk: 0, iosVersion: 0, isWeb: false);
  }
}

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
