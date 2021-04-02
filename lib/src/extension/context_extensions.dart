import 'package:flutter/material.dart';
import 'package:icapps_architecture/src/widget/responsive/responsive_widget.dart';

extension BuilContextExtensions on BuildContext {
  /// Returns true if the current theme is targeting the android platform
  bool get isAndroidTheme => Theme.of(this).platform == TargetPlatform.android;

  /// Returns true if the current theme is targeting the ios platform
  bool get isIOSTheme => Theme.of(this).platform == TargetPlatform.iOS;

  /// Returns true if the device indicates it is a tablet.
  ///
  /// See [ResponsiveWidget.getDeviceType]
  bool get isTablet => MediaQuery.of(this).isTablet;

  /// Returns true if the device indicates it is in landscape mode.
  ///
  /// See [MediaQueryData.orientation]
  bool get isLandscape => MediaQuery.of(this).isLandscape;
}

extension MediaQueryExtension on MediaQueryData {
  /// Returns true if the device indicates it is a tablet.
  ///
  /// See [ResponsiveWidget.getDeviceType]
  bool get isTablet =>
      ResponsiveWidget.getDeviceType(this) == DeviceScreenType.Tablet;

  /// Returns true if the device indicates it is in landscape mode.
  ///
  /// See [MediaQueryData.orientation]
  bool get isLandscape => orientation == Orientation.landscape;
}
