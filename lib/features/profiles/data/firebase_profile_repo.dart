import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_media_app/features/profiles/domain/entities/profile_user.dart';
import 'package:social_media_app/features/profiles/domain/repos/profile_repo.dart';

class FirebaseProfileRepo implements ProfileRepo {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  @override
  Future<ProfileUser?> fetchUserProfile(String uid) async {
    try {
      final useDoc = await firestore.collection('users').doc(uid).get();
      if (useDoc.exists) {
        final userData = useDoc.data();
        if (userData != null) {
          //fetch Use follower and floww
          final follower = List<String>.from(userData['followers'] ?? []);
          final following = List<String>.from(userData['following'] ?? []);

          return ProfileUser(
            uid: userData['uid'],
            name: userData['name'],
            email: userData['email'],
            bio: userData['bio'] ?? '',
            profilePictureUrl: userData['profilePictureUrl'] ?? '',
            follower: follower,
            following: following,
          );
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> updateProfile(ProfileUser updateProfile) async {
    try {
      await firestore.collection('users').doc(updateProfile.uid).update({
        'bio': updateProfile.bio,
        'profilePictureUrl': updateProfile.profilePictureUrl,
      });
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  @override
  Future<void> toggleFollow(String currentUid, String targetUid) async {
    try {
      final currentUserDoc =
          await firestore.collection('users').doc(currentUid).get();
      final targetUserDoc =
          await firestore.collection('users').doc(targetUid).get();

      if (currentUserDoc.exists && targetUserDoc.exists) {
        final currentUserData = currentUserDoc.data();
        final targetUserData = targetUserDoc.data();
        if (currentUserData != null && targetUserData != null) {
          final List<String> currentFlowing =
              List<String>.from(currentUserData['following'] ?? []);

          //check if the current user is already following target
          if (currentFlowing.contains(targetUid)) {
            //unfollow
            await firestore.collection('users').doc(currentUid).update({
              'following': FieldValue.arrayRemove([targetUid])
            });
            await firestore.collection('users').doc(targetUid).update({
              'followers': FieldValue.arrayRemove([currentUid])
            });
          } else {
            //follow
            await firestore.collection('users').doc(currentUid).update({
              'following': FieldValue.arrayUnion([targetUid])
            });
            await firestore.collection('users').doc(targetUid).update({
              'followers': FieldValue.arrayUnion([currentUid])
            });
          }
        }
      }
    } catch (e) {}
  }
}
