import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:icapps_architecture/src/widget/touch_feedback/touch_manager.dart';

const macDarkTapColor = Color(0x4B3A3A3C);
const macLightTapColor = Color(0x4BF2F2F7);

class TouchEffectInfo {
  final int durationInSeconds;
  final bool isTouched;
  final Offset touchPosition;
  final BorderRadius? borderRadius;
  final AnimationController? animationController;
  final Color? tapColor;

  TouchEffectInfo({
    required this.touchPosition,
    required this.isTouched,
    required this.animationController,
    required this.durationInSeconds,
    required this.borderRadius,
    required this.tapColor,
  });
}

/// Helper class for hover feedback on macos or web
///
/// This has aditional properties for adding MouseRegion properties
/// this will create a scaling touch down effect
class TouchFeedBack extends StatelessWidget {
  final Widget child;
  final FutureOr<void> Function()? onTapped;
  final String? semanticsLabel;
  final Color color;
  final Color? tapColor;
  final BorderRadius? borderRadius;
  final double elevation;
  final Color? shadowColor;
  final ShapeBorder? shapeBorder;

  final bool animateAwait;
  final MouseCursor cursor;
  final void Function(PointerEnterEvent)? onEnter;
  final void Function(PointerExitEvent)? onExit;
  final void Function(PointerHoverEvent)? onHover;

  /// Custom touch effect builders will be show on top of the child in a stack
  final List<TouchEffectBuilder> touchEffectBuilders;

  const TouchFeedBack({
    required this.child,
    required this.onTapped,
    this.touchEffectBuilders = const <TouchEffectBuilder>[],
    this.tapColor,
    this.semanticsLabel,
    this.color = Colors.transparent,
    this.elevation = 0,
    this.borderRadius,
    this.shadowColor,
    this.shapeBorder,
    this.animateAwait = true,
    this.cursor = SystemMouseCursors.click,
    this.onEnter,
    this.onExit,
    this.onHover,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticsLabel,
      button: true,
      child: MouseRegion(
        cursor: cursor,
        onEnter: onEnter,
        onExit: onExit,
        onHover: onHover,
        child: TouchManager(
          animateAwait: animateAwait,
          borderRadius: borderRadius,
          onTap: onTapped,
          tapColor: tapColor ?? macLightTapColor, 
          touchEffectBuilders: touchEffectBuilders,
          child: Material(
            color: color,
            shape: shapeBorder,
            elevation: elevation,
            shadowColor: shadowColor,
            borderRadius: borderRadius,
            child: child,
          ),
        ),
      ),
    );
  }
}
