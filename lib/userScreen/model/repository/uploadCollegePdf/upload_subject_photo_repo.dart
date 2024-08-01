import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class UploadSubjectPhotoRepository{
  Future<String> uploadSubjectPhoto(String photoName , File photo) async{
    final reference = FirebaseStorage.instance.ref().child('collegePdf/$photoName');

    final uploadTask = reference.putFile(photo);

    await uploadTask.whenComplete(() => ((){}));

    final downloadLink = await reference.getDownloadURL();

    return downloadLink;
  }
}