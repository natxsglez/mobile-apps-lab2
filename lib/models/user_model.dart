import 'package:birds_museum/models/song_model.dart';

class UserModel {
  final String uid;
  final String email;
  final String? firstName;
  final String? lastName;
  final String? displayName;
  final List<SongModel> favoriteSongs;

  UserModel(
      {required this.uid,
      required this.email,
      required this.firstName,
      required this.lastName,
      required this.displayName,
      required this.favoriteSongs});

  UserModel.fromMap(Map<String, dynamic> item)
      : displayName = item['displayName'],
        email = item['email'],
        firstName = item['firstName'],
        lastName = item['lastName'],
        uid = item['uid'],
        favoriteSongs = item['favoriteSongs'];
}
