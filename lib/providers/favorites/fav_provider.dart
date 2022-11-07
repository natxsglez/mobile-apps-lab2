// ignore_for_file: prefer_final_fields

import 'package:flutter/cupertino.dart';

class FavoritesProvider with ChangeNotifier {
  List<dynamic> _favList = [];

  List<dynamic> get getFavList => _favList;

  void addNewSong(dynamic song) {
    _favList.add(song);
    notifyListeners();
  }

  void removeSong(dynamic song) {
    _favList.remove(song);
    notifyListeners();
  }
}
