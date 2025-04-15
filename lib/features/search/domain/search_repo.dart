import 'package:social_media_app/features/profiles/domain/entities/profile_user.dart';

abstract class SearchRepo {
  Future<List<ProfileUser?>> searchUser(String query);
}
