import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shelf/userScreen/model/repository/uploadCollegePdf/upload_subject_photo_repo.dart';
import '../../model/repository/upload_repo/upload_photo_repo.dart';

class SubjectPhotoUploadHelper {
  final UploadSubjectPhotoRepository uploadSubjectPhotoRepository;
  final FirebaseFirestore firebaseFirestore;

  SubjectPhotoUploadHelper({
    required this.uploadSubjectPhotoRepository,
    required this.firebaseFirestore,
  });

  Future<String> uploadCoverPhoto(String photoName, File selectedPhoto) async {
    if (photoName.isNotEmpty && selectedPhoto.existsSync()) {
      print('Starting upload for: $photoName');
      final downloadLink = await uploadSubjectPhotoRepository.uploadSubjectPhoto(photoName, selectedPhoto);
      print('Upload successful: $photoName');
      return downloadLink;
    } else {
      throw Exception('No file selected or fileName is null');
    }
  }
}
