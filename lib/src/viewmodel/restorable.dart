import 'package:flutter/widgets.dart';
import 'package:icapps_architecture/src/extension/null_extensions.dart';
import 'package:icapps_architecture/src/util/restorable/bundle.dart';
import 'package:icapps_architecture/src/util/restorable/restorable.dart';

/// Holder class for restorable view models, use with the flutter restoration
/// framework (See [RestorationMixin]).
/// The contained [viewModel] can change at any time, that's why it is usually
/// wrapped in a builder that listens for changes. Eg: [AnimatedBuilder].
///
/// Example:
/// ```dart
/// @override
/// void initState() {
///   super.initState();
///   _viewModelHolder = RestorableViewModelHolder(
///     create: () => GetIt.I.get(),
///     init: (vm) => vm.init(...),
///     whenCreated: (vm) => ...,
///   );
/// }
///
///
/// @override
/// Widget build(BuildContext context) {
///   return AnimatedBuilder(
///      animation: _viewModelHolder,
///      builder: (context, _) => ProviderWidget<ContainedViewModel>.value(
///        value: _viewModelHolder.viewModel,
///        childBuilderWithViewModel: (context, viewModel, theme, localization) => ...,
///      ),
///   );
/// }
///
/// @override
/// String? get restorationId => 'some_unique_id';
///
/// @override
/// void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
///     registerForRestoration(_viewModelHolder, 'viewmodel');
/// }
/// ```
class RestorableViewModelHolder<T extends Restorable>
    extends RestorableChangeNotifier<T> with WidgetsBindingObserver {
  /// The init function is called AFTER the state has been restored
  final void Function(T) init;

  /// This function is called BEFORE [init] and BEFORE state has been restored
  final void Function(T) whenCreated;

  /// Creator function for the restorable view model
  final T Function() create;

  late AppLifecycleState? _lastState;

  RestorableViewModelHolder({
    required this.create,
    this.init = _noOp,
    this.whenCreated = _noOp,
  }) {
    _lastState = WidgetsBinding.instance?.lifecycleState;
    WidgetsBinding.instance?.addObserver(this);
  }

  late T _viewModel;

  T get viewModel => _viewModel;

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  T createDefaultValue() {
    final viewModel = create();
    whenCreated(viewModel);
    viewModel.restoreState(null);
    init(viewModel);
    return viewModel;
  }

  @override
  T fromPrimitives(Object? data) {
    final viewModel = create();
    whenCreated(viewModel);
    viewModel.restoreState(data.let((e) => Bundle.from(e)));
    init(viewModel);
    return viewModel;
  }

  @override
  void initWithValue(T value) {
    _viewModel = value;
    notifyListeners();
  }

  @override
  Object? toPrimitives() {
    final target = Bundle();
    viewModel.saveState(target);
    return target.asFlatStructure();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive &&
        _lastState == AppLifecycleState.resumed) {
      notifyListeners(); //Trigger rebuild of values
    }
    _lastState = state;
  }
}

void _noOp(dynamic _) {}
