import 'package:flutter/widgets.dart';

late Theme Function<Theme>(BuildContext context) themeLookup;

class BaseThemeProviderWidget<Theme> extends StatelessWidget {
  final Widget Function(BuildContext context, Theme theme) childBuilder;

  const BaseThemeProviderWidget({
    required this.childBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return childBuilder(context, themeLookup(context));
      },
    );
  }
}
