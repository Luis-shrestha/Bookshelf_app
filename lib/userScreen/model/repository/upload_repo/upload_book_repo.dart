import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class UploadBookRepository{
  Future<String> uploadBook(String pdfName , File pdf) async{
    final reference = FirebaseStorage.instance.ref().child('books/$pdfName');

    final uploadTask = reference.putFile(pdf);

    await uploadTask.whenComplete(() => ((){}));

    final downloadLink = await reference.getDownloadURL();

    return downloadLink;
  }
}