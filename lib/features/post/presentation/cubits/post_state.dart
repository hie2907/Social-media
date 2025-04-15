import 'package:social_media_app/features/post/domain/entities/post.dart';

abstract class PostState {}

class PostInitial extends PostState {}

class PostLoading extends PostState {}

class PostLoaded extends PostState {
  final List<Post> post;
  PostLoaded(this.post);
}

class PostUploading extends PostState {}

class PostError extends PostState {
  final String message;
  PostError({required this.message});
}
