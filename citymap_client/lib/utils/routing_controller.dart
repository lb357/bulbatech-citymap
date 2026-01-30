import 'package:flutter/material.dart';

class RoutingController {

  static Route createRoute(Widget child, bool? animate){
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child){

        double y = 0;

        if (animate != null && animate){
          y = 1.0;
        }

        Offset begin = Offset(0, y);
        const end = Offset.zero;
        const curve = Curves.ease;

        Animatable<Offset> tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),

          child: child,
        );
      }
    );
  }

  static void deltePreviousViewAndGoto(Widget child, BuildContext context, bool? animate){

    animate ??= false;

    Navigator.pop(context);
    Navigator.push(context, createRoute(child, animate));

  }

}