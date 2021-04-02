import 'package:flutter/material.dart';
import 'package:icapps_architecture/icapps_architecture.dart';
import 'package:icapps_architecture/src/util/environment/os_info.dart';

/// Holder class for the theme base. Fills in basic shared properties
@immutable
class BaseThemeData {
  /// Gets the base theme to use to build new themes on
  static ThemeData get baseTheme {
    return ThemeData(
      pageTransitionsTheme: PageTransitionsTheme(
        builders: {
          TargetPlatform.iOS: const CupertinoPageTransitionsBuilder(),
          TargetPlatform.android:
              getCorrectPageTransitionBuilder(OsInfo.instance),
        },
      ),
    );
  }

  /// Builds the correct page transition based on the current OS
  static PageTransitionsBuilder getCorrectPageTransitionBuilder(OsInfo info) {
    if (info.isIOS) return const CupertinoPageTransitionsBuilder();
    if (!info.isAndroid) return const ZoomPageTransitionsBuilder();
    if (info.isAtLeastAndroid10) {
      return const ZoomPageTransitionsBuilder();
    } else if (info.isAtLeastPie) {
      return const OpenUpwardsPageTransitionsBuilder();
    }
    return const FadeUpwardsPageTransitionsBuilder();
  }
}
