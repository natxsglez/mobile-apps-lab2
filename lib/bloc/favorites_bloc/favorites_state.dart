part of 'favorites_bloc.dart';

abstract class FavoritesState extends Equatable {
  const FavoritesState();

  @override
  List<Object> get props => [];
}

class FavoritesInitialState extends FavoritesState {}

class AddFavoriteSuccessState extends FavoritesState {}

class RemoveFavoriteSuccessState extends FavoritesState {}

class AddFavoriteErrorState extends FavoritesState {}

class RemoveFavoriteErrorState extends FavoritesState {}
