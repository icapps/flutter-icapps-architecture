import 'package:flutter/material.dart';

extension BuilContextExtensions on BuildContext {
  bool get isAndroidTheme => Theme.of(this).platform == TargetPlatform.android;

  bool get isIOSTheme => Theme.of(this).platform == TargetPlatform.iOS;
}
