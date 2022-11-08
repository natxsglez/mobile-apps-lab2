class UserModel {
  final String uid;
  final String email;
  final String? firstName;
  final String? lastName;
  final String? displayName;

  UserModel(
      {required this.uid,
      required this.email,
      required this.firstName,
      required this.lastName,
      required this.displayName});

  UserModel.fromMap(Map<String, dynamic> item)
      : displayName = item['displayName'],
        email = item['email'],
        firstName = item['firstName'],
        lastName = item['lastName'],
        uid = item['uid'];

  String? get fullName {
    if (firstName != null &&
        firstName != "" &&
        lastName != null &&
        lastName != "") {
      return firstName! + lastName!;
    }
    return null;
  }
}
