import 'package:birds_museum/bloc/auth_bloc/auth_bloc.dart';
import 'package:birds_museum/bloc/favorites_bloc/favorites_bloc.dart';
import 'package:birds_museum/models/song_model.dart';
import 'package:birds_museum/pages/home_page/home_page.dart';
import 'package:birds_museum/pages/search_results/platforms_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchResults extends StatefulWidget {
  final SongModel songData;
  bool isLikedSong;
  SearchResults({super.key, required this.songData, required this.isLikedSong});

  @override
  State<SearchResults> createState() =>
      _SearchResultsState(songData: songData, isLikedSong: isLikedSong);
}

class _SearchResultsState extends State<SearchResults> {
  final SongModel songData;
  bool isLikedSong;

  _SearchResultsState({required this.songData, required this.isLikedSong});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Here you go"),
        leading: IconButton(
          icon: Icon(Icons.navigate_before),
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => HomePage()));
          },
        ),
        actions: [
          IconButton(
              icon: isLikedSong
                  ? const Icon(Icons.favorite)
                  : const Icon(Icons.favorite_border),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      if (isLikedSong) {
                        return _createAlertDialog(
                            context,
                            "Eliminar de favoritos",
                            "El elemento será eliminado de tus favoritos ¿Quieres continuar?",
                            "Eliminar",
                            true);
                      } else {
                        return _createAlertDialog(
                            context,
                            "Agregar a favoritos",
                            "El elemento será agregado a tu lista de favoritos ¿Quieres continuar?",
                            "Agregar",
                            false);
                      }
                    });
              }),
          BlocListener<FavoritesBloc, FavoritesState>(
            listener: (context, state) {
              if (state is AddFavoriteSuccessState ||
                  state is RemoveFavoriteEvent) {
                BlocProvider.of<AuthBloc>(context).add(RefreshUserDataEvent());
              }
            },
            child: Container(),
          )
        ],
      ),
      body: Column(children: [
        Image.network(
            alignment: Alignment.center, fit: BoxFit.cover, songData.songImage),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 40.0, 0, 30),
          child: Column(children: [
            createText(songData.songName,
                const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
            createText(songData.album,
                const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            createText(songData.artist, const TextStyle(fontSize: 15)),
            createText(songData.date, const TextStyle(fontSize: 15)),
          ]),
        ),
        const Divider(
          thickness: 1,
        ),
        PlatformsList(
          platformData: songData.platforms,
        )
      ]),
    );
  }

  AlertDialog _createAlertDialog(BuildContext context, String title,
      String content, String action, bool removeSong) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Cancelar"),
        ),
        TextButton(
          onPressed: () {
            if (removeSong) {
              isLikedSong = false;
              setState(() {});
              BlocProvider.of<FavoritesBloc>(context).add(RemoveFavoriteEvent(
                  songToRemove: songData,
                  uid: BlocProvider.of<AuthBloc>(context).currUser!.uid));
            } else {
              isLikedSong = true;
              setState(() {});
              BlocProvider.of<FavoritesBloc>(context).add(AddFavoriteEvent(
                  songToAdd: songData,
                  uid: BlocProvider.of<AuthBloc>(context).currUser!.uid));
            }
            Navigator.of(context).pop();
          },
          child: Text(action),
        )
      ],
    );
  }

  Text createText(String text, TextStyle style) {
    return Text(
      text,
      style: style,
      maxLines: 2,
      textAlign: TextAlign.center,
    );
  }
}
