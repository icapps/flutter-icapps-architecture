import 'package:example/theme/theme.dart';
import 'package:flutter/widgets.dart';
import 'package:icapps_architecture/icapps_architecture.dart';

class ProviderWidget<T extends ChangeNotifier>
    extends BaseProviderWidget<T, AppTheme> {
  ProviderWidget({
    required T Function() create,
    Widget? child,
    Widget Function(BuildContext context, AppTheme theme)? childBuilder,
    Widget Function(BuildContext context, T viewModel, AppTheme theme)?
        childBuilderWithViewModel,
    Widget? consumerChild,
    Widget Function(BuildContext context, T viewModel, Widget? child)? consumer,
    Widget Function(
            BuildContext context, T viewModel, Widget? child, AppTheme theme)?
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
}
