import 'package:flutter/material.dart';
import 'package:icapps_architecture/icapps_architecture.dart';
import 'package:icapps_architecture/src/widget/touch_feedback/color_touch_effect.dart';
import 'package:icapps_architecture/src/widget/touch_feedback/touch_manager.dart';

class TouchEffectInfo {
  final int durationInSeconds;
  final bool isTouched;
  final Offset touchPosition;
  final BorderRadius? borderRadius;
  final AnimationController? animationController;

  TouchEffectInfo({
    required this.touchPosition,
    required this.isTouched,
    required this.animationController,
    required this.durationInSeconds,
    required this.borderRadius,
  });
}

/// Helper class for platform-specific touch feedback
///
/// On devices running with the android theme, this will create a ripple effect,
/// on other devices, this will create a scaling touch down effect
class TouchFeedBack extends StatelessWidget {
  final Widget child;
  final VoidCallback? onClick;
  final String? semanticsLabel;
  final Color color;
  final BorderRadius? borderRadius;
  final double elevation;
  final Color? shadowColor;
  final ShapeBorder? shapeBorder;
  final Color? androidSplashColor;
  final bool forceAndroid;
  final bool forceIOS;

  const TouchFeedBack({
    required this.child,
    required this.onClick,
    this.semanticsLabel,
    this.color = Colors.transparent,
    this.elevation = 0,
    this.borderRadius,
    this.shadowColor,
    this.shapeBorder,
    this.androidSplashColor,
    this.forceAndroid = false,
    this.forceIOS = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isAndroid = (!forceIOS && context.isAndroidTheme) || forceAndroid;
    return Semantics(
      label: semanticsLabel,
      button: true,
      child: TouchManager(
        borderRadius: borderRadius,
        onTap: onClick,
        touchEffectBuilders: [
          if (isAndroid) ...[
            (context, info) => RippleTouchEffect(
                  isTouched: info.isTouched,
                  touchPosition: info.touchPosition,
                  animationController: info.animationController,
                  durationSeconds: info.durationInSeconds,
                  borderRadius: info.borderRadius,
                ),
          ],
          (context, info) => ColorTouchEffect(
                isTouched: info.isTouched,
                borderRadius: info.borderRadius,
                color: color,
              )
        ],
        child: Material(
          color: color,
          shape: shapeBorder,
          elevation: elevation,
          shadowColor: shadowColor,
          borderRadius: borderRadius,
          child: child,
        ),
      ),
    );
  }
}
