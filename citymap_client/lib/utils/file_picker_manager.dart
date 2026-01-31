

import 'dart:io';

import 'package:file_selector/file_selector.dart';

class FilePickerManager{

  static XTypeGroup typeGroup = XTypeGroup(
    label: 'images',
    extensions: <String>['pdf', 'docx', 'doc'],
    uniformTypeIdentifiers: <String>['public.pdf', 'public.docx', 'public.doc'],
  );




  static Future<File?> selectFile() async{

    final XFile? file = await openFile(
      acceptedTypeGroups: <XTypeGroup>[typeGroup],
    );

    if (file == null) return null;

    final File _resultFile = File(file.path);

    return _resultFile;

  }

}