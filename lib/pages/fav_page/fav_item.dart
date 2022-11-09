import 'package:birds_museum/bloc/auth_bloc/auth_bloc.dart';
import 'package:birds_museum/bloc/favorites_bloc/favorites_bloc.dart';
import 'package:birds_museum/models/song_model.dart';
import 'package:birds_museum/pages/search_results/search_results.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoriteItem extends StatelessWidget {
  final SongModel favItem;
  const FavoriteItem({super.key, required this.favItem});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SearchResults(
                    songData: favItem,
                    isLikedSong: true,
                  )),
        );
      },
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(10),
        height: 300,
        width: 300,
        child: Stack(
          children: [
            _createImage(),
            _createFavoriteBtn(context),
            _createSongDetails()
          ],
        ),
      ),
    );
  }

  Positioned _createSongDetails() {
    return Positioned.fill(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.7),
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(25.0),
                bottomRight: Radius.circular(8.0),
                bottomLeft: Radius.circular(8.0)),
          ),
          width: 300,
          child: Column(
            children: [
              Text(
                favItem.songName,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(favItem.artist)
            ],
          ),
        ),
      ),
    );
  }

  Padding _createFavoriteBtn(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: IconButton(
          icon: const Icon(Icons.favorite),
          onPressed: () => showDialog(
                context: context,
                builder: (context) => _createDeleteAlertDialog(context),
              )),
    );
  }

  AlertDialog _createDeleteAlertDialog(BuildContext context) {
    return AlertDialog(
      title: const Text("Eliminar de favoritos"),
      content: const Text(
          "El elemento será eliminado de tus favoritos ¿Quieres continuar?"),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Cancelar"),
        ),
        TextButton(
          onPressed: () {
            BlocProvider.of<FavoritesBloc>(context).add(RemoveFavoriteEvent(
                songToRemove: favItem,
                uid: BlocProvider.of<AuthBloc>(context).currUser!.uid));
            Navigator.of(context).pop();
          },
          child: const Text("Eliminar"),
        )
      ],
    );
  }

  ClipRRect _createImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Image.network(
          height: 300,
          width: 300,
          alignment: Alignment.center,
          favItem.songImage),
    );
  }
}
