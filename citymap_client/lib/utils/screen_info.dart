import 'package:flutter/material.dart';

class ScreenInfo {
  static double screenWidth = 360.0;  
  static double screenHeight = 640.0; 
  
  
  static void init(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
  }
  
  static double getWidthFactor() {
    if (screenWidth < 400) {
      return 0.95;
    } else if (screenWidth < 600) {
      return 0.92;
    } else if (screenWidth < 800) {
      return 0.85;
    } else {
      return 0.7;
    }
  }
  
  static double getAdaptiveValue(double baseValue) {
    if (screenWidth < 360) {
      return baseValue * 0.8;
    } else if (screenWidth < 400) {
      return baseValue * 0.9;
    } else if (screenWidth > 800) {
      return baseValue * 1.2;
    }
    return baseValue;
  }
  
  static double getAdaptiveFontSize(double baseSize) {
    if (screenWidth < 360) {
      return baseSize * 0.85;
    } else if (screenWidth < 400) {
      return baseSize * 0.9;
    } else if (screenWidth > 800) {
      return baseSize * 1.15;
    }
    return baseSize;
  }
}