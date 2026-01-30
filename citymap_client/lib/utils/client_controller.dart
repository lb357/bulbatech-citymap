import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/server.dart';
import 'package:flutter_application_1/utils/theme_manager.dart';

class ClientController {


  final ThemeManager theme;
  final String userId;
  final String firstname;
  final String lastname;
  final String patronymic;
  final String snils;
  final String birthdate;

  static Future<bool> init() async{


      String? status = await Server.user();

      if(status != null){
        dynamic clientData = jsonDecode(status);
        client = ClientController(
          userId: clientData["userId"]??"-1", 
          firstname: clientData["firstname"]??"-1", 
          lastname: clientData["lastname"]??"-1", 
          patronymic: clientData["patronymic"]??"-1", 
          snils: clientData["snils"]??"-1", 
          birthdate: clientData["birthdate"]??"-1",
          theme: ThemeManager(dark: false)
        );

        return true;
      }

      return false;

  }

  ClientController({
    required this.userId,
    required this.firstname,
    required this.lastname,
    required this.patronymic,
    required this.snils,
    required this.birthdate,
    required this.theme
  });

}


ClientController client = ClientController(
  theme: ThemeManager(dark: false), 
  userId: "-1",
  firstname: "",
  lastname: "",
  patronymic: "",
  birthdate: "",
  snils: ""
);