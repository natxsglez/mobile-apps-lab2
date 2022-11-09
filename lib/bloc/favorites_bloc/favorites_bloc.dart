import 'dart:async';

import 'package:birds_museum/bloc/favorites_bloc/favorites_repository.dart';
import 'package:birds_museum/models/song_model.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'favorites_event.dart';
part 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final FavoritesRepository _favoritesRepository;
  FavoritesBloc({required favoritesRepository})
      : _favoritesRepository = favoritesRepository,
        super(FavoritesInitialState()) {
    on<FavoritesEvent>((event, emit) {
      on<AddFavoriteEvent>(_addSongHandler);
      on<RemoveFavoriteEvent>(_removeSongHandler);
    });
  }

  FutureOr<void> _addSongHandler(event, emit) async {
    try {
      await _favoritesRepository.addSong(event.song, event.uid);
      emit(AddFavoriteSuccessState());
    } catch (error) {
      emit(AddFavoriteErrorState());
    }
  }

  FutureOr<void> _removeSongHandler(event, emit) async {
    try {
      await _favoritesRepository.removeSong(event.song, event.uid);
      emit(RemoveFavoriteSuccessState());
    } catch (error) {
      emit(RemoveFavoriteErrorState());
    }
  }
}
