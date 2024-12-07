import 'package:flutter/material.dart';

class PageTransitionBuilderCustom extends PageTransitionsBuilder {
  const PageTransitionBuilderCustom();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    // Define uma transição personalizada
    const begin = Offset(0.0, 1.0); // Começa de baixo
    const end = Offset.zero; // Termina na posição original
    const curve = Curves.easeInOut; // Curva de animação suave

    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
    var offsetAnimation = animation.drive(tween);

    return SlideTransition(
      position: offsetAnimation,
      child: FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }
}
