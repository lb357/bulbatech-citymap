
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerManager{

  static final ImagePicker _picker = ImagePicker();

  static Future<File?> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800, 
        maxHeight: 800, 
        imageQuality: 85, 
      );

      
      
      if (image != null) {
        return File(image.path);
      }
    } catch (e) {
      return null;
    }

    return null;
  }
}