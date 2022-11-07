import 'package:birds_museum/pages/search_results/search_results.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/favorites/fav_provider.dart';

class FavoriteItem extends StatelessWidget {
  final favItem;
  const FavoriteItem({super.key, this.favItem});

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
                "${favItem["result"]["title"]}",
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text("${favItem["result"]["artist"]}")
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
            context.read<FavoritesProvider>().removeSong(favItem);
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
          "${favItem["result"]["spotify"]["album"]["images"][1]["url"]}"),
    );
  }
}
