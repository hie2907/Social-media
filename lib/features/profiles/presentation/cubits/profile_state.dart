import 'package:social_media_app/features/profiles/domain/entities/profile_user.dart';

abstract class ProfileState {}

//Initial
class ProfileInitial extends ProfileState {}

//loading
class ProfileLoading extends ProfileState {}

//loaded
class ProfileLoaded extends ProfileState {
  final ProfileUser profileUser;
  ProfileLoaded(this.profileUser);
}

// error
class ProfileError extends ProfileState {
  final String errorMessage;
  ProfileError(this.errorMessage);
}
