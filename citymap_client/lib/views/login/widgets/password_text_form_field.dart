import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/client_controller.dart';
import 'package:flutter_application_1/utils/screen_info.dart';


class PasswordTextFormField extends StatefulWidget {
  const PasswordTextFormField({super.key});

  @override
  State<PasswordTextFormField> createState() => _PasswordTextFormFieldState();
}

class _PasswordTextFormFieldState extends State<PasswordTextFormField> {

  final TextEditingController controller = TextEditingController();

  bool badLoginPassword = false;
  String password = '';


  String? validate(String? value){
    if(value == null) return "";

    if (value == ""){
      return "Пожалуйста, введите пароль.";
    }
    if(value.length < 8){
      return "Пароль должен содеражить минимум 8 символов.";
    }

    if (badLoginPassword){
      badLoginPassword = false;
      return "Плохой логин или пароль!";
    }

  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) => validate(value),
      controller: controller,
      style: TextStyle(color: client.theme.getColor("text4")),
      obscureText: true,
      onChanged: (value) => setState(() {
        debugPrint(value);
        password=value;
      }),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20)
          
        ),
        labelText: 'Пароль',
        
        prefixIcon: Icon(Icons.lock, size: 18, color: client.theme.getColor("iconInActive")),
        labelStyle: TextStyle(fontSize: 10, textBaseline: TextBaseline.alphabetic, color: client.theme.getColor("text2"))
        
      ),
    
      
    );
  }
}