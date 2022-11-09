// ignore_for_file: prefer_const_constructors, use_build_context_synchronously
import 'package:birds_museum/pages/fav_page/fav_page.dart';
import 'package:birds_museum/pages/search_results/search_results.dart';
import 'package:flutter/material.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _createListeningText(context),
          AvatarGlow(
            endRadius: 200,
            animate: context.watch<RecorderProvider>().getIsRecording,
            child: MaterialButton(
                color: Colors.white,
                shape: const CircleBorder(),
                height: 300,
                onPressed: () async {
                  String recording =
                      await context.read<RecorderProvider>().recordSong();
                  if (recording == "Falla en grabación") {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: const Text(
                          'Lo sentimos, ocurrió un error en la grabación'),
                    ));
                    return;
                  }
                  dynamic result = await context
                      .read<RecognizeSongProvider>()
                      .recognizeSong(recording);
                  if (result["result"] == null) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: const Text(
                          'Lo sentimos, no pudimos encontrar la canción'),
                    ));
                    return;
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SearchResults(
                              songData: result!,
                              isLikedSong: false,
                            )),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Image.asset(
                    'images/music.png',
                    height: 100,
                    width: 100,
                  ),
                )),
          ),
          _createLikeBtn(context)
        ],
      ),
    );
  }

  Tooltip _createLikeBtn(BuildContext context) {
    return Tooltip(
      padding: EdgeInsets.all(8.0),
      showDuration: const Duration(seconds: 2),
      message: "Ver favoritos",
      waitDuration: const Duration(seconds: 1),
      child: MaterialButton(
        shape: const CircleBorder(),
        color: Colors.white,
        height: 50,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FavoritesPage()),
          );
        },
        child: Icon(
          Icons.favorite,
          color: Colors.black,
          size: 35,
        ),
      ),
    );
  }

  Padding _createListeningText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 80.0, 0, 80.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            !context.watch<RecorderProvider>().getIsRecording
                ? "Toque para escuchar"
                : "Escuchando...",
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
}
