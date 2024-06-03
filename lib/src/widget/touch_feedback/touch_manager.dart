import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:icapps_architecture/icapps_architecture.dart';
import 'package:icapps_architecture/src/widget/touch_feedback/color_touch_effect.dart';

typedef TouchEffectBuilder = Widget Function(
    BuildContext context, TouchEffectInfo touchInfo);

class TouchManager extends StatefulWidget {
  final Color color;
  final Color tapColor;
  final Color? hoverColor;
  final Widget child;
  final bool animateAwait;
  final bool isMobile;
  final FutureOr<void> Function()? onTap;
  final BorderRadius? borderRadius;
  final HitTestBehavior? behavior;
  final MouseCursor cursor;
  final ValueChanged<PointerEnterEvent>? onEnter;
  final ValueChanged<PointerExitEvent>? onExit;
  final ValueChanged<PointerHoverEvent>? onHover;
  final List<TouchEffectBuilder> touchEffectBuilders;

  const TouchManager({
    required this.tapColor,
    required this.child,
    required this.animateAwait,
    required this.touchEffectBuilders,
    this.hoverColor,
    this.isMobile = true,
    this.onTap,
    this.borderRadius,
    this.behavior,
    this.cursor = MouseCursor.defer,
    this.color = Colors.transparent,
    this.onEnter,
    this.onExit,
    this.onHover,
    super.key,
  });

  @override
  State<TouchManager> createState() => _TouchManagerState();
}

class _TouchManagerState extends State<TouchManager>
    with SingleTickerProviderStateMixin {
  var _isTouched = false;
  var _isHovering = false;
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
      ancestor =
          ancestor?.context.findAncestorStateOfType<_TouchManagerState>();
    } while (ancestor != null);
  }

  FutureOr<void> _onTapUp(TapUpDetails details) async {
    if (_isTouched)
      widget.animateAwait ? await widget.onTap?.call() : widget.onTap?.call();
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
    final Widget detector = GestureDetector(
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
          child: ColorTouchEffect(
            isTouched: _isHovering && !widget.isMobile,
            color: widget.hoverColor ?? widget.tapColor,
            child: Container(
              color: widget.color,
              child: widget.child,
            ),
          ),
        ),
      ),
    );
    if (widget.isMobile) return detector;
    return MouseRegion(
      cursor: widget.cursor,
      onEnter: _onEnter,
      onExit: _onExit,
      onHover: widget.onHover,
      child: detector,
    );
  }

  void _onExit(event) {
    widget.onExit?.call(event);
    if (!mounted) return;
    setState(() {
      _isHovering = false;
    });
  }

  void _onEnter(event) {
    widget.onEnter?.call(event);
    if (!mounted) return;
    setState(() {
      _isHovering = true;
    });
  }
}
