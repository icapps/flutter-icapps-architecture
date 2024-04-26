import 'dart:async';

import 'package:flutter/material.dart';
import 'package:icapps_architecture/icapps_architecture.dart';
import 'package:icapps_architecture/src/widget/touch_feedback/color_touch_effect.dart';

typedef TouchEffectBuilder = Widget Function(BuildContext context, TouchEffectInfo touchInfo);

class TouchManager extends StatefulWidget {
  final Color color;
  final Color tapColor;
  final Widget child;
  final FutureOr<void> Function()? onTap;
  final BorderRadius? borderRadius;
  final HitTestBehavior? behavior;
  final List<TouchEffectBuilder> touchEffectBuilders;

  const TouchManager({
    required this.child,
    required this.touchEffectBuilders,
    required this.tapColor,
    this.onTap,
    this.behavior,
    this.borderRadius,
    this.color = Colors.transparent,
    super.key,
  });

  @override
  State<TouchManager> createState() => _TouchManagerState();
}

class _TouchManagerState extends State<TouchManager> with SingleTickerProviderStateMixin {
  var _isTouched = false;
  var _touchPosition = Offset.zero;
  static const durationSeconds = 10;

  /// Set by a child to ignore touch events when the child
  /// handles the touch event itself
  var ignoreTouch = false;

  AnimationController? _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: durationSeconds),
    );
  }

  @override
  void dispose() {
    _animationController?.dispose();
    _animationController = null;
    super.dispose();
  }

  void _onTapDown(TapDownDetails details, BuildContext context) {
    if (ignoreTouch) {
      ignoreTouch = false;
      return;
    }
    _touchPosition = details.localPosition;
    _isTouched = true;
    _animationController!
      ..reset()
      ..forward();
    setState(() {});

    var ancestor = context.findAncestorStateOfType<_TouchManagerState>();
    do {
      ancestor?.ignoreTouch = true;
      if (!mounted) return;
      ancestor = ancestor?.context.findAncestorStateOfType<_TouchManagerState>();
    } while (ancestor != null);
  }

  Future<void> _onTapUp(TapUpDetails details) async {
    if (_isTouched) await widget.onTap?.call();
    if (!mounted) return;
    _isTouched = false;
    setState(() {});
  }

  void _onTapCancel() {
    if (!mounted) return;
    _isTouched = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (widget.onTap == null) return widget.child;
    return GestureDetector(
      behavior: widget.behavior,
      onTapDown: (details) => _onTapDown(details, context),
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedBuilder(
        animation: _animationController!,
        builder: (context, child) => Stack(
          children: [
            child!,
            ...widget.touchEffectBuilders.map(
              (builder) => Positioned.fill(
                child: IgnorePointer(
                  child: builder(
                    context,
                    TouchEffectInfo(
                      touchPosition: _touchPosition,
                      isTouched: _isTouched,
                      animationController: _animationController,
                      durationInSeconds: durationSeconds,
                      borderRadius: widget.borderRadius,
                      tapColor: widget.tapColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        child: ColorTouchEffect(
          isTouched: _isTouched,
          color: widget.tapColor,
          child: Container(
            color: widget.color,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
