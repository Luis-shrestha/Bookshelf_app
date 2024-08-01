part of 'upload_bloc.dart';

abstract class UploadCollegePdfState{}

class UploadInitialState extends UploadCollegePdfState{}

class UploadLoadingState extends UploadCollegePdfState{}

class UploadSuccessState extends UploadCollegePdfState{
  final String successMessage;

  UploadSuccessState({required this.successMessage});

  List<Object?> get props => [successMessage];
}

class UploadErrorState extends UploadCollegePdfState{
  final String errorUploadMessage;

  UploadErrorState({required this.errorUploadMessage});

  List<Object?> get props => [errorUploadMessage];
}

