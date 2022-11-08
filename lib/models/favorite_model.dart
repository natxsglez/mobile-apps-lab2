import 'package:birds_museum/models/song_model.dart';

class FavoriteModel {
  final String songName;
  final String album;
  final String artist;
  final String date;
  final List<SongModel> favoriteSongs;

  FavoriteModel(
      {required this.songName,
      required this.album,
      required this.artist,
      required this.date,
      required this.favoriteSongs});

  FavoriteModel.fromMap(Map<String, dynamic> item)
      : songName = item['songName'],
        album = item['album'],
        artist = item['artist'],
        date = item['date'],
        favoriteSongs = item['favoriteSongs'];
}
