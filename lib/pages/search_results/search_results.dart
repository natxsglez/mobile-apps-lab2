// ignore_for_file: prefer_typing_uninitialized_variables, no_logic_in_create_state

import 'package:birds_museum/pages/search_results/platforms_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../bloc/bloc/fav_provider.dart';

class SearchResults extends StatefulWidget {
  final songData;
  final bool isLikedSong;
  const SearchResults({super.key, this.songData, required this.isLikedSong});

  @override
  State<SearchResults> createState() =>
      _SearchResultsState(songData, isLikedSong);
}

class _SearchResultsState extends State<SearchResults> {
  final Map<dynamic, dynamic> _songData;
  bool _isLikedSong;
  _SearchResultsState(this._songData, this._isLikedSong);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Here you go"),
        actions: [
          IconButton(
              icon: _isLikedSong
                  ? const Icon(Icons.favorite)
                  : const Icon(Icons.favorite_border),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      if (_isLikedSong) {
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
        ],
      ),
      body: Column(children: [
        Image.network(
            alignment: Alignment.center,
            fit: BoxFit.cover,
            "${_getSongImageUrl()}"),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 40.0, 0, 30),
          child: Column(children: [
            createText("${_songData["result"]["title"]}",
                const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
            createText("${_songData["result"]["album"]}",
                const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            createText("${_songData["result"]["artist"]}",
                const TextStyle(fontSize: 15)),
            createText("${_songData["result"]["release_date"]}",
                const TextStyle(fontSize: 15)),
          ]),
        ),
        const Divider(
          thickness: 1,
        ),
        PlatformsList(
          songData: _songData["result"],
        )
      ]),
    );
  }

  String _getSongImageUrl() {
    if (_songData["result"].containsKey("spotify")) {
      return _songData["result"]["spotify"]["album"]["images"][0]["url"];
    }

    return "https://media.istockphoto.com/photos/vinyl-record-picture-id134119615?k=20&m=134119615&s=612x612&w=0&h=zI6Fig1j8mbZp16CgvaDRMPHAzTaBNhhcBR0AldRXtw=";
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
              _isLikedSong = false;
              setState(() {});
              context.read<FavoritesProvider>().removeSong(_songData);
            } else {
              _isLikedSong = true;
              setState(() {});
              context.read<FavoritesProvider>().addNewSong(_songData);
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
