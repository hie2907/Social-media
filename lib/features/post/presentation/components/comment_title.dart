import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/auth/domain/entities/app_user.dart';
import 'package:social_media_app/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:social_media_app/features/post/domain/entities/comment.dart';
import 'package:social_media_app/features/post/presentation/cubits/post_cubit.dart';

class CommentTitle extends StatefulWidget {
  final Comment comment;
  const CommentTitle({super.key, required this.comment});

  @override
  State<CommentTitle> createState() => _CommentTitleState();
}

class _CommentTitleState extends State<CommentTitle> {
  AppUser? currentUser;
  bool isOwnPost = false;
  @override
  void initState() {
    super.initState();

    getCurrentUser();
  }

  void getCurrentUser() {
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;
    isOwnPost = (widget.comment.userId == currentUser!.uid);
  }

  //show on delete
  void showOption() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Delete '),
              content: const Text('Are you sure you want to delete this post?'),
              actions: [
                TextButton(
                  onPressed: () {
                    context.read<PostCubit>().deleteComment(
                          widget.comment.postId,
                          widget.comment.id,
                        );
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
    return Padding(
      padding: const EdgeInsets.only(left: 25.0),
      child: Row(
        children: [
          Text(
            widget.comment.userName,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Text(widget.comment.text),
          const Spacer(),

          //delete comment button
          if (isOwnPost)
            GestureDetector(
              onTap: showOption,
              child: Icon(
                Icons.more_horiz,
                color: Theme.of(context).colorScheme.primary,
              ),
            )
        ],
      ),
    );
  }
}
