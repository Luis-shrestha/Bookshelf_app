import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shelf/userScreen/model/repository/uploadCollegePdf/upload_college_pdf_repo.dart';
import '../../model/repository/upload_repo/upload_book_repo.dart';

class CollegePdfUploadHelper {
  final UploadCollegePdfRepository uploadCollegePdfRepository;
  final FirebaseFirestore firebaseFirestore;

  CollegePdfUploadHelper({
    required this.uploadCollegePdfRepository,
    required this.firebaseFirestore,
  });

  Future<String> uploadFile(String fileName, File selectedFile) async {
    if (fileName.isNotEmpty && selectedFile.existsSync()) {
      print('Starting upload for: $fileName');
      final downloadLink = await uploadCollegePdfRepository.uploadCollegePdf(fileName, selectedFile);
      print('Upload successful: $fileName');
      return downloadLink;
    } else {
      throw Exception('No file selected or fileName is null');
    }
  }
}
