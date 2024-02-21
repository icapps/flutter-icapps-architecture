import 'package:flutter/material.dart';

class ColorTouchEffect extends StatelessWidget {
  final bool isTouched;
  final Color color;
  final BorderRadius? borderRadius;

  const ColorTouchEffect({
    required this.isTouched,
    required this.borderRadius,
    this.color = const Color(0x0A000000),
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: isTouched ? 1 : 0,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          color: color,
        ),
      ),
    );
  }
}
