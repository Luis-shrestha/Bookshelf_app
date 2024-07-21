part of 'upload_bloc.dart';

abstract class UploadState{}

class UploadInitialState extends UploadState{}

class UploadLoadingState extends UploadState{}

class UploadSuccessState extends UploadState{
  final String successMessage;

  UploadSuccessState({required this.successMessage});

  List<Object?> get props => [successMessage];
}

class UploadErrorState extends UploadState{
  final String errorUploadMessage;

  UploadErrorState({required this.errorUploadMessage});

  List<Object?> get props => [errorUploadMessage];
}

