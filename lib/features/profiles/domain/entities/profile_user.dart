import 'package:social_media_app/features/auth/domain/entities/app_user.dart';

class ProfileUser extends AppUser {
  final String bio;
  final String profilePictureUrl;
  final List<String> follower;
  final List<String> following;

  ProfileUser({
    required super.uid,
    required super.name,
    required super.email,
    required this.bio,
    required this.profilePictureUrl,
    required this.follower,
    required this.following,
  });

  // method update profile
  ProfileUser copyWith({
    String? newBio,
    String? newProfilePictureUrl,
    List<String>? newFollower,
    List<String>? newFollowing,
  }) {
    return ProfileUser(
      uid: uid,
      name: name,
      email: email,
      bio: newBio ?? bio,
      profilePictureUrl: newProfilePictureUrl ?? profilePictureUrl,
      follower: newFollower ?? follower,
      following: newFollowing ?? following,
    );
  }

  // method to convert to json
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'bio': bio,
      'profilePictureUrl': profilePictureUrl,
      'followers': follower,
      'following': following,
    };
  }

  // convert to json -> profile user
  factory ProfileUser.fromJson(Map<String, dynamic> json) {
    return ProfileUser(
      uid: json['uid'],
      name: json['name'],
      email: json['email'],
      bio: json['bio'] ?? '',
      profilePictureUrl: json['profilePictureUrl'] ?? '',
      follower: List<String>.from(json['followers'] ?? []),
      following: List<String>.from(json['following'] ?? []),
    );
  }
}
