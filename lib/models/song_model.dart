import 'package:birds_museum/models/platform_model.dart';

class SongModel {
  final String songName;
  final String album;
  final String artist;
  final String date;
  final String songImage;
  final String songLink;
  final List<PlatformModel> platforms;

  SongModel(
      {required this.songName,
      required this.album,
      required this.artist,
      required this.date,
      required this.songImage,
      required this.songLink,
      required this.platforms});

  SongModel.fromMap(Map<String, dynamic> item)
      : songName = item['songName'],
        album = item['album'],
        artist = item['artist'],
        date = item['date'],
        songImage = item['songImage'],
        songLink = item['songLink'],
        platforms = item['platforms'];
}
