import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/theme_colors.dart';


class ThemeManager {

  bool dark;

  Color getColor(String name){

    name = (dark)? "${name}_d" : name; 

    for(ThemeColors color in ThemeColors.values){
      if(color.name == name) return color.data;
    }

    return Colors.black;
  }


  void switchTheme() {
    dark = !dark;
  }

  ThemeManager({
    required this.dark
  });

}
