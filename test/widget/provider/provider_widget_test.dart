import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:icapps_architecture/icapps_architecture.dart';

import '../../test_util.dart';

class TestViewModel with ChangeNotifierEx {}

class Theme {}

class Locale {}

class ProviderWidget<T extends ChangeNotifier>
    extends BaseProviderWidget<T, Theme, Locale> {
  ProviderWidget({
    required T Function() create,
    Widget? child,
    Widget Function(BuildContext context, Theme theme, Locale localization)?
        childBuilder,
    Widget Function(BuildContext context, T viewModel, Theme theme,
            Locale localization)?
        childBuilderWithViewModel,
    Widget? consumerChild,
    Widget Function(BuildContext context, T viewModel, Widget? child)? consumer,
    Widget Function(BuildContext context, T viewModel, Widget? child,
            Theme theme, Locale localization)?
        consumerWithThemeAndLocalization,
    bool lazy = true,
  }) : super(
          create: create,
          child: child,
          childBuilder: childBuilder,
          childBuilderWithViewModel: childBuilderWithViewModel,
          consumerChild: consumerChild,
          consumer: consumer,
          consumerWithThemeAndLocalization: consumerWithThemeAndLocalization,
          lazy: lazy,
        );
}

LocaleT getLocale<LocaleT>(BuildContext _) => Locale() as LocaleT;

ThemeT getTheme<ThemeT>(BuildContext _) => Theme() as ThemeT;

void main() {
  BaseProviderWidget.localizationLookup = getLocale;
  BaseProviderWidget.themeLookup = getTheme;

  group('Provider widget tests', () {
    testWidgets('ProviderWidget throw exception', (tester) async {
      final sut = ProviderWidget<TestViewModel>(
        create: () => TestViewModel(),
      );
      await TestUtil.loadWidgetWithText(tester, sut);
      expect(tester.takeException(), isInstanceOf<ArgumentError>());
    });

    testWidgets('ProviderWidget should show child', (tester) async {
      final sut = ProviderWidget<TestViewModel>(
        child: const Material(child: Text('test')),
        create: () => TestViewModel(),
      );

      await TestUtil.loadWidgetWithText(tester, sut);
      await TestUtil.takeScreenshot(tester, 'provider_widget_child');
    });

    testWidgets('ProviderWidget should show childbuilder with viewmodel',
        (tester) async {
      final sut = ProviderWidget<TestViewModel>(
        childBuilderWithViewModel: (context, item, _, __) =>
            const Material(child: Text('Test')),
        create: () => TestViewModel(),
      );

      await TestUtil.loadWidgetWithText(tester, sut);
      await TestUtil.takeScreenshot(tester, 'provider_widget_child_builder');
    });

    testWidgets('ProviderWidget should show childbuilder with consumer',
        (tester) async {
      final sut = ProviderWidget<TestViewModel>(
        consumer: (context, viewModel, widget) =>
            const Material(child: Text('Hello')),
        create: () => TestViewModel(),
      );

      await TestUtil.loadWidgetWithText(tester, sut);
      await TestUtil.takeScreenshot(tester, 'provider_widget_consumer');
    });

    testWidgets(
        'ProviderWidget should show childbuilder with consumerWithThemeAndLocalization',
        (tester) async {
      final sut = ProviderWidget<TestViewModel>(
        consumerWithThemeAndLocalization: (context, viewModel, widget, _, __) =>
            const Material(child: Text('Hello')),
        create: () => TestViewModel(),
      );

      await TestUtil.loadWidgetWithText(tester, sut);
      await TestUtil.takeScreenshot(
          tester, 'provider_widget_consumer_with_theme_and_localization');
    });

    testWidgets(
        'ProviderWidget should show childbuilder with consumer and consumerChild',
        (tester) async {
      final sut = ProviderWidget<TestViewModel>(
        consumerChild: const Text('Hallo 2'),
        consumer: (context, viewModel, child) => Material(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Hello'),
              child ?? Container(),
            ],
          ),
        ),
        create: () => TestViewModel(),
      );

      await TestUtil.loadWidgetWithText(tester, sut);
      await TestUtil.takeScreenshot(
          tester, 'provider_widget_consumer_and_consumer_child');
    });

    testWidgets(
        'ProviderWidget should show childbuilder with childBuilder',
            (tester) async {
          final sut = ProviderWidget<TestViewModel>(
            childBuilder: (context, viewModel, locale) => Material(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Hello'),
                ],
              ),
            ),
            create: () => TestViewModel(),
          );

          await TestUtil.loadWidgetWithText(tester, sut);
          await TestUtil.takeScreenshot(
              tester, 'provider_widget_consumer_childbuilder');
        });
  });
}
