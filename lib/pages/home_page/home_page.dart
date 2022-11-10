import 'package:birds_museum/bloc/auth_bloc/auth_bloc.dart';
import 'package:birds_museum/bloc/recognize_song_bloc/recognize_song_bloc.dart';
import 'package:birds_museum/bloc/record/record_bloc.dart';
import 'package:birds_museum/pages/fav_page/fav_page.dart';
import 'package:birds_museum/pages/login_page/login_page.dart';
import 'package:birds_museum/pages/search_results/search_results.dart';
import 'package:flutter/material.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isRecording = false;

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
                isRecording = false;
                setState(() {});
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
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthLoggedOutState) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const LoginPage()));
              }
            },
            child: Container(),
          ),
          AvatarGlow(
            endRadius: 200,
            animate: isRecording,
            child: MaterialButton(
                color: Colors.white,
                shape: const CircleBorder(),
                height: 300,
                onPressed: () async {
                  isRecording = true;
                  setState(() {});
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _createLogoutBtn(context),
              _createLikeBtn(context),
            ],
          )
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
            MaterialPageRoute(builder: (context) => FavoritesPage()),
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

  Tooltip _createLogoutBtn(BuildContext context) {
    return Tooltip(
      padding: const EdgeInsets.all(8.0),
      showDuration: const Duration(seconds: 2),
      message: "Cerrar sesión",
      waitDuration: const Duration(seconds: 1),
      child: MaterialButton(
        shape: const CircleBorder(),
        color: Colors.white,
        height: 50,
        onPressed: () {
          BlocProvider.of<AuthBloc>(context).add(AuthGoogleLogoutEvent());
        },
        child: const Icon(
          Icons.bolt_rounded,
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
            !isRecording ? "Toque para escuchar" : "Escuchando...",
            style: const TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
}
