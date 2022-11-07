import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../../credentials.dart' as credentials;

class RecognizeSongProvider with ChangeNotifier {
  Future<dynamic> recognizeSong(String songPath) async {
    File songFile = File(songPath);
    String songFileConvertedToBase64 = _convertFiletoBase64String(songFile);
    dynamic recognizedSong = await _doRecognition(songFileConvertedToBase64);
    return recognizedSong;
  }

  String _convertFiletoBase64String(File file) {
    Uint8List fileInBytes = file.readAsBytesSync();
    String base64String = base64Encode(fileInBytes);
    return base64String;
  }

  Future<String> _getApiToken() async {
    String apiToken = credentials.API_KEY;
    print(apiToken);
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
      return "Falló al obtener el resultado";
    }
  }
}
