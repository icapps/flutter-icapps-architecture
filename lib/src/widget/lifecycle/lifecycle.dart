import 'package:flutter/material.dart';

/// Helper widget for reacting to lifecycle events.
///
/// This widget listens to changes in the [AppLifecycleState].
class LifecycleWidget extends StatefulWidget {
  final Widget child;
  final VoidCallback? onResume;
  final VoidCallback? onPause;
  final VoidCallback? onDetached;
  final VoidCallback? onInactive;

  const LifecycleWidget({
    required this.child,
    this.onResume,
    this.onPause,
    this.onDetached,
    this.onInactive,
  });

  @override
  _LifecycleWidgetState createState() => _LifecycleWidgetState();
}

class _LifecycleWidgetState extends State<LifecycleWidget>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  Widget build(BuildContext context) => widget.child;

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
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
    }
  }
}
