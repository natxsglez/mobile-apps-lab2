import 'dart:async';
import 'dart:developer';

import 'package:birds_museum/bloc/recognize_song_bloc/recognize_song_repository.dart';
import 'package:birds_museum/models/song_model.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'recognize_song_event.dart';
part 'recognize_song_state.dart';

class RecognizeSongBloc extends Bloc<RecognizeSongEvent, RecognizeSongState> {
  final RecognizeSongRepository _recognizeSongRepository;
  SongModel? _song;
  SongModel? get song => _song;

  RecognizeSongBloc({required recognizeSongRepository})
      : _recognizeSongRepository = recognizeSongRepository,
        super(RecognizeSongInitialState()) {
    on<DoRecognizeSongEvent>(_recognizeSongHandler);
  }

  FutureOr<void> _recognizeSongHandler(event, emit) async {
    log("recognizing");
    try {
      _song = await _recognizeSongRepository.recognizeSong(event.songPath);
      log("$_song");
      emit(RecognizeSongSuccessfulState());
    } catch (error) {
      emit(RecognizeSongErrorState());
    }
  }
}
