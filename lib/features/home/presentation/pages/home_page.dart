import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:social_media_app/features/post/presentation/components/post_title.dart';
import 'package:social_media_app/features/post/presentation/cubits/post_cubit.dart';
import 'package:social_media_app/features/post/presentation/cubits/post_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //post cubit
  late final postCubit = context.read<PostCubit>();

  @override
  void initState() {
    super.initState();
    fetchAllPost();
  }

  //fetch all post
  void fetchAllPost() {
    postCubit.fetchAllPost();
  }

  //delete post
  void deletePost(String postId) {
    postCubit.delePost(postId);
    fetchAllPost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              context.read<AuthCubit>().logout();
            },
          ),
        ],
      ),
      body: BlocBuilder<PostCubit, PostState>(
        builder: (context, state) {
          //loading state
          if (state is PostLoading && state is PostUploading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          //loaded state
          else if (state is PostLoaded) {
            final allPost = state.post;
            if (allPost.isEmpty) {
              return const Center(
                child: Text('No Post Found'),
              );
            }
            return ListView.builder(
              itemCount: allPost.length,
              itemBuilder: (context, index) {
                final post = allPost[index];
                return PostTitle(
                  post: post,
                  onDeletePressed: () => deletePost(post.id),
                );
              },
            );
          }

          //error
          else if (state is PostError) {
            return Center(
              child: Text(state.message),
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}
