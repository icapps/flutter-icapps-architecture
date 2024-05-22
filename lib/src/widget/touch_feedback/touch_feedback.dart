import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:icapps_architecture/icapps_architecture.dart';
import 'package:icapps_architecture/src/widget/touch_feedback/touch_manager.dart';

const androidDarkTapColor = Color(0x0A000000);
const androidDarkRippleColor = Color(0x1E000000);

const androidLightTapColor = Color(0x0AFFFFFF);
const androidLightRippleColor = Color(0x1EFFFFFF);

const iosDarkTapColor = Color(0x4B3A3A3C);
const iosLightTapColor = Color(0x4BF2F2F7);

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

/// Helper class for platform-specific touch feedback
///
/// On devices running with the android theme, this will create a ripple effect,
/// on other devices, this will create a scaling touch down effect
class TouchFeedBack extends StatelessWidget {
  final Widget child;
  final bool waitUntilOnTappedFinishesIOS;
  final FutureOr<void> Function()? onTapped;
  final String? semanticsLabel;
  final Color color;
  final Color? tapColor;
  final BorderRadius? borderRadius;
  final double elevation;
  final Color? shadowColor;
  final ShapeBorder? shapeBorder;
  final Color? androidSplashColor;
  final bool isAndroidDark;
  final bool isIosDark;
  final bool animateAwait;
  final MouseCursor cursor;
  final PlatformOverwrite? forcePlatform;
  final ValueChanged<PointerEnterEvent>? onEnter;
  final ValueChanged<PointerExitEvent>? onExit;
  final ValueChanged<PointerHoverEvent>? onHover;

  /// Custom touch effect builders will be show on top of the child in a stack
  final List<TouchEffectBuilder> touchEffectBuilders;

  const TouchFeedBack({
    required this.child,
    required this.onTapped,
    this.touchEffectBuilders = const <TouchEffectBuilder>[],
    this.isAndroidDark = true,
    this.isIosDark = true,
    this.tapColor,
    this.semanticsLabel,
    this.color = Colors.transparent,
    this.elevation = 0,
    this.borderRadius,
    this.shadowColor,
    this.shapeBorder,
    this.androidSplashColor,
    @Deprecated('Use platform instead') bool forceAndroid = false,
    @Deprecated('Use platform instead') bool forceIOS = false,
    PlatformOverwrite forcePlatform = PlatformOverwrite.web,
    this.waitUntilOnTappedFinishesIOS = true,
    this.animateAwait = true,
    this.cursor = MouseCursor.defer,
    this.onEnter,
    this.onExit,
    this.onHover,
    super.key,
  }) : this.forcePlatform = forceAndroid
            ? PlatformOverwrite.android
            : forceIOS
                ? PlatformOverwrite.iOS
                : forcePlatform;

  @override
  Widget build(BuildContext context) {
    final isAndroid =
        (forcePlatform != PlatformOverwrite.iOS && context.isAndroidTheme) ||
            forcePlatform == PlatformOverwrite.android;
    final isMobile = isAndroid ||
        context.isIOSTheme ||
        forcePlatform == PlatformOverwrite.iOS;

    Widget touchManager = TouchManager(
      animateAwait: animateAwait,
      borderRadius: borderRadius,
      onTap: onTapped,
      tapColor: tapColor ?? _getTapColor(isAndroid),
      touchEffectBuilders: [
        if (isAndroid) ...[
          (context, info) => RippleTouchEffect(
                isTouched: info.isTouched,
                touchPosition: info.touchPosition,
                animationController: info.animationController,
                durationSeconds: info.durationInSeconds,
                borderRadius: info.borderRadius,
                rippleColor: isAndroidDark
                    ? androidDarkRippleColor
                    : androidLightRippleColor,
              ),
        ],
        ...touchEffectBuilders,
      ],
      child: Material(
        color: color,
        shape: shapeBorder,
        elevation: elevation,
        shadowColor: shadowColor,
        borderRadius: borderRadius,
        child: child,
      ),
    );

    return Semantics(
      label: semanticsLabel,
      button: true,
      child: isMobile
          ? touchManager
          : MouseRegion(
              cursor: cursor,
              onEnter: onEnter,
              onExit: onExit,
              onHover: onHover,
              child: touchManager,
            ),
    );
  }

  Color _getTapColor(bool isAndroid) {
    if (isAndroid) {
      return isAndroidDark ? androidDarkTapColor : androidLightTapColor;
    } else {
      return isIosDark ? iosDarkTapColor : iosLightTapColor;
    }
  }
}
