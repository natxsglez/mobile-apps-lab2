// ignore_for_file: prefer_final_fields

import 'package:flutter/cupertino.dart';

class FavoritesProvider {
  void addNewSong(dynamic song) {
    _favList.add(song);
  }

  void removeSong(dynamic song) {
    _favList.remove(song);
  }
}
