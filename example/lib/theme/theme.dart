import 'dart:ui';

import 'package:flutter/material.dart';

class AppTheme {
  static const _instance = AppTheme(Colors.red);

  final Color baseColor;

  const AppTheme(this.baseColor);

  static AppTheme of(BuildContext context) => _instance;
}
