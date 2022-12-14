import 'package:birds_museum/bloc/auth_bloc/auth_bloc.dart';
import 'package:birds_museum/bloc/favorites_bloc/favorites_bloc.dart';
import 'package:birds_museum/models/song_model.dart';
import 'package:birds_museum/pages/fav_page/fav_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoritesPage extends StatefulWidget {
  FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<SongModel> favoriteSongs = [];

  @override
  Widget build(BuildContext context) {
    favoriteSongs = BlocProvider.of<AuthBloc>(context).currUser!.favoriteSongs;
    setState(() {});
    return Scaffold(
        appBar: AppBar(),
        body: BlocListener<FavoritesBloc, FavoritesState>(
          listener: (context, state) {
            if (state is AddFavoriteSuccessState ||
                state is RemoveFavoriteEvent) {
              BlocProvider.of<AuthBloc>(context).add(RefreshUserDataEvent());
            } else if (state is AuthRefreshedState) {
              favoriteSongs =
                  BlocProvider.of<AuthBloc>(context).currUser!.favoriteSongs;
              setState(() {});
            }
          },
          child: favoriteSongs.isNotEmpty
              ? FavoritesList(
                  favoriteSongs: BlocProvider.of<AuthBloc>(context)
                      .currUser!
                      .favoriteSongs,
                )
              : _createNotFavoritesYetText(),
        ));
  }

  Column _createNotFavoritesYetText() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              "Aún no tienes canciones guardadas",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ],
    );
  }
}
