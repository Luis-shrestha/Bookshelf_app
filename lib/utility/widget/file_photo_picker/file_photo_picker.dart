import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

Future<void> pickFile(BuildContext context, Function(String, File) onFilePicked) async {
  try {
    final pickedFile = await FilePicker.platform.pickFiles(
      allowedExtensions: ['pdf'],
      type: FileType.custom,
    );

    if (pickedFile != null && pickedFile.files.isNotEmpty) {
      final fileName = pickedFile.files.first.name;
      final selectedFile = File(pickedFile.files.first.path!);
      onFilePicked(fileName, selectedFile);
      print('File selected: $fileName');
    } else {
      print('File picking cancelled or failed');
    }
  } catch (e) {
    print('Error picking file: $e');
  }
}

Future<void> pickPhoto(BuildContext context, Function(String, File) onPhotoPicked) async {
  try {
    final pickedPhoto = await FilePicker.platform.pickFiles(
      allowedExtensions: ['jpg', 'jpeg', 'png', 'webp'],
      type: FileType.custom,
    );

    if (pickedPhoto != null && pickedPhoto.files.isNotEmpty) {
      final photoName = pickedPhoto.files.first.name;
      final selectedPhoto = File(pickedPhoto.files.first.path!);
      onPhotoPicked(photoName, selectedPhoto);
      print('Photo selected: $photoName');
    } else {
      print('Photo picking cancelled or failed');
    }
  } catch (e) {
    print('Error picking photo: $e');
  }
}
