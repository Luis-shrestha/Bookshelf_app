part of 'upload_bloc.dart';

abstract class UploadEvent {}

class UploadButtonPressEvent extends UploadEvent {
  final String pdfName;
  final File pdf;
  final String photoName;
  final File photo;
  final String authorName;
  final String bookName;
  final String description;
  final String category;

  UploadButtonPressEvent({
    required this.pdfName,
    required this.pdf,
    required this.photoName,
    required this.photo,
    required this.authorName,
    required this.bookName,
    required this.description,
    required this.category,
  });
}
