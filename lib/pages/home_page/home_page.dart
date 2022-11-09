import 'package:birds_museum/bloc/recognize_song_bloc/recognize_song_bloc.dart';
import 'package:birds_museum/bloc/record/record_bloc.dart';
import 'package:birds_museum/pages/fav_page/fav_page.dart';
import 'package:birds_museum/pages/search_results/search_results.dart';
import 'package:flutter/material.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _createListeningText(context),
          BlocListener<RecordBloc, RecordState>(
            listener: (context, state) {
              if (state is RecordErrorState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "Error al grabar la canción, intenta de nuevo",
                    ),
                  ),
                );
              } else if (state is RecordingSuccessfulState) {
                BlocProvider.of<RecognizeSongBloc>(context).add(
                    DoRecognizeSongEvent(
                        songPath: BlocProvider.of<RecordBloc>(context)
                            .recordedSongPath!));
              }
            },
            child: Container(),
          ),
          BlocListener<RecognizeSongBloc, RecognizeSongState>(
            listener: (context, state) {
              if (state is RecognizeSongErrorState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "Error al reconocer la canción, intenta de nuevo",
                    ),
                  ),
                );
              } else if (state is RecognizeSongSuccessfulState) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SearchResults(
                          songData:
                              BlocProvider.of<RecognizeSongBloc>(context).song!,
                          isLikedSong: false,
                        )));
              }
            },
            child: Container(),
          ),
          AvatarGlow(
            endRadius: 200,
            animate: BlocProvider.of<RecordBloc>(context).isRecording,
            child: MaterialButton(
                color: Colors.white,
                shape: const CircleBorder(),
                height: 300,
                onPressed: () async {
                  BlocProvider.of<RecordBloc>(context)
                      .add(StartRecordingEvent());
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
      padding: const EdgeInsets.all(8.0),
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
            MaterialPageRoute(builder: (context) => const FavoritesPage()),
          );
        },
        child: const Icon(
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
            !BlocProvider.of<RecordBloc>(context).isRecording
                ? "Toque para escuchar"
                : "Escuchando...",
            style: const TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
}
