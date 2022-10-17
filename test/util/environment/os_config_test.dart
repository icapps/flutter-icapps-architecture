import 'package:device_info_plus/device_info_plus.dart';
import 'package:device_info_plus_platform_interface/model/android_device_info.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:icapps_architecture/icapps_architecture.dart';
import 'package:icapps_architecture/src/util/environment/impl/os_info_io.dart'
    as io;
import 'package:icapps_architecture/src/util/environment/impl/os_info_stub.dart'
    as stub;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'os_config_test.mocks.dart';

@GenerateMocks([
  DeviceInfoPlugin,
  AndroidBuildVersion,
  IosUtsname,
  AndroidDisplayMetrics,
])
void main() {
  group('OS config tests', () {
    test('OS config from io, unknown', () async {
      await OsInfo.init();
      expect(OsInfo.instance.isWeb, false);
      expect(OsInfo.instance.androidSdk, 0);
      expect(OsInfo.instance.iosVersion, 0);
      expect(OsInfo.instance.isAndroid, false);
      expect(OsInfo.instance.isIOS, false);
    });
    test('OS config is at least', () async {
      await OsInfo.init();
      expect(OsInfo.instance.isAtLeastAndroid10, false);
      expect(OsInfo.instance.isAtLeastPie, false);
      expect(OsInfo.instance.isIOS13OrAbove, false);
      expect(OsInfo.instance.isAndroid, false);
      expect(OsInfo.instance.isIOS, false);
    });
    test('OS config from stub', () async {
      final info = await stub.initOsConfig();
      expect(info.isWeb, true);
      expect(info.androidSdk, 0);
      expect(info.iosVersion, 0);
    });
    test('OS config from io, android', () async {
      final mock = MockDeviceInfoPlugin();
      final version = MockAndroidBuildVersion();
      when(version.sdkInt).thenReturn(10);
      when(mock.androidInfo).thenAnswer((_) => Future.value(AndroidDeviceInfo(
          isPhysicalDevice: true,
          board: 'surf',
          supportedAbis: ['x256-powermaxx'],
          systemFeatures: ['fishingrod'],
          display: 'iMAX',
          device: 'yes',
          model: 'hot',
          bootloader: 'not loaded',
          hardware: 'soft',
          supported64BitAbis: [],
          product: 'placement',
          supported32BitAbis: [],
          tags: 'dog',
          brand: 'no',
          manufacturer: 'your m*m',
          id: '8 (twice the androidId)',
          type: 'space station',
          host: 'Joan Calamazzo',
          fingerprint: '*boop*',
          version: version,
          displayMetrics: MockAndroidDisplayMetrics())));
      final info = await io.initOsConfig(
        deviceInfoPluginProvider: () => mock,
        isAndroidOverride: true,
        isIOSOverride: false,
      );
      expect(info.isWeb, false);
      expect(info.androidSdk, 10);
      expect(info.iosVersion, 0);
    });
    test('OS config from io, ios', () async {
      final mock = MockDeviceInfoPlugin();
      when(mock.iosInfo).thenAnswer((_) => Future.value(IosDeviceInfo(
            isPhysicalDevice: true,
            model: 'hot',
            identifierForVendor: '4 (chosen by dice roll)',
            localizedModel: 'local hot',
            systemVersion: '14.4.2',
            name: 'Jeoff',
            systemName: 'et äpple',
            utsname: MockIosUtsname(),
          )));
      final info = await io.initOsConfig(
        deviceInfoPluginProvider: () => mock,
        isAndroidOverride: false,
        isIOSOverride: true,
      );
      expect(info.isWeb, false);
      expect(info.androidSdk, 0);
      expect(info.iosVersion, 14.4);
    });
    test('IsDevice Android or IOS', () {
      expect(isDeviceIOS, false);
      expect(isDeviceAndroid, false);
      expect(stub.platformIsAndroid, false);
      expect(stub.platformIsIOS, false);
    });
  });
}
