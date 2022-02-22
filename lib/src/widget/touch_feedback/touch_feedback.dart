import 'package:flutter/material.dart';
import 'package:icapps_architecture/icapps_architecture.dart';

/// Helper class for platform-specific touch feedback
///
/// On devices running with the android theme, this will create a ripple effect,
/// on other devices, this will create a scaling touch down effect
class TouchFeedBack extends StatelessWidget {
  final Widget child;
  final VoidCallback? onClick;
  final Color? androidSplashColor;
  final Color color;
  final BorderRadius? borderRadius;
  final double elevation;
  final Color? shadowColor;
  final ShapeBorder? shapeBorder;

  const TouchFeedBack({
    required this.child,
    required this.onClick,
    this.borderRadius,
    this.androidSplashColor,
    this.color = Colors.transparent,
    this.elevation = 0,
    this.shadowColor,
    this.shapeBorder,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (context.isAndroidTheme) {
      return _buildAndroid();
    }
    return TouchFeedBackIOS(
      child: child,
      onClick: onClick,
      color: color,
      borderRadius: borderRadius,
      elevation: elevation,
      shadowColor: shadowColor,
      shapeBorder: shapeBorder,
    );
  }

  Widget _buildAndroid() {
    return Material(
      borderRadius: borderRadius,
      color: color,
      elevation: elevation,
      shadowColor: shadowColor,
      shape: shapeBorder,
      child: onClick == null
          ? child
          : InkWell(
              customBorder: shapeBorder,
              borderRadius: borderRadius,
              splashColor: androidSplashColor,
              onTap: onClick,
              child: child,
            ),
    );
  }
}

class TouchFeedBackIOS extends StatefulWidget {
  final Widget child;
  final VoidCallback? onClick;
  final Color color;
  final BorderRadius? borderRadius;
  final ShapeBorder? shapeBorder;
  final double elevation;
  final Color? shadowColor;

  const TouchFeedBackIOS({
    required this.child,
    required this.onClick,
    this.borderRadius,
    this.color = Colors.transparent,
    this.shapeBorder,
    this.shadowColor,
    this.elevation = 0,
    Key? key,
  }) : super(key: key);

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
  Widget build(BuildContext context) {
    return GestureDetector(
      excludeFromSemantics: widget.onClick == null,
      onTapDown: _onTapDown,
      onTap: widget.onClick,
      onTapCancel: () => _setTouched(false),
      onTapUp: (details) => _setTouched(false),
      child: Transform.scale(
        scale: touched ? touchScale : defaultScale,
        child: Material(
          borderRadius: widget.borderRadius,
          color: widget.color,
          child: widget.child,
          shape: widget.shapeBorder,
          elevation: widget.elevation,
          shadowColor: widget.shadowColor,
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
