import 'package:flutter/material.dart';

class ColorTouchEffect extends StatelessWidget {
  final bool isTouched;
  final Color color;
  final Widget child;

  const ColorTouchEffect({
    required this.isTouched,
    required this.child,
    this.color = const Color(0x0A000000),
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 200),
      tween: ColorTween(
        begin: Colors.transparent,
        end: isTouched ? color : Colors.transparent,
      ),
      builder: (context, color, widget) => ColorFiltered(
        colorFilter: ColorFilter.mode(
          color ?? Colors.transparent,
          BlendMode.srcATop,
        ),
        child: child,
      ),
    );
  }
}
