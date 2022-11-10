import 'package:birds_museum/bloc/auth_bloc/auth_bloc.dart';
import 'package:birds_museum/bloc/favorites_bloc/favorites_bloc.dart';
import 'package:birds_museum/models/song_model.dart';
import 'package:birds_museum/pages/search_results/search_results.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

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
        child: BlocListener<FavoritesBloc, FavoritesState>(
          listener: (context, state) {
            if (state is AddFavoriteSuccessState ||
                state is RemoveFavoriteEvent) {
              BlocProvider.of<AuthBloc>(context).add(RefreshUserDataEvent());
            }
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
        ));
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

  void _launchUrl(String url) async {
    Uri parsedUrl = Uri.parse(url);
    if (!await canLaunchUrl(parsedUrl)) {
      throw 'Could not launch $url';
    } else {
      launchUrl(
        parsedUrl,
        mode: LaunchMode.externalApplication,
      );
    }
  }

  Padding _createFavoriteBtn(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: IconButton(
          icon: const Icon(Icons.favorite),
          onPressed: () => _launchUrl(favItem.songLink),
        ));
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
