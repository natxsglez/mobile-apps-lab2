import 'package:birds_museum/bloc/auth_bloc/auth_bloc.dart';
import 'package:birds_museum/pages/fav_page/fav_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocProvider.of<AuthBloc>(context).currUser != null ||
              BlocProvider.of<AuthBloc>(context)
                  .currUser!
                  .favoriteSongs
                  .isNotEmpty
          ? FavoritesList(
              favoriteSongs:
                  BlocProvider.of<AuthBloc>(context).currUser!.favoriteSongs,
            )
          : _createNotFavoritesYetText(),
    );
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
