import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/screen_info.dart';

import '../utils/client_controller.dart';

class PasswordTextFormField extends StatefulWidget {

  final TextEditingController? controller;

  const PasswordTextFormField(
    {
      super.key,
      this.controller
    }
  );


  @override
  State<PasswordTextFormField> createState() => _PasswordTextFormFieldState();
}

class _PasswordTextFormFieldState extends State<PasswordTextFormField> {
  bool badLoginPassword = false;
  String password = '';

  String? validate(String? value) {
    
    if (value == null || value.isEmpty) {
      return "Пожалуйста, введите пароль.";
    }
    
    
    if (value.length < 8) {
      return "Пароль должен содержать минимум 8 символов.";
    }

    
    if (badLoginPassword) {
      badLoginPassword = false;
      return "Неверный логин или пароль!";
    }

    return null; 
  }

  @override
  void dispose() {
    widget.controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) => validate(value),
      controller: widget.controller,
      style: TextStyle(
        color: client.theme.getColor("text4"),
        fontSize: ScreenInfo.getAdaptiveFontSize(14), 
      ),
      obscureText: true,
      onChanged: (value) => setState(() {
        password = value; 
      }),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ScreenInfo.getAdaptiveValue(20)), 
        ),
        contentPadding: EdgeInsets.symmetric( 
          horizontal: ScreenInfo.getAdaptiveValue(16),
          vertical: ScreenInfo.getAdaptiveValue(14),
        ),
        labelText: 'Пароль',
        prefixIcon: Icon(
          Icons.lock, 
          size: ScreenInfo.getAdaptiveValue(18), 
          color: client.theme.getColor("iconInActive")
        ),
        labelStyle: TextStyle(
          fontSize: ScreenInfo.getAdaptiveFontSize(10), 
          color: client.theme.getColor("text2")
        ),
        errorStyle: TextStyle( 
          fontSize: ScreenInfo.getAdaptiveFontSize(10),
        ),
      ),
    );
  }
}