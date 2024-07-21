import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../model/repository/upload_repo/upload_photo_repo.dart';

class PhotoUploadHelper {
  final UploadPhotoRepository uploadPhotoRepository;
  final FirebaseFirestore firebaseFirestore;

  PhotoUploadHelper({
    required this.uploadPhotoRepository,
    required this.firebaseFirestore,
  });

  Future<String> uploadCoverPhoto(String photoName, File selectedPhoto) async {
    if (photoName.isNotEmpty && selectedPhoto.existsSync()) {
      print('Starting upload for: $photoName');
      final downloadLink = await uploadPhotoRepository.uploadPhoto(photoName, selectedPhoto);
      print('Upload successful: $photoName');
      return downloadLink;
    } else {
      throw Exception('No file selected or fileName is null');
    }
  }
}
