import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:birds_museum/models/song_model.dart';
import 'package:birds_museum/models/platform_model.dart';
import 'package:http/http.dart' as http;
import '../../credentials.dart' as credentials;

class RecognizeSongRepository {
  Future<SongModel> recognizeSong(String songPath) async {
    File songFile = File(songPath);
    String songFileConvertedToBase64 = _convertFiletoBase64String(songFile);
    Map<String, dynamic> recognizedSong =
        await _doRecognition(songFileConvertedToBase64);
    if (recognizedSong["result"] == null) {
      throw ("Song could not be recognized");
    }
    SongModel song = SongModel(
        songName: recognizedSong["result"]["title"],
        album: recognizedSong["result"]["album"],
        artist: recognizedSong["result"]["artist"],
        date: recognizedSong["result"]["release_date"],
        songLink: recognizedSong["result"]["song_link"],
        songImage: recognizedSong["result"]["spotify"]["album"]["images"][0]
                ["url"] ??
            "https://media.istockphoto.com/photos/vinyl-record-picture-id134119615?k=20&m=134119615&s=612x612&w=0&h=zI6Fig1j8mbZp16CgvaDRMPHAzTaBNhhcBR0AldRXtw=",
        platforms: _createListOfPlatforms(recognizedSong["result"]));
    return song;
  }

  List<PlatformModel> _createListOfPlatforms(
      Map<String, dynamic> recognizedSong) {
    List<PlatformModel> result = [];
    if (recognizedSong.containsKey("spotify")) {
      result.add(PlatformModel(
          platformName: "spotify",
          url: recognizedSong["spotify"]["external_urls"]["spotify"]));
    }

    if (recognizedSong.containsKey("apple_music")) {
      result.add(PlatformModel(
          platformName: "apple_music",
          url: recognizedSong["apple_music"]["url"]));
    }

    if (recognizedSong.containsKey("deezer")) {
      result.add(PlatformModel(
          platformName: "deezer", url: recognizedSong["deezer"]["link"]));
    }
    return result;
  }

  String _convertFiletoBase64String(File file) {
    Uint8List fileInBytes = file.readAsBytesSync();
    String base64String = base64Encode(fileInBytes);
    return base64String;
  }

  Future<String> _getApiToken() async {
    String apiToken = credentials.API_KEY;
    return apiToken;
  }

  Future<dynamic> _doRecognition(String songAsString) async {
    Uri url = Uri.parse('https://api.audd.io/');
    var response = await http.post(url, body: {
      'api_token': await _getApiToken(),
      'return': 'apple_music,spotify,deezer',
      'audio': songAsString,
      'method': 'recognize',
    });

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw "Falló al obtener el resultado";
    }
  }
}
