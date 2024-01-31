import 'package:flutter/material.dart';
import 'package:icapps_architecture/icapps_architecture.dart';

/// Helper class for platform-specific touch feedback
///
/// On devices running with the android theme, this will create a ripple effect,
/// on other devices, this will create a scaling touch down effect
class TouchFeedBack extends StatefulWidget {
  final Widget child;
  final VoidCallback? onClick;
  final String? semanticsLabel;
  final Color color;
  final BorderRadius? borderRadius;
  final double elevation;
  final Color? shadowColor;
  final ShapeBorder? shapeBorder;
  final Color? androidSplashColor;

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
    super.key,
  });

  @override
  State<TouchFeedBack> createState() => _TouchFeedBackState();
}

class _TouchFeedBackState extends State<TouchFeedBack> {
  @override
  Widget build(BuildContext context) {
    if (context.isAndroidTheme) {
      return ClipRRect(
        borderRadius: widget.borderRadius ?? BorderRadius.zero,
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Material(
              color: widget.color,
              borderRadius: widget.borderRadius,
              shadowColor: widget.shadowColor,
              elevation: widget.elevation,
              shape: widget.shapeBorder,
              child: widget.child,
            ),
            Positioned.fill(
              child: TouchFeedBackAndroid(
                child: Container(color: Colors.transparent),
                onClick: widget.onClick,
                semanticsLabel: widget.semanticsLabel,
                borderRadius: widget.borderRadius,
                shapeBorder: widget.shapeBorder,
                androidSplashColor: widget.androidSplashColor,
              ),
            ),
          ],
        ),
      );
    }
    return TouchFeedBackIOS(
      child: widget.child,
      onClick: widget.onClick,
      semanticsLabel: widget.semanticsLabel,
      color: widget.color,
      elevation: widget.elevation,
      borderRadius: widget.borderRadius,
      shadowColor: widget.shadowColor,
      shapeBorder: widget.shapeBorder,
    );
  }
}

class TouchFeedBackAndroid extends StatelessWidget {
  final Widget child;
  final VoidCallback? onClick;
  final String? semanticsLabel;
  final Color color;
  final double elevation;
  final BorderRadius? borderRadius;
  final Color? shadowColor;
  final ShapeBorder? shapeBorder;
  final Color? androidSplashColor;

  const TouchFeedBackAndroid({
    required this.child,
    required this.onClick,
    this.semanticsLabel,
    this.color = Colors.transparent,
    this.elevation = 0,
    this.borderRadius,
    this.shadowColor,
    this.shapeBorder,
    this.androidSplashColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticsLabel,
      button: true,
      child: Material(
        color: color,
        shape: shapeBorder,
        elevation: elevation,
        shadowColor: shadowColor,
        borderRadius: borderRadius,
        child: onClick == null
            ? child
            : InkWell(
                customBorder: shapeBorder,
                borderRadius: borderRadius,
                splashColor: androidSplashColor,
                onTap: onClick,
                child: child,
              ),
      ),
    );
  }
}

class TouchFeedBackIOS extends StatefulWidget {
  final Widget child;
  final VoidCallback? onClick;
  final String? semanticsLabel;
  final Color color;
  final double elevation;
  final BorderRadius? borderRadius;
  final Color? shadowColor;
  final ShapeBorder? shapeBorder;

  const TouchFeedBackIOS({
    required this.child,
    required this.onClick,
    this.semanticsLabel,
    this.color = Colors.transparent,
    this.elevation = 0,
    this.borderRadius,
    this.shadowColor,
    this.shapeBorder,
    super.key,
  });

  @override
  _TouchFeedBackIOSState createState() => _TouchFeedBackIOSState();
}

class _TouchFeedBackIOSState extends State<TouchFeedBackIOS> {
  static const touchScale = 0.98;
  static const defaultScale = 1.0;

  static final _touchPoints = <UniqueKey, Offset>{};
  final _key = UniqueKey();

  var touched = false;

  @override
  void dispose() {
    _touchPoints.remove(_key);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: widget.semanticsLabel,
      button: true,
      child: GestureDetector(
        excludeFromSemantics: widget.onClick == null,
        onTapDown: _onTapDown,
        onTap: widget.onClick,
        onTapCancel: () => _setTouched(false),
        onTapUp: (details) => _setTouched(false),
        child: Transform.scale(
          scale: widget.onClick != null && touched ? touchScale : defaultScale,
          child: Material(
            color: widget.color,
            shape: widget.shapeBorder,
            elevation: widget.elevation,
            shadowColor: widget.shadowColor,
            borderRadius: widget.borderRadius,
            child: widget.child,
          ),
        ),
      ),
    );
  }

  void _setTouched(bool touched) {
    if (!touched) _touchPoints.remove(_key);
    if (widget.onClick == null || this.touched == touched) return;
    setState(() => this.touched = touched);
  }

  void _onTapDown(TapDownDetails details) {
    final touchPosition = details.globalPosition;
    if (_touchPoints.containsValue(touchPosition)) return;
    _touchPoints[_key] = touchPosition;
    _setTouched(true);
  }
}
