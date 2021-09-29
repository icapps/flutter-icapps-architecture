import 'package:flutter/widgets.dart';
import 'package:icapps_architecture/src/widget/provider/theme_provider_widget.dart';
import 'package:provider/provider.dart';

class BaseProviderWidget<T extends ChangeNotifier, Theme, Localization>
    extends StatelessWidget {
  final T? value;
  final T Function() create;
  final Widget? child;
  final Widget Function(
          BuildContext context, Theme theme, Localization localization)?
      childBuilder;
  final Widget Function(BuildContext context, T viewModel, Theme theme,
      Localization localization)? childBuilderWithViewModel;
  final Widget? consumerChild;
  final Widget Function(BuildContext context, T viewModel, Widget? child)?
      consumer;
  final Widget Function(BuildContext context, T viewModel, Widget? child,
      Theme theme, Localization localization)? consumerWithThemeAndLocalization;
  final bool lazy;

  const BaseProviderWidget({
    required this.create,
    this.child,
    this.childBuilder,
    this.consumer,
    this.consumerWithThemeAndLocalization,
    this.consumerChild,
    this.childBuilderWithViewModel,
    this.lazy = true,
  }) : this.value = null;

  const BaseProviderWidget.value({
    required this.value,
    this.child,
    this.childBuilder,
    this.consumer,
    this.consumerWithThemeAndLocalization,
    this.consumerChild,
    this.childBuilderWithViewModel,
  })  : this.lazy = false,
        this.create = _notImplemented;

  @override
  Widget build(BuildContext context) {
    final consumerCreator = Builder(
      builder: (context) {
        if (consumerWithThemeAndLocalization != null || consumer != null) {
          return Consumer<T>(
            child: consumerChild ?? Container(),
            builder: consumer ??
                (context, t, widget) => consumerWithThemeAndLocalization!(
                    context,
                    t,
                    widget,
                    themeLookup(context),
                    localizationLookup(context)),
          );
        } else if (child != null) {
          return child!;
        } else if (childBuilder != null) {
          return childBuilder!(
              context, themeLookup(context), localizationLookup(context));
        } else if (childBuilderWithViewModel != null) {
          return childBuilderWithViewModel!(context, Provider.of<T>(context),
              themeLookup(context), localizationLookup(context));
        }
        throw ArgumentError(
            'child, childBuilder, childBuilderWithViewModel, consumer or consumerWithThemeAndLocalization should be passed');
      },
    );

    if (value != null) {
      return ChangeNotifierProvider.value(
        value: value,
        child: consumerCreator,
      );
    }

    return ChangeNotifierProvider<T>(
      lazy: lazy,
      child: consumerCreator,
      create: (context) => create(),
    );
  }

  static T _notImplemented<T>() {
    throw UnimplementedError();
  }
}
