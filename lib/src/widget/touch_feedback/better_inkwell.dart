import 'package:flutter/material.dart';

class BetterInkwell extends StatefulWidget {
  final Color colorHover;
  final Color colorPress;
  final Widget child;
  final VoidCallback? onTap;
  final HitTestBehavior? behavior;

  const BetterInkwell({
    required this.child,
    this.onTap,
    this.behavior,
    this.colorHover = const Color(0x0A000000),
    this.colorPress = const Color(0x1E000000),
    super.key,
  });

  @override
  State<BetterInkwell> createState() => _BetterInkwellState();
}

class _BetterInkwellState extends State<BetterInkwell>
    with SingleTickerProviderStateMixin {
  var _isTouched = false;
  var _touchPosition = Offset.zero;
  static const durationSeconds = 10;
  static const speed = 1000 * durationSeconds;

  /// Set by a child to ignore touch events when the child
  /// handles the touch event itself
  var ignoreTouch = false;

  late final _animationController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: durationSeconds),
  );

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details, BuildContext context) {
    if (ignoreTouch) {
      ignoreTouch = false;
      return;
    }
    _touchPosition = details.localPosition;
    _isTouched = true;
    _animationController
      ..reset()
      ..forward();
    setState(() {});

    var ancestor = context.findAncestorStateOfType<_BetterInkwellState>();
    do {
      ancestor?.ignoreTouch = true;
      ancestor =
          ancestor?.context.findAncestorStateOfType<_BetterInkwellState>();
    } while (ancestor != null);
  }

  void _onTapUp(TapUpDetails details) {
    if (_isTouched) widget.onTap?.call();
    _isTouched = false;
    setState(() {});
  }

  void _onTapCancel() {
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
        animation: _animationController,
        builder: (context, child) => Stack(
          children: [
            Container(
              color: Colors.transparent,
              child: child!,
            ),
            Positioned.fill(
              child: IgnorePointer(
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: _isTouched ? 1 : 0,
                  child: CustomPaint(
                    painter: _RipplePainter(
                      center: _touchPosition,
                      radius: _animationController.value * speed,
                      color: widget.colorPress,
                    ),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: IgnorePointer(
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: _isTouched ? 1 : 0,
                  child: Container(
                    color: widget.colorHover,
                  ),
                ),
              ),
            ),
          ],
        ),
        child: widget.child,
      ),
    );
  }
}

class _RipplePainter extends CustomPainter {
  final Offset center;
  final double radius;
  final Color color;

  _RipplePainter({
    required this.center,
    required this.radius,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) =>
      oldDelegate is! _RipplePainter ||
      oldDelegate.center != center ||
      oldDelegate.radius != radius;
}
