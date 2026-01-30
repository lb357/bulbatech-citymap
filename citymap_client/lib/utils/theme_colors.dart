




import 'package:flutter/material.dart';

enum ThemeColors {

  text1(data: Color.fromARGB(255, 5, 97, 100)),
  text2(data: Color.fromARGB(255, 168, 172, 173)),
  text3(data: Color.fromARGB(255, 249, 249, 249)),
  text4(data: Color.fromARGB(255, 0, 0, 0)),
  heading(data: Color.fromARGB(255, 43, 47, 47)),
  iconActive(data : Color.fromARGB(255, 66, 153, 162)),
  iconInActive(data: Color.fromARGB(255, 124, 127, 128)),
  selectionMenuText(data: Color.fromARGB(255, 168, 172, 173)),
  
  bg(data: Colors.white),
  bg2(data: Color.fromARGB(255, 242, 243, 247)),


  text1_d(data: Color.fromARGB(255, 102, 204, 208)), 
  text2_d(data: Color.fromARGB(255, 168, 172, 173)), 
  text3_d(data: Color.fromARGB(255, 249, 249, 249)),
  text4_d(data: Color.fromARGB(255, 255, 255, 255)),
  heading_d(data: Color.fromARGB(255, 220, 240, 242)),
  iconActive_d(data : Color.fromARGB(255, 66, 153, 162)),
  iconInActive_d(data: Color.fromARGB(255, 253, 253, 253)),
  selectionMenuText_d(data: Color.fromARGB(255, 255, 255, 255)),
  bg_d(data: Color.fromARGB(255, 40, 48, 54)),      
  bg2_d(data: Color.fromARGB(255, 28, 32, 34)); 

  String get elementName => name;


  const ThemeColors({required this.data});

  final Color data;


}

