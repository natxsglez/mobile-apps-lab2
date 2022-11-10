// ignore_for_file: prefer_final_fields

import 'dart:async';

import 'package:birds_museum/models/collections.dart';
import 'package:birds_museum/models/song_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FavoritesRepository {
  final usersCollection =
      FirebaseFirestore.instance.collection(FirebaseCollections.users);

  FutureOr<void> addSong(SongModel song, String uid) async {
    final userData = await usersCollection.where('uid', isEqualTo: uid).get();
    final songsRef = userData.docs[0].data()["favoriteSongs"];
    final songPlatforms = [];

    for (int i = 0; i < song.platforms.length; i++) {
      songPlatforms.add({
        "platformName": song.platforms[i].platformName,
        "url": song.platforms[i].url
      });
    }

    songsRef.add({
      "songName": song.songName,
      "album": song.album,
      "artist": song.artist,
      "date": song.date,
      "songImage": song.songImage,
      "platforms": songPlatforms
    });
    await usersCollection.doc(uid).update({"favoriteSongs": songsRef});
  }

  FutureOr<void> removeSong(SongModel song, String uid) async {
    final userData = await usersCollection.where('uid', isEqualTo: uid).get();
    final songsRef = userData.docs[0].data()["favoriteSongs"];

    songsRef.removeWhere((element) => element["songName"] == song.songName);

    await usersCollection.doc(uid).update({"favoriteSongs": songsRef});
  }
}
