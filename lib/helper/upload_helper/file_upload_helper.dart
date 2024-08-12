import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../userScreen/model/repository/upload_repo/upload_book_repo.dart';


class FileUploadHelper {
  final UploadBookRepository uploadPdfRepository;
  final FirebaseFirestore firebaseFirestore;

  FileUploadHelper({
    required this.uploadPdfRepository,
    required this.firebaseFirestore,
  });

  Future<String> uploadFile(String fileName, File selectedFile) async {
    if (fileName.isNotEmpty && selectedFile.existsSync()) {
      print('Starting upload for: $fileName');
      final downloadLink = await uploadPdfRepository.uploadBook(fileName, selectedFile);
      print('Upload successful: $fileName');
      return downloadLink;
    } else {
      throw Exception('No file selected or fileName is null');
    }
  }
}
