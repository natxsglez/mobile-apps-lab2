// ignore_for_file: prefer_final_fields

import 'dart:async';

import 'package:birds_museum/models/collections.dart';
import 'package:birds_museum/models/song_model.dart';
import 'package:birds_museum/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FavoritesRepository {
  final usersCollection =
      FirebaseFirestore.instance.collection(FirebaseCollections.users);

  FutureOr<void> addSong(SongModel song, String uid) async {
    final userData = await usersCollection.where('uid', isEqualTo: uid).get();
    final user =
        userData.docs.map((doc) => UserModel.fromMap(doc.data())).toList()[0];
    user.favoriteSongs.add(song);
    await usersCollection
        .doc(uid)
        .update({"favoriteSongs": user.favoriteSongs});
  }

  FutureOr<void> removeSong(SongModel song, String uid) async {
    final userData = await usersCollection.where('uid', isEqualTo: uid).get();
    final user =
        userData.docs.map((doc) => UserModel.fromMap(doc.data())).toList()[0];
    user.favoriteSongs.remove(song);
    await usersCollection
        .doc(uid)
        .update({"favoriteSongs": user.favoriteSongs});
  }
}
