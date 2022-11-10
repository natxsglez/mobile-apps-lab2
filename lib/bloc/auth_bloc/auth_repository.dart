import 'dart:developer';

import 'package:birds_museum/models/collections.dart';
import 'package:birds_museum/models/platform_model.dart';
import 'package:birds_museum/models/song_model.dart';
import 'package:birds_museum/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository {
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ["email"]);
  final FirebaseAuth _authInstance = FirebaseAuth.instance;

  bool get isLoggedIn => _authInstance.currentUser != null;

  Future<UserModel?> getMeUser() async {
    User? me = FirebaseAuth.instance.currentUser;
    if (me == null) {
      return null;
    }
    final usersQuery = await FirebaseFirestore.instance
        .collection(FirebaseCollections.users)
        .where('uid', isEqualTo: me.uid)
        .get();
    final songsRef = usersQuery.docs[0].data()["favoriteSongs"];
    final List<SongModel> songs = [];

    for (int i = 0; i < songsRef.length; i++) {
      final List<PlatformModel> platforms = [];
      for (int j = 0; j < songsRef[i]["platforms"].length; j++) {
        platforms.add(PlatformModel(
            platformName: songsRef[i]["platforms"][j]["platformName"],
            url: songsRef[i]["platforms"][j]["url"]));
      }
      songs.add(SongModel(
          songName: songsRef[i]["songName"],
          album: songsRef[i]["album"],
          artist: songsRef[i]["artist"],
          date: songsRef[i]["date"],
          songImage: songsRef[i]["songImage"],
          songLink: songsRef[i]["songLink"],
          platforms: platforms));
    }

    return usersQuery.docs.isNotEmpty
        ? UserModel(
            uid: usersQuery.docs[0].data()["uid"],
            email: usersQuery.docs[0].data()["email"],
            firstName: usersQuery.docs[0].data()["firstName"],
            lastName: usersQuery.docs[0].data()["lastName"],
            displayName: usersQuery.docs[0].data()["displayName"],
            favoriteSongs: songs)
        : null;
  }

  Future<UserModel> signInWithGoogle() async {
    final GoogleSignInAccount? googleSignInAccount =
        await _googleSignIn.signIn();
    if (googleSignInAccount == null) {
      throw 'Could not log in with Google';
    }
    final googleAuth = await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await _authInstance.signInWithCredential(credential);

    if (_authInstance.currentUser?.uid == null) {
      throw 'Invalid uid for Google sign in';
    }
    final UserModel userDetails = await _createFirestoreUser(
      _authInstance.currentUser!.uid,
      googleSignInAccount.email,
      googleSignInAccount.displayName ?? googleSignInAccount.email,
      null,
      null,
      [],
    );
    return userDetails;
  }

  Future<void> signOutGoogleUser() async {
    return _authInstance.signOut();
  }

  Future<UserModel> _createFirestoreUser(
      String uid,
      String email,
      String? displayName,
      String? firstName,
      String? lastName,
      List favoriteSongs) async {
    UserModel? user = await _getFirestoreUser(uid);
    if (user == null) {
      final Map<String, dynamic> userToInsert = {
        'uid': uid,
        'email': email,
        'displayName': displayName,
        'firstName': firstName,
        'lastName': lastName,
        'favoriteSongs': favoriteSongs
      };
      await FirebaseFirestore.instance
          .collection(FirebaseCollections.users)
          .doc(uid)
          .set(userToInsert);
      user = UserModel.fromMap(userToInsert);
    }
    return UserModel(
        uid: uid,
        email: email,
        displayName: displayName,
        firstName: firstName,
        lastName: lastName,
        favoriteSongs: []);
  }

  Future<UserModel?> _getFirestoreUser(String uid) async {
    final meUser = await FirebaseFirestore.instance
        .collection(FirebaseCollections.users)
        .doc(uid)
        .get();
    final Map<String, dynamic>? docData = meUser.data();
    if (docData == null) {
      return null;
    }

    final songsRef = docData["favoriteSongs"];
    final List<SongModel> songs = [];

    for (int i = 0; i < songsRef.length; i++) {
      final List<PlatformModel> platforms = [];
      for (int j = 0; j < songsRef[i]["platforms"].length; j++) {
        platforms.add(PlatformModel(
            platformName: songsRef[i]["platforms"][j]["platformName"],
            url: songsRef[i]["platforms"][j]["url"]));
      }
      songs.add(SongModel(
          songName: songsRef[i]["songName"],
          album: songsRef[i]["album"],
          artist: songsRef[i]["artist"],
          date: songsRef[i]["date"],
          songLink: songsRef[i]["songLink"],
          songImage: songsRef[i]["songImage"],
          platforms: platforms));
    }

    return UserModel(
        uid: docData["uid"],
        email: docData["email"],
        firstName: docData["firstName"],
        lastName: docData["lastName"],
        displayName: docData["displayName"],
        favoriteSongs: songs);
  }
}
