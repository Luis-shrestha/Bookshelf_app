part of 'upload_bloc.dart';

abstract class UploadCollegePdfEvent {}

class UploadButtonPressEvent extends UploadCollegePdfEvent {
  final String pdfName;
  final File pdf;
  final String photoName;
  final File photo;
  final String authorName;
  final String chapterName;
  final String description;
  final String subjectName;
  final String semester;

  UploadButtonPressEvent({
    required this.pdfName,
    required this.pdf,
    required this.photoName,
    required this.photo,
    required this.authorName,
    required this.chapterName,
    required this.description,
    required this.subjectName,
    required this.semester,
  });
}
