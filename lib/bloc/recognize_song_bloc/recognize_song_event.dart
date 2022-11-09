part of 'recognize_song_bloc.dart';

abstract class RecognizeSongEvent extends Equatable {
  const RecognizeSongEvent();

  @override
  List<Object> get props => [];
}

class DoRecognizeSongEvent extends RecognizeSongEvent {}
