import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class UploadPhotoRepository{
  Future<String> uploadPhoto(String photoName , File photo) async{
    final reference = FirebaseStorage.instance.ref().child('books/$photoName');

    final uploadTask = reference.putFile(photo);

    await uploadTask.whenComplete(() => ((){}));

    final downloadLink = await reference.getDownloadURL();

    return downloadLink;
  }
}