import 'package:example/theme/theme.dart';
import 'package:example/util/locale/localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:icapps_architecture/icapps_architecture.dart';

class ProviderWidget<T extends ChangeNotifier>
    extends BaseProviderWidget<T, AppTheme, Localization> {
  ProviderWidget({
    required T Function() create,
    Widget? child,
    Widget Function(
            BuildContext context, AppTheme theme, Localization localization)?
        childBuilder,
    Widget Function(BuildContext context, T viewModel, AppTheme theme,
            Localization localization)?
        childBuilderWithViewModel,
    Widget? consumerChild,
    Widget Function(BuildContext context, T viewModel, Widget? child)? consumer,
    Widget Function(BuildContext context, T viewModel, Widget? child,
            AppTheme theme, Localization localization)?
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
