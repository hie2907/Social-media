import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/auth/domain/entities/app_user.dart';
import 'package:social_media_app/features/auth/domain/repos/auth_repository.dart';
import 'package:social_media_app/features/auth/presentation/cubits/auth_states.dart';

class AuthCubit extends Cubit<AuthStates> {
  final AuthRepo authRepo;
  AppUser? _currentUser;
  AuthCubit({required this.authRepo}) : super(AuthInitial());
  //check user already authencated
  void checkAuth() async {
    final AppUser? user = await authRepo.getCurrentUser();
    if (user != null) {
      _currentUser = user;
      emit(Authencated(user));
    } else {
      emit(UnAuthencated());
    }
  }

  // get current user
  AppUser? get currentUser => _currentUser;
// login with email and password
  Future<void> login(String email, String pw) async {
    try {
      emit(AuthLoading());
      final user = await authRepo.loginWithEmailPassword(email, pw);
      if (user != null) {
        _currentUser = user;
        emit(Authencated(user));
      } else {
        emit(UnAuthencated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
      emit(UnAuthencated());
    }
  }

  // register with email and password
  Future<void> register(String name, String email, String pw) async {
    try {
      emit(AuthLoading());
      final user = await authRepo.registerWithEmailPassword(name, email, pw);
      if (user != null) {
        _currentUser = user;
        emit(Authencated(user));
      } else {
        emit(UnAuthencated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
      emit(UnAuthencated());
    }
  }

  // logout
  Future<void> logout() async {
    authRepo.logout();
    emit(UnAuthencated());
  }
}
