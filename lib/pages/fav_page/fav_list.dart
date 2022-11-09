import 'package:birds_museum/bloc/favorites_bloc/favorites_bloc.dart';
import 'package:birds_museum/models/song_model.dart';
import 'package:birds_museum/pages/fav_page/fav_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoritesList extends StatelessWidget {
  final List<SongModel> favoriteSongs;
  const FavoritesList({super.key, required this.favoriteSongs});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        BlocListener<FavoritesBloc, FavoritesState>(
          listener: (context, state) {
            if (state is RemoveFavoriteErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    "Error al remover canción de la lista",
                  ),
                ),
              );
            }
          },
          child: Container(),
        ),
        Expanded(
            child: ListView.builder(
                itemCount: favoriteSongs.length,
                itemBuilder: (BuildContext context, int index) {
                  return FavoriteItem(favItem: favoriteSongs[index]);
                }))
      ],
    );
  }
}
