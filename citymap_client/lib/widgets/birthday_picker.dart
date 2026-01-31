import 'dart:math' as Math;
import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/client_controller.dart';
import 'package:flutter_application_1/utils/screen_info.dart';

class BirthDayPicker extends StatefulWidget {
  final FocusNode? focusNode;
  final TextEditingController? controller;
  
  const BirthDayPicker({
    super.key,
    this.focusNode,
    this.controller
  });

  @override
  State<BirthDayPicker> createState() => _BirthDayPickerState();
}

class _BirthDayPickerState extends State<BirthDayPicker> {


  String _formatDate(String input) {
    final digitsOnly = input.replaceAll(RegExp(r'[^0-9]'), '');
    final clean = digitsOnly.substring(0, Math.min(digitsOnly.length, 8));

    if (clean.isEmpty) return '';

    final buffer = StringBuffer();
    for (int i = 0; i < clean.length; i++) {
      if (i == 2) buffer.write('.');
      if (i == 4) buffer.write('.');
      buffer.write(clean[i]);
    }
    return buffer.toString();
  }

  String? _validateDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Пожалуйста, введите дату рождения';
    }
    if (value.length < 10) {
      return 'Введите полную дату в формате ДД.ММ.ГГГГ';
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
      focusNode: widget.focusNode,
      style: TextStyle(
        color: client.theme.getColor("text4"),
        fontSize: ScreenInfo.getAdaptiveFontSize(14),
      ),
      validator: _validateDate,
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
        labelText: 'Дата рождения (ДД.ММ.ГГГГ)',
        prefixIcon: Icon(
          Icons.calendar_month,
          size: ScreenInfo.getAdaptiveValue(18),
          color: client.theme.getColor("iconInActive"),
        ),
        labelStyle: TextStyle(
          fontSize: ScreenInfo.getAdaptiveFontSize(10),
          color: client.theme.getColor("text2"),
        ),
        hintText: '31.12.2000',
        hintStyle: TextStyle(
          fontSize: ScreenInfo.getAdaptiveFontSize(12),
          color: client.theme.getColor("text2"),
        ),
        errorStyle: TextStyle(
          fontSize: ScreenInfo.getAdaptiveFontSize(10),
        ),
      ),
      keyboardType: TextInputType.number,
    );
  }
}