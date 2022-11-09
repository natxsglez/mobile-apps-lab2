part of 'favorites_bloc.dart';

abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();

  @override
  List<dynamic> get props => [];
}

class AddFavoriteEvent extends FavoritesEvent {
  final SongModel songToAdd;
  final String uid;

  const AddFavoriteEvent({required this.songToAdd, required this.uid});

  @override
  List<dynamic> get props => [songToAdd, uid];
}

class RemoveFavoriteEvent extends FavoritesEvent {
  final SongModel songToRemove;
  final String uid;

  const RemoveFavoriteEvent({required this.songToRemove, required this.uid});

  @override
  List<dynamic> get props => [songToRemove, uid];
}
