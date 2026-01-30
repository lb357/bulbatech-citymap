
import 'package:flutter/material.dart';

class UserLoginData{

  final String email;
  final String password;


  UserLoginData({
    required this.email,
    required this.password

  });
}

class UserRegisterData{

  final String email;
  final String password;
  final String birthday;
  final String name;
  final String surname;
  final String snils;

  String? patronymic;


  UserRegisterData({
    required this.email,
    required this.password,
    required this.birthday,
    required this.name,
    required this.surname,
    required this.snils,
    this.patronymic
  });
}

class TicketData{

  final int category;
  final String title;
  final String text;
  String? icon = "";
  List<double> point = [0.0, 0.0];


  TicketData({

    required this.title,
    required this.category,
    required this.text,

    required this.point,

  });

}

