import 'dart:math' as Math;
import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/client_controller.dart';
import 'package:flutter_application_1/utils/screen_info.dart';

class SnilsPicker extends StatefulWidget {
  final FocusNode? focusNode;
  final TextEditingController? controller;
  
  const SnilsPicker({
    super.key,
    this.focusNode,
    this.controller
  });

  @override
  State<SnilsPicker> createState() => _SnilsPickerState();
}

class _SnilsPickerState extends State<SnilsPicker> {

  String _formatDate(String input) {
    final digitsOnly = input.replaceAll(RegExp(r'[^0-9]'), '');
    final clean = digitsOnly.substring(0, Math.min(digitsOnly.length, 10));

    if (clean.isEmpty) return '';

    final buffer = StringBuffer();
    for (int i = 0; i < clean.length; i++) {
      if (i == 3) buffer.write('-');debugPrint("PISKA4");
      if (i == 6) buffer.write('-');debugPrint("PISKA5");
      if (i == 8) buffer.write(' ');debugPrint("PISKA6");
      buffer.write(clean[i]);
    }
    return buffer.toString();
  }

  

  String? _validateSNILS(String? value) {
    if (value == null || value.isEmpty) {
      return 'Пожалуйста, введите СНИЛС.';
    }
    if (value.length < 10) {
      return 'Неверный ввод.';
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
      controller: widget.controller,
      keyboardType: TextInputType.datetime,
      focusNode: widget.focusNode,
      style: TextStyle(
        color: client.theme.getColor("text4"),
        fontSize: ScreenInfo.getAdaptiveFontSize(14),
      ),
      validator: _validateSNILS,
      onChanged: (String newText) {
        final formatted = _formatDate(newText);
        if (formatted != widget.controller?.text) {
          widget.controller?.value = TextEditingValue(
            text: formatted,
            selection: TextSelection.collapsed(offset: formatted.length),
          );
        }
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ScreenInfo.getAdaptiveValue(20)),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: ScreenInfo.getAdaptiveValue(16),
          vertical: ScreenInfo.getAdaptiveValue(14),
        ),
        labelText: 'СНИЛС',
        prefixIcon: Icon(
          Icons.article,
          size: ScreenInfo.getAdaptiveValue(18),
          color: client.theme.getColor("iconInActive"),
        ),
        labelStyle: TextStyle(
          fontSize: ScreenInfo.getAdaptiveFontSize(10),
          color: client.theme.getColor("text2"),
        ),
        hintText: '000-000-000 00',
        hintStyle: TextStyle(
          fontSize: ScreenInfo.getAdaptiveFontSize(12),
          color: client.theme.getColor("text2"),
        ),
        errorStyle: TextStyle(
          fontSize: ScreenInfo.getAdaptiveFontSize(10),
        ),
      ),
    );
  }
}