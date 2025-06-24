// flutter
import 'package:flutter/widgets.dart';

SlideTransition buildVerticalSlideTransitiron(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  const begin = Offset(0.0, 1.0);
  const end = Offset.zero;
  const curve = Curves.easeOut;

  var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
  return SlideTransition(
    position: animation.drive(tween),
    child: child,
  );
}

SlideTransition buildHorizontalSlideTransitiron(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  const begin = Offset(1.0, 0.0);
  const end = Offset.zero;
  const curve = Curves.easeOut;

  var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
  return SlideTransition(
    position: animation.drive(tween),
    child: child,
  );
}
