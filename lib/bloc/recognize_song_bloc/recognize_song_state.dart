part of 'recognize_song_bloc.dart';

abstract class RecognizeSongState extends Equatable {
  const RecognizeSongState();

  @override
  List<Object> get props => [];
}

class RecognizeSongInitialState extends RecognizeSongState {}

class StartRecognizingSongState extends RecognizeSongState {}

class RecognizingSongState extends RecognizeSongState {}

class RecognizeSongErrorState extends RecognizeSongState {}

class RecognizeSongSuccessfulState extends RecognizeSongState {}
