import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/upload_repo/upload_book_repo.dart';
import '../../repository/upload_repo/upload_photo_repo.dart';

part 'upload_event.dart';
part 'upload_state.dart';

class UploadBloc extends Bloc<UploadEvent, UploadState> {
  final UploadBookRepository uploadBookRepository;
  final UploadPhotoRepository uploadPhotoRepository;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  UploadBloc(this.uploadBookRepository, this.uploadPhotoRepository) : super(UploadInitialState()) {
    on<UploadButtonPressEvent>(_uploadButtonPressEvent);
    // on<UploadPdfTextChangeEvent>(_uploadPdfTextChangeEvent);
  }
  Future<void> _uploadButtonPressEvent(
      UploadButtonPressEvent event, Emitter<UploadState> emit) async {
    emit(UploadLoadingState());
    try {
      // Upload PDF
      String pdfDownloadLink = await uploadBookRepository.uploadBook(event.pdfName, event.pdf);

      // Upload Photo
      String photoDownloadLink = await uploadPhotoRepository.uploadPhoto(event.photoName, event.photo);

      // Add metadata to Firestore
      await firebaseFirestore.collection('books').add({
        "authorName":event.authorName,
        "bookDescription":event.description,
        "bookName": event.bookName,
        "category":event.category,
        "pdfUrl": pdfDownloadLink,
        "photoUrl": photoDownloadLink,
      });
      emit(UploadSuccessState(successMessage: "Book's PDF and cover photo have been uploaded"));
    } catch (e) {
      emit(UploadErrorState(errorUploadMessage: "Unable to upload PDF and photo. Please try again."));
    }
  }
}
