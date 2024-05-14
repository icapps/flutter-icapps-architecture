import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:icapps_architecture/icapps_architecture.dart';

import '../../test_util.dart';

class Theme {}

class Locale {}

class ThemeProviderWidget extends BaseThemeProviderWidget<Theme, Locale> {
  const ThemeProviderWidget({
    super.childBuilderTheme,
    super.childBuilderLocalization,
    super.childBuilder,
    super.key,
  });
}

LocaleT getLocale<LocaleT>(BuildContext _) => Locale() as LocaleT;

ThemeT getTheme<ThemeT>(BuildContext _) => Theme() as ThemeT;

void main() {
  setUp(() {
    localizationLookup = getLocale;
    themeLookup = getTheme;
  });

  group('Theme Provider widget tests', () {
    testWidgets('ThemeProviderWidget throw exception', (tester) async {
      const sut = ThemeProviderWidget();
      await TestUtil.loadWidgetWithText(tester, sut);
      expect(tester.takeException(), isInstanceOf<ArgumentError>());
    });

    testWidgets('ThemeProviderWidget should build with theme', (tester) async {
      final sut = ThemeProviderWidget(
        childBuilderTheme: (context, _) => const Material(child: Text('Test')),
      );
      await TestUtil.loadWidgetWithText(tester, sut);
      await TestUtil.takeScreenshot(tester, 'theme_provider_widget_theme');
    });

    testWidgets('ThemeProviderWidget should build with localization',
        (tester) async {
      final sut = ThemeProviderWidget(
        childBuilderLocalization: (context, _) =>
            const Material(child: Text('Test')),
      );
      await TestUtil.loadWidgetWithText(tester, sut);
      await TestUtil.takeScreenshot(
          tester, 'theme_provider_widget_localization');
    });

    testWidgets('ThemeProviderWidget should build with theme and localization',
        (tester) async {
      final sut = ThemeProviderWidget(
        childBuilder: (context, _, __) => const Material(child: Text('Test')),
      );
      await TestUtil.loadWidgetWithText(tester, sut);
      await TestUtil.takeScreenshot(
          tester, 'theme_provider_widget_theme_and_localization');
    });
  });
}
