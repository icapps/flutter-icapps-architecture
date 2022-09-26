import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:icapps_architecture/icapps_architecture.dart';

import '../../test_util.dart';

class TestViewModel with ChangeNotifierEx {}

class Theme {}

class ProviderWidget<T extends ChangeNotifier>
    extends BaseProviderWidget<T, Theme> {
  ProviderWidget({
    required T Function() create,
    Widget? child,
    Widget Function(BuildContext context, Theme theme)? childBuilder,
    Widget Function(BuildContext context, T viewModel, Theme theme)?
        childBuilderWithViewModel,
    Widget? consumerChild,
    Widget Function(BuildContext context, T viewModel, Widget? child)? consumer,
    Widget Function(
            BuildContext context, T viewModel, Widget? child, Theme theme)?
        consumerWithTheme,
    bool lazy = true,
  }) : super(
          create: create,
          child: child,
          childBuilder: childBuilder,
          childBuilderWithViewModel: childBuilderWithViewModel,
          consumerChild: consumerChild,
          consumer: consumer,
          consumerWithTheme: consumerWithTheme,
          lazy: lazy,
        );

  ProviderWidget.value({
    required T value,
    Widget? child,
    Widget Function(BuildContext context, Theme theme)? childBuilder,
    Widget Function(BuildContext context, T viewModel, Theme theme)?
        childBuilderWithViewModel,
    Widget? consumerChild,
    Widget Function(BuildContext context, T viewModel, Widget? child)? consumer,
    Widget Function(
            BuildContext context, T viewModel, Widget? child, Theme theme)?
        consumerWithTheme,
  }) : super.value(
          value: value,
          child: child,
          childBuilder: childBuilder,
          childBuilderWithViewModel: childBuilderWithViewModel,
          consumerChild: consumerChild,
          consumer: consumer,
          consumerWithTheme: consumerWithTheme,
        );
}

ThemeT getTheme<ThemeT>(BuildContext _) => Theme() as ThemeT;

void main() {
  setUp(() {
    themeLookup = getTheme;
  });

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
        childBuilderWithViewModel: (context, item, _) =>
            const Material(child: Text('Test')),
        create: () => TestViewModel(),
      );

      await TestUtil.loadWidgetWithText(tester, sut);
      await TestUtil.takeScreenshot(tester, 'provider_widget_child_builder');
    });

    testWidgets('ProviderWidget.value should show childbuilder with viewmodel',
        (tester) async {
      final sut = ProviderWidget<TestViewModel>.value(
        childBuilderWithViewModel: (context, item, _) =>
            const Material(child: Text('Test')),
        value: TestViewModel(),
      );

      await TestUtil.loadWidgetWithText(tester, sut);
      await TestUtil.takeScreenshot(
          tester, 'provider_widget_value_child_builder');
    });

    testWidgets('ProviderWidget.value create should throw', (tester) async {
      final sut = ProviderWidget<TestViewModel>.value(
        childBuilderWithViewModel: (context, item, _) =>
            const Material(child: Text('Test')),
        value: TestViewModel(),
      );

      expect(() => sut.create(), throwsA(isInstanceOf<UnimplementedError>()));
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
        'ProviderWidget should show childbuilder with consumerWithThemeAnd',
        (tester) async {
      final sut = ProviderWidget<TestViewModel>(
        consumerWithTheme: (context, viewModel, widget, _) =>
            const Material(child: Text('Hello')),
        create: () => TestViewModel(),
      );

      await TestUtil.loadWidgetWithText(tester, sut);
      await TestUtil.takeScreenshot(
          tester, 'provider_widget_consumer_with_theme');
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

    testWidgets('ProviderWidget should show childbuilder with childBuilder',
        (tester) async {
      final sut = ProviderWidget<TestViewModel>(
        childBuilder: (context, viewModel) => Material(
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
