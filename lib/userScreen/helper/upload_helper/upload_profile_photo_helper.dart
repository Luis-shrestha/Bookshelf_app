import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../model/repository/uploadProfile_repo.dart';

class UploadProfilePhotoHelper {
  final UploadProfilePhotoRepository uploadProfilePhotoRepository;
  final FirebaseFirestore firebaseFirestore;

  UploadProfilePhotoHelper({
    required this.uploadProfilePhotoRepository,
    required this.firebaseFirestore,
  });

  Future<String> uploadProfilePhoto(String photoName, File selectedPhoto) async {
    if (photoName.isNotEmpty && selectedPhoto.existsSync()) {
      print('Starting upload for: $photoName');
      final downloadLink = await uploadProfilePhotoRepository.uploadProfilePhoto(photoName, selectedPhoto);
      print('Upload successful: $photoName');
      return downloadLink;
    } else {
      throw Exception('No file selected or fileName is null');
    }
  }
}
