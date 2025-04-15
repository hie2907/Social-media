import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/post/domain/entities/comment.dart';
import 'package:social_media_app/features/post/domain/entities/post.dart';
import 'package:social_media_app/features/post/domain/repo/post_repo.dart';
import 'package:social_media_app/features/post/presentation/cubits/post_state.dart';
import 'package:social_media_app/features/storage/domain/storage_repo.dart';

class PostCubit extends Cubit<PostState> {
  final PostRepo postRepo;
  final StorageRepo storageRepo;
  PostCubit({
    required this.postRepo,
    required this.storageRepo,
  }) : super(PostInitial());

  // create new post
  Future<void> createPost(Post post, {String? imagePath}) async {
    try {
      String? imageUrl;
      if (imagePath != null) {
        emit(PostUploading());
        imageUrl = await storageRepo.upaloadPostMobile(imagePath, post.id);
      }

      // fetch image url
      final newPost = post.copyWith(
        imageUrl: imageUrl,
      );

      postRepo.createPost(newPost);

      fetchAllPost();
    } catch (e) {
      emit(PostError(message: e.toString()));
    }
  }

  //fetch all posts
  Future<void> fetchAllPost() async {
    try {
      emit(PostLoading());
      final post = await postRepo.fetchAllPost();
      emit(PostLoaded(post));
    } catch (e) {
      emit(PostError(message: e.toString()));
    }
  }

  //delete post
  Future<void> delePost(String postId) async {
    try {
      await postRepo.deletePost(postId);
    } catch (e) {
      ;
    }
  }

  //toggle like post
  Future<void> toggleLikePost(String postId, String userId) async {
    try {
      await postRepo.toggleLikePost(postId, userId);
    } catch (e) {
      emit(PostError(message: e.toString()));
    }
  }

  // add comment
  Future<void> addComment(String postId, Comment comment) async {
    try {
      await postRepo.addComment(postId, comment);
      await fetchAllPost();
    } catch (e) {
      emit(PostError(message: e.toString()));
    }
  }

  //delete comment
  Future<void> deleteComment(String postId, String commentId) async {
    try {
      await postRepo.deleteComment(postId, commentId);
      await fetchAllPost();
    } catch (e) {
      emit(PostError(message: e.toString()));
    }
  }
}
