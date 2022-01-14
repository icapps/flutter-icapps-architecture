import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:icapps_architecture/icapps_architecture.dart';

void main() {
  setUp(() async {
    await OsInfo.init();
  });

  group('Base theme data test', () {
    test('Test base theme page builders', () {
      final theme = BaseThemeData.baseTheme;
      expect(theme.pageTransitionsTheme.builders[TargetPlatform.android],
          isInstanceOf<ZoomPageTransitionsBuilder>());
      expect(theme.pageTransitionsTheme.builders[TargetPlatform.iOS],
          isInstanceOf<CupertinoPageTransitionsBuilder>());
    });
    test('Test correct page transition android', () {
      expect(BaseThemeData.getCorrectPageTransitionBuilder(OsInfo(1, 0, false)),
          isInstanceOf<FadeUpwardsPageTransitionsBuilder>());
      expect(
          BaseThemeData.getCorrectPageTransitionBuilder(OsInfo(28, 0, false)),
          isInstanceOf<OpenUpwardsPageTransitionsBuilder>());
      expect(
          BaseThemeData.getCorrectPageTransitionBuilder(OsInfo(29, 0, false)),
          isInstanceOf<ZoomPageTransitionsBuilder>());
    });
    test('Test correct page transition ios', () {
      expect(
          BaseThemeData.getCorrectPageTransitionBuilder(OsInfo(0, 14.0, false)),
          isInstanceOf<CupertinoPageTransitionsBuilder>());
    });
  });
}
