import 'package:social_media_app/features/profiles/domain/entities/profile_user.dart';

abstract class SearchState {}

//initial
class SearchInitial extends SearchState {}

//loading
class SearchLoading extends SearchState {}

// Loaded
class SearchLoaded extends SearchState {
  final List<ProfileUser?> users;

  SearchLoaded(this.users);
}

//error
class SearchError extends SearchState {
  final String message;

  SearchError(this.message);
}
