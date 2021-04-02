import 'package:flutter/material.dart';
import 'package:icapps_architecture/src/util/environment/environment_util.dart';

/// Page route that fades in the child page
class FadeInRoute<T> extends PageRouteBuilder<T> {
  final Widget child;
  final Curve curve;
  final Duration duration;

  FadeInRoute({
    required this.child,
    this.curve = Curves.linear,
    RouteSettings? settings,
    this.duration = const Duration(milliseconds: 300),
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
          settings: settings,
          transitionDuration: isInTest ? const Duration(seconds: 0) : duration,
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
}
