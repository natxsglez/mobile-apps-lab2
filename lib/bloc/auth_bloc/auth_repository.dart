import 'dart:developer';

import 'package:birds_museum/models/collections.dart';
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
    usersQuery.docs[0].data()["favoriteSongs"] =
        log("${usersQuery.docs[0].data()}");

    return usersQuery.docs.isNotEmpty
        ? UserModel.fromMap(usersQuery.docs[0].data())
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

  Future<GoogleSignInAccount?> signOutGoogleUser() async {
    return _googleSignIn.signOut();
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
    return UserModel.fromMap(docData);
  }
}
