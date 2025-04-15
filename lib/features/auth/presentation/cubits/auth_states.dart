import 'package:social_media_app/features/auth/domain/entities/app_user.dart';

abstract class AuthStates {}

// initial
class AuthInitial extends AuthStates {}

//loading
class AuthLoading extends AuthStates {}

// authenticated
class Authencated extends AuthStates {
  final AppUser user;

  Authencated(this.user);
}

// unauthenticated
class UnAuthencated extends AuthStates {}

// error
class AuthError extends AuthStates {
  final String errorMessage;

  AuthError(this.errorMessage);
}
