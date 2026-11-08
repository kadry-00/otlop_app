import 'package:flutter/material.dart';

class SmoothPageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;

  SmoothPageRoute({
    required this.page,
    super.settings,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: const Duration(milliseconds: 320),
          reverseTransitionDuration: const Duration(milliseconds: 280),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
              reverseCurve: Curves.easeInCubic,
            );

            final slideAnimation = Tween<Offset>(
              begin: const Offset(0.06, 0),
              end: Offset.zero,
            ).animate(curvedAnimation);

            final fadeAnimation = Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(curvedAnimation);

            return FadeTransition(
              opacity: fadeAnimation,
              child: SlideTransition(
                position: slideAnimation,
                child: child,
              ),
            );
          },
        );
}

void navigateSmoothly(BuildContext context, Widget targetScreen, {bool replace = false, bool clearStack = false}) {
  if (clearStack) {
    Navigator.pushAndRemoveUntil(
      context,
      SmoothPageRoute(page: targetScreen),
      (route) => false,
    );
  } else if (replace) {
    Navigator.pushReplacement(
      context,
      SmoothPageRoute(page: targetScreen),
    );
  } else {
    Navigator.push(
      context,
      SmoothPageRoute(page: targetScreen),
    );
  }
}
