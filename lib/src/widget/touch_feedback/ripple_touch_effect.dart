import 'package:flutter/material.dart';

class RippleTouchEffect extends StatelessWidget {
  final int durationSeconds;
  final bool isTouched;
  final Color colorHover;
  final Color colorPress;
  final Offset touchPosition;
  final BorderRadius? borderRadius;
  final AnimationController? animationController;

  const RippleTouchEffect({
    required this.isTouched,
    required this.touchPosition,
    required this.animationController,
    required this.durationSeconds,
    this.borderRadius,
    this.colorHover = const Color(0x0A000000),
    this.colorPress = const Color(0x1E000000),
    super.key,
  });

  int get speed => 1000 * durationSeconds;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: isTouched ? 1 : 0,
        child: CustomPaint(
          painter: _RipplePainter(
            center: touchPosition,
            radius: animationController!.value * speed,
            color: colorPress,
          ),
        ),
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
  bool shouldRepaint(covariant CustomPainter oldDelegate) => oldDelegate is! _RipplePainter || oldDelegate.center != center || oldDelegate.radius != radius;
}
