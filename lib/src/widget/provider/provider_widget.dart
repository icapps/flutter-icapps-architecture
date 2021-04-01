import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

typedef LookupFunction = A Function<A>(BuildContext);

abstract class BaseProviderWidget<T extends ChangeNotifier, Theme, Localization>
    extends StatelessWidget {
  static late Theme Function<Theme>(BuildContext context) themeLookup;
  static late Localization Function<Localization>(BuildContext context)
      localizationLookup;

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
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>(
      lazy: lazy,
      child: LayoutBuilder(
        builder: (context, constraints) {
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
      ),
      create: (context) => create(),
    );
  }
}
