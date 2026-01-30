import 'package:flutter/material.dart';

enum TicketState {
  onReview(
    text: "Ожидает ответа",
    textIconColor: Color.fromARGB(255, 235, 107, 3),
    bgColor: Color.fromARGB(255, 255, 224, 178),
    icon: Icons.hourglass_top
  ),

  rejected(
    text: "Удален",
    textIconColor: Color.fromARGB(255, 235, 22, 3),
    bgColor: Color.fromARGB(255, 255, 186, 178),
    icon: Icons.close
  ),

  approved(
    text: "Получен официальный ответ",
    textIconColor: Color.fromARGB(255, 38, 50, 187),
    bgColor: Color.fromARGB(255, 178, 191, 255),
    icon: Icons.check
  );


  const TicketState({

    required this.text,
    required this.bgColor,
    required this.textIconColor,
    required this.icon

  });

  final String text;
  final Color bgColor;
  final Color textIconColor;
  final IconData icon;

}