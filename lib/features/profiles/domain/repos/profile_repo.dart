import 'package:social_media_app/features/profiles/domain/entities/profile_user.dart';

abstract class ProfileRepo {
  Future<ProfileUser?> fetchUserProfile(String uid);
  Future<void> updateProfile(ProfileUser updateProfile);

  //follower and following
  Future<void> toggleFollow(String currentUid, String targetUid);
}
