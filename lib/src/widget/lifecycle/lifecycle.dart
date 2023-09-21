import 'package:flutter/material.dart';

/// Helper widget for reacting to lifecycle events.
/// This widget listens to changes in the [AppLifecycleState].
class LifecycleWidget extends StatefulWidget {
  /// The widget below this widget in the tree.
  final Widget child;

  /// [onResume] is triggered when the app goes to the [AppLifecycleState.resumed] state.
  final VoidCallback? onResume;

  /// [onPause] is triggered when the app goes to the [AppLifecycleState.paused] state.
  final VoidCallback? onPause;

  /// [onDetached] is triggered when the app goes to the [AppLifecycleState.detached] state.
  final VoidCallback? onDetached;

  /// [onInactive] is triggered when the app goes to the [AppLifecycleState.inactive] state.
  final VoidCallback? onInactive;

  /// [onHidden] is triggered when the app goes to the [AppLifecycleState.hidden] state.
  final VoidCallback? onHidden;

  /// Helper widget for reacting to lifecycle events.
  /// This widget listens to changes in the [AppLifecycleState].
  const LifecycleWidget({
    required this.child,
    this.onResume,
    this.onPause,
    this.onDetached,
    this.onInactive,
    this.onHidden,
  });

  @override
  _LifecycleWidgetState createState() => _LifecycleWidgetState();
}

class _LifecycleWidgetState extends State<LifecycleWidget> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) => widget.child;

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        widget.onResume?.call();
        break;
      case AppLifecycleState.paused:
        widget.onPause?.call();
        break;
      case AppLifecycleState.detached:
        widget.onDetached?.call();
        break;
      case AppLifecycleState.inactive:
        widget.onInactive?.call();
        break;
      case AppLifecycleState.hidden:
        widget.onHidden?.call();
        break;
    }
  }
}
