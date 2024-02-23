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
    return ColorFiltered(
      colorFilter: ColorFilter.mode(
        isTouched ? color : Colors.transparent,
        BlendMode.srcATop,
      ),
      child: child,
    );
  }
}
