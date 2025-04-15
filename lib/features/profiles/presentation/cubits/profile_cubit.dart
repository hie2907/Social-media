import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/profiles/domain/entities/profile_user.dart';
import 'package:social_media_app/features/profiles/domain/repos/profile_repo.dart';
import 'package:social_media_app/features/profiles/presentation/cubits/profile_state.dart';
import 'package:social_media_app/features/storage/domain/storage_repo.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepo profileRepo;
  final StorageRepo storageRepo;
  ProfileCubit({
    required this.profileRepo,
    required this.storageRepo,
  }) : super(ProfileInitial());

  //fetch profile use repository
  Future<void> fetchUserProfile(String uid) async {
    try {
      emit(ProfileLoading());
      final user = await profileRepo.fetchUserProfile(uid);
      if (user != null) {
        emit(ProfileLoaded(user));
      } else {
        emit(ProfileError("User not found"));
      }
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  //return user profile given uid - > useful for loading many profile for post
  Future<ProfileUser?> getUserProfile(String uid) async {
    final user = await profileRepo.fetchUserProfile(uid);
    return user;
  }

  //update profile
  Future<void> updateProfile({
    required String uid,
    String? newBio,
    String? imageMobilePath,
  }) async {
    emit(ProfileLoading());
    try {
      //fetch current profile first
      final currentUser = await profileRepo.fetchUserProfile(uid);
      if (currentUser == null) {
        emit(ProfileError("User not found"));
        return;
      }
      //profile image upload
      String? imageDownUrl;
      if (imageMobilePath != null) {
        imageDownUrl =
            await storageRepo.upaloadProfileMobile(imageMobilePath, uid);
        if (imageDownUrl == null) {
          emit(ProfileError("Failed to upload image"));
          return;
        }
      }

      final updateProfile = currentUser.copyWith(
        newBio: newBio ?? currentUser.bio,
        newProfilePictureUrl: imageDownUrl ?? currentUser.profilePictureUrl,
      );
      await profileRepo.updateProfile(updateProfile);

      //re-fetch uid
      await fetchUserProfile(uid);
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  //toggle following
  Future<void> toggleFollow(String currentUserId, String targetUserId) async {
    try {
      await profileRepo.toggleFollow(currentUserId, targetUserId);
    } catch (e) {
      emit(ProfileError("error $e"));
    }
  }
}
