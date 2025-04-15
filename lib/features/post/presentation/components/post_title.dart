import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/auth/domain/entities/app_user.dart';
import 'package:social_media_app/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:social_media_app/features/post/domain/entities/comment.dart';
import 'package:social_media_app/features/post/domain/entities/post.dart';
import 'package:social_media_app/features/post/presentation/components/comment_title.dart';
import 'package:social_media_app/features/post/presentation/cubits/post_cubit.dart';
import 'package:social_media_app/features/post/presentation/cubits/post_state.dart';
import 'package:social_media_app/features/profiles/domain/entities/profile_user.dart';
import 'package:social_media_app/features/profiles/presentation/cubits/profile_cubit.dart';
import 'package:social_media_app/features/profiles/presentation/pages/profile_page.dart';

class PostTitle extends StatefulWidget {
  final Post post;
  final void Function()? onDeletePressed;
  const PostTitle(
      {super.key, required this.post, required this.onDeletePressed});

  @override
  State<PostTitle> createState() => _PostTitleState();
}

class _PostTitleState extends State<PostTitle> {
  //cubit
  late final postCubit = context.read<PostCubit>();
  late final profileCubit = context.read<ProfileCubit>();

  bool isOwnPost = false; //check if the post is own post

  //current user
  AppUser? currentUser;
  //post user
  ProfileUser? postUser;

  @override
  void initState() {
    super.initState();

    getCurrentUser();
    fetchPostUser();
  }

  void getCurrentUser() {
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;
    isOwnPost = widget.post.userId == currentUser!.uid;
  }

  Future<void> fetchPostUser() async {
    final fetchUser = await profileCubit.getUserProfile(widget.post.userId);
    if (fetchUser != null) {
      setState(() {
        postUser = fetchUser;
      });
    }
  }

  //user tapped button
  void toggleLikePost() {
    final isLiked = widget.post.likes.contains(currentUser!.uid);

    //optimiscally the like button
    setState(() {
      if (isLiked) {
        widget.post.likes.remove(currentUser!.uid); // unlike post
      } else {
        widget.post.likes.add(currentUser!.uid); // like post
      }
    });
    //update like
    postCubit
        .toggleLikePost(widget.post.id, currentUser!.uid)
        .catchError((error) {
      //if there an error, revert back to original value
      setState(() {
        if (isLiked) {
          widget.post.likes.add(currentUser!.uid); //revert unlike
        } else {
          widget.post.likes.remove(currentUser!.uid); //revert like
        }
      });
    });
  }

  /*COMMENT */
  final commentTextController = TextEditingController();
  //show dialog to add comment
  void openNewCommentBox() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: commentTextController,
          decoration: const InputDecoration(
            hintText: 'Add a comment...',
          ),
          obscureText: false,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              addComment();
              Navigator.pop(context);
            },
            child: const Text('Post'),
          ),
        ],
      ),
    );
  }

  void addComment() {
    final newComment = Comment(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      postId: widget.post.id,
      userId: currentUser!.uid,
      userName: currentUser!.name,
      text: commentTextController.text,
      timestamp: DateTime.now(),
    );
    //add commnent using cubit
    if (commentTextController.text.isNotEmpty) {
      postCubit.addComment(widget.post.id, newComment);
    }
  }

  //show on delete
  void showOption() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Delete Post'),
              content: const Text('Are you sure you want to delete this post?'),
              actions: [
                TextButton(
                  onPressed: () {
                    widget.onDeletePressed!();
                    Navigator.pop(context);
                  },
                  child: const Text('Yes'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('No'),
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.secondary,
      child: Column(
        children: [
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfilePage(uid: widget.post.userId),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  //profile image
                  postUser?.profilePictureUrl != null
                      ? CachedNetworkImage(
                          imageUrl: postUser!.profilePictureUrl,
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.person),
                          imageBuilder: (context, imageProvider) => Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        )
                      : const Icon(Icons.person),
                  const SizedBox(
                    width: 10,
                  ),
                  //name
                  Text(
                    widget.post.userName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),

                  const Spacer(),
                  //button delete
                  if (isOwnPost)
                    GestureDetector(
                      onTap: showOption,
                      child: Icon(
                        Icons.delete,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                ],
              ),
            ),
          ),
          CachedNetworkImage(
            imageUrl: widget.post.imageUrl,
            height: 230,
            width: double.infinity,
            fit: BoxFit.cover,
            placeholder: (context, url) => const SizedBox(
              height: 430,
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                //button like
                GestureDetector(
                  onTap: toggleLikePost,
                  child: Icon(
                    widget.post.likes.contains(currentUser!.uid)
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: widget.post.likes.contains(currentUser!.uid)
                        ? Colors.red
                        : Theme.of(context).colorScheme.primary,
                  ),
                ),
                Text(widget.post.likes.length.toString()),
                //button comment
                const SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: openNewCommentBox,
                  child: Icon(
                    Icons.comment,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                Text(widget.post.comments.length.toString()),
                const Spacer(),
                Text(widget.post.timestamp.toString()),
              ],
            ),
          ),
          //View caption
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: Row(
              children: [
                Text(
                  widget.post.userName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(widget.post.text),
              ],
            ),
          ),
          //  View comments
          BlocBuilder<PostCubit, PostState>(builder: (context, state) {
            //loaded
            if (state is PostLoaded) {
              //  final individual post
              final post =
                  state.post.firstWhere((post) => post.id == widget.post.id);

              if (post.comments.isNotEmpty) {
                //how many comments to show
                int showCommentCount = post.comments.length;

                //comment section
                return ListView.builder(
                  itemCount: showCommentCount,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    //get individual comment
                    final comment = post.comments[index];
                    //comment title UI
                    return CommentTitle(
                      comment: comment,
                    );
                  },
                );
              }
            }
            //loading
            if (state is PostLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            //error
            else if (state is PostError) {
              return Center(
                child: Text(
                  state.message,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            } else {
              return const SizedBox();
            }
          }),
          const SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }
}
