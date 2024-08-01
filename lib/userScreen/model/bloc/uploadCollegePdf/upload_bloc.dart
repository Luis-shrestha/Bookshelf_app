import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shelf/userScreen/model/repository/uploadCollegePdf/upload_college_pdf_repo.dart';
import 'package:shelf/userScreen/model/repository/uploadCollegePdf/upload_subject_photo_repo.dart';
import '../../repository/upload_repo/upload_book_repo.dart';
import '../../repository/upload_repo/upload_photo_repo.dart';

part 'upload_event.dart';
part 'upload_state.dart';

class UploadCollegePdfBloc extends Bloc<UploadCollegePdfEvent, UploadCollegePdfState> {
  final UploadCollegePdfRepository uploadCollegePdfRepository;
  final UploadSubjectPhotoRepository uploadSubjectPhotoRepository;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  UploadCollegePdfBloc(this.uploadCollegePdfRepository, this.uploadSubjectPhotoRepository) : super(UploadInitialState()) {
    on<UploadButtonPressEvent>(_uploadButtonPressEvent);
    // on<UploadPdfTextChangeEvent>(_uploadPdfTextChangeEvent);
  }
  Future<void> _uploadButtonPressEvent(
      UploadButtonPressEvent event, Emitter<UploadCollegePdfState> emit) async {
    emit(UploadLoadingState());
    try {
      // Upload PDF
      String pdfDownloadLink = await uploadCollegePdfRepository.uploadCollegePdf(event.pdfName, event.pdf);

      // Upload Photo
      String photoDownloadLink = await uploadSubjectPhotoRepository.uploadSubjectPhoto(event.photoName, event.photo);

      // Add metadata to Firestore
      await firebaseFirestore.collection('collegePdf').add({
        "authorName":event.authorName,
        "bookDescription":event.description,
        "chapterName": event.chapterName,
        "subjectName":event.subjectName,
        "semester":event.semester,
        "pdfUrl": pdfDownloadLink,
        "photoUrl": photoDownloadLink,
      });
      emit(UploadSuccessState(successMessage: "Book's PDF and cover photo have been uploaded"));
    } catch (e) {
      emit(UploadErrorState(errorUploadMessage: "Unable to upload PDF and photo. Please try again."));
    }
  }
}
