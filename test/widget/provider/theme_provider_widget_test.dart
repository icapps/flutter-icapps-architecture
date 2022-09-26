import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:icapps_architecture/icapps_architecture.dart';

import '../../test_util.dart';

class Theme {}

class ThemeProviderWidget extends BaseThemeProviderWidget<Theme> {
  const ThemeProviderWidget({
    required Widget Function(BuildContext context, Theme theme) childBuilder,
  }) : super(childBuilder: childBuilder);
}

ThemeT getTheme<ThemeT>(BuildContext _) => Theme() as ThemeT;

void main() {
  setUp(() {
    themeLookup = getTheme;
  });

  group('Theme Provider widget tests', () {
    testWidgets('ThemeProviderWidget should build with theme', (tester) async {
      final sut = ThemeProviderWidget(
        childBuilder: (context, _) => const Material(child: Text('Test')),
      );
      await TestUtil.loadWidgetWithText(tester, sut);
      await TestUtil.takeScreenshot(tester, 'theme_provider_widget_theme');
    });
  });
}
