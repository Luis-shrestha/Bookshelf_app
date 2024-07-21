
part of 'fetch_book_bloc.dart';

abstract class FetchBookState{}

class FetchBookInitialState extends FetchBookState{}

class FetchBookLoadingState extends FetchBookState{}

class FetchBookSuccessState extends FetchBookState{}

class FetchBookErrorState extends FetchBookState{
  final String errorFetchingMessage;
  FetchBookErrorState({required this.errorFetchingMessage});
}
