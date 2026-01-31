import 'package:flutter/material.dart';

enum TicketType {
  sport(
    alias: "Спорт",
    icon: "🏃‍♂️",
    iconData: Icons.sports_martial_arts_rounded,
    bgColor: Color.fromARGB(255, 222, 220, 252),
  ),
  culture(
    alias: "Культура",
    icon: "🏛️",
    iconData: Icons.account_balance_rounded,
    bgColor: Color.fromARGB(255, 250, 252, 220),
  ),
  nature(
    alias: "Экология",
    icon: "🌲",
    iconData: Icons.park_rounded,
    bgColor: Color.fromARGB(255, 220, 252, 231),
  ),
  childCare(
    alias: "Детский досуг",
    icon: "⚽",
    iconData: Icons.sports_soccer_rounded,
    bgColor: Color.fromARGB(255, 252, 220, 247),
  ),
  sociality(
    alias: "Социальное",
    icon: "🤝",
    iconData: Icons.handshake_rounded,
    bgColor: Color.fromARGB(255, 252, 239, 220),
  ),
  other(
    alias: "Другое",
    icon: "❓",
    iconData: Icons.question_mark_rounded,
    bgColor: Color.fromARGB(255, 220, 252, 249),
  );

  const TicketType({
    required this.alias,
    required this.icon,
    required this.iconData,
    required this.bgColor,
  });

  final String alias;
  final String icon;
  final IconData iconData;
  final Color bgColor;

  int get typeIndex  => TicketType.values.indexOf(this);
}