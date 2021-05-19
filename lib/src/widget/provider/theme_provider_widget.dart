import 'package:flutter/widgets.dart';

late Theme Function<Theme>(BuildContext context) themeLookup;
late Localization Function<Localization>(BuildContext context)
    localizationLookup;

class BaseThemeProviderWidget<Theme, Localization> extends StatelessWidget {
  final Widget Function(BuildContext context, Theme theme)? childBuilderTheme;
  final Widget Function(BuildContext context, Localization localization)?
      childBuilderLocalization;
  final Widget Function(
          BuildContext context, Theme theme, Localization localization)?
      childBuilder;

  const BaseThemeProviderWidget({
    this.childBuilderTheme,
    this.childBuilderLocalization,
    this.childBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (childBuilderTheme != null) {
        return childBuilderTheme!(context, themeLookup(context));
      } else if (childBuilderLocalization != null) {
        return childBuilderLocalization!(context, localizationLookup(context));
      } else if (childBuilder != null) {
        return childBuilder!(
            context, themeLookup(context), localizationLookup(context));
      }
      throw ArgumentError(
          'childBuilderTheme, childBuilderLocalization or childBuilder should be passed');
    });
  }
}
