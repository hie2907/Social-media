import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_media_app/features/post/domain/entities/comment.dart';
import 'package:social_media_app/features/post/domain/entities/post.dart';
import 'package:social_media_app/features/post/domain/repo/post_repo.dart';

class FirebasePostRepo implements PostRepo {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  //store the post in the collection call "posts"
  final CollectionReference postCollection =
      FirebaseFirestore.instance.collection('posts');

  @override
  Future<void> createPost(Post post) async {
    try {
      await postCollection.doc(post.id).set(post.toJson());
    } catch (e) {
      throw Exception('Error creating post: $e');
    }
  }

  @override
  Future<void> deletePost(String postId) async {
    try {
      await postCollection.doc(postId).delete();
    } catch (e) {
      throw Exception('Error creating post: $e');
    }
  }

  @override
  Future<List<Post>> fetchAllPost() async {
    try {
      //get all post by timestamp
      final postSnapshot =
          await postCollection.orderBy('timestamp', descending: true).get();

      //convert firestore json -> list
      final List<Post> allPosts = postSnapshot.docs
          .map((doc) => Post.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      return allPosts;
    } catch (e) {
      throw Exception('Error fetching posts: $e');
    }
  }

  @override
  Future<List<Post>> fetchPostByUserId(String userId) async {
    try {
      // fetch all post by userId
      final postSnapshot =
          await postCollection.where('userId', isEqualTo: userId).get();
      //convert firestore json -> list
      final List<Post> allPost = postSnapshot.docs
          .map((doc) => Post.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      return allPost;
    } catch (e) {
      throw Exception('Error fetching posts: $e');
    }
  }

  @override
  Future<void> toggleLikePost(String postId, String userId) async {
    try {
      //get post document from firestore
      final postDoc = await postCollection.doc(postId).get();

      if (postDoc.exists) {
        final post = Post.fromJson(postDoc.data() as Map<String, dynamic>);
        //check if the userId is already in the likes list
        final hasLiked = post.likes.contains(userId);
        if (hasLiked) {
          post.likes.remove(userId);
        } else {
          post.likes.add(userId);
        }
        //update the post document with the new likes list
        await postCollection.doc(postId).update({
          'likes': post.likes,
        });
      } else {
        throw Exception('Post not found');
      }
    } catch (e) {
      throw Exception('Errror not toggle');
    }
  }

  @override
  Future<void> addComment(String postId, Comment comment) async {
    try {
      // get post document from firestore
      final postDoc = await postCollection.doc(postId).get();
      if (postDoc.exists) {
        final post = Post.fromJson(postDoc.data() as Map<String, dynamic>);
        // add the new comment to the post's comments list
        post.comments.add(comment);

        // update the post document in firestore
        await postCollection.doc(postId).update({
          'comments': post.comments.map((comment) => comment.toJson()).toList()
        });
      } else {
        throw Exception('Post not found');
      }
    } catch (e) {
      throw Exception('Error adding comment: $e');
    }
  }

  @override
  Future<void> deleteComment(String postId, String commentId) async {
    try {
      // get post document from firestore
      final postDoc = await postCollection.doc(postId).get();
      if (postDoc.exists) {
        final post = Post.fromJson(postDoc.data() as Map<String, dynamic>);
        // add the new comment to the post's comments list
        post.comments.removeWhere((comment) => comment.id == commentId);

        // update the post document in firestore
        await postCollection.doc(postId).update({
          'comments': post.comments.map((comment) => comment.toJson()).toList()
        });
      } else {
        throw Exception('Post not found');
      }
    } catch (e) {
      throw Exception('Error deleteting comment: $e');
    }
  }
}
