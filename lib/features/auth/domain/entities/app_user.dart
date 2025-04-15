class AppUser {
  String uid;
  String name;
  String email;
  AppUser({
    required this.uid,
    required this.name,
    required this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
    };
  }

  factory AppUser.fromJson(Map<String, dynamic> jsonUSer) {
    return AppUser(
      uid: jsonUSer['uid'],
      name: jsonUSer['name'],
      email: jsonUSer['email'],
    );
  }
}
