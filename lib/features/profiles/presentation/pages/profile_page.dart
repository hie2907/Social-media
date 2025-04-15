import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/auth/domain/entities/app_user.dart';
import 'package:social_media_app/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:social_media_app/features/post/presentation/components/post_title.dart';
import 'package:social_media_app/features/post/presentation/cubits/post_cubit.dart';
import 'package:social_media_app/features/post/presentation/cubits/post_state.dart';
import 'package:social_media_app/features/profiles/presentation/components/follow_button.dart';
import 'package:social_media_app/features/profiles/presentation/components/profile_widget.dart';
import 'package:social_media_app/features/profiles/presentation/cubits/profile_cubit.dart';
import 'package:social_media_app/features/profiles/presentation/cubits/profile_state.dart';
import 'package:social_media_app/features/profiles/presentation/pages/edit_profile_page.dart';
import 'package:social_media_app/features/profiles/presentation/pages/follow_page.dart';

class ProfilePage extends StatefulWidget {
  final String uid;
  const ProfilePage({super.key, required this.uid});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final profileCubit = context.read<ProfileCubit>();
  late final authCubit = context.read<AuthCubit>();

  // current USer
  late AppUser? currentUser = authCubit.currentUser;

  int postCount = 0;

  //follow
  void followButtonPressed() {
    final profileState = profileCubit.state;
    if (profileState is! ProfileLoaded) {
      return;
    }
    final profileUser = profileState.profileUser;
    final isFollowing = profileUser.follower.contains(currentUser!.uid);

    profileCubit.toggleFollow(currentUser!.uid, widget.uid);

    setState(() {
      //unfollow
      if (isFollowing) {
        profileUser.follower.remove(currentUser!.uid);
      }
      //follow
      else {
        profileUser.follower.add(currentUser!.uid);
      }
    });

    // perform actual toggle a cubit
    profileCubit.toggleFollow(currentUser!.uid, widget.uid).catchError((error) {
      //revert  update
      setState(() {
        // unfollow
        if (isFollowing) {
          profileUser.follower.add(currentUser!.uid);
        }

        //follow
        else {
          profileUser.follower.remove(currentUser!.uid);
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    //load profile
    profileCubit.fetchUserProfile(widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    bool isOwnPost = (widget.uid == currentUser!.uid);
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoaded) {
          //get loaded user
          final user = state.profileUser;
          return Scaffold(
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 10),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 60),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            flex: 3, // 30%
                            child: Container(
                              height: 100,
                              width:
                                  100, // Vẫn giữ kích thước cố định nhưng chỉ chiếm 30% không gian row
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: NetworkImage(user.profilePictureUrl),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 7, // 70%
                            child: RelationWidget(
                              postCount: postCount,
                              followerCount: user.follower.length,
                              followingCount: user.following.length,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FollowPage(
                                    follower: user.follower,
                                    following: user.following,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20, left: 10),
                      child: SizedBox(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.name,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              user.bio,
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    if (!isOwnPost)
                      FollowButton(
                        isFollowing: user.follower.contains(currentUser!.uid),
                        onpressed: followButtonPressed,
                      ),
                    if (isOwnPost)
                      Row(
                        children: [
                          ProfileButton(
                            text: "Edit Profile",
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        EditProfilePage(user: user)),
                              );
                            },
                          ),
                          const ProfileButton(text: "Share Profile"),
                        ],
                      ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 150,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: StoriesData.stories.length,
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            child:
                                BubbleStories(text: StoriesData.stories[index]),
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    // Post
                    BlocBuilder<PostCubit, PostState>(
                      builder: (context, state) {
                        //post loaded
                        if (state is PostLoaded) {
                          final userPost = state.post
                              .where((post) => post.userId == widget.uid)
                              .toList();

                          postCount = userPost.length;
                          return ListView.builder(
                            itemCount: postCount,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final post = userPost[index];
                              return PostTitle(
                                post: post,
                                onDeletePressed: () =>
                                    context.read<PostCubit>().delePost(post.id),
                              );
                            },
                          );
                        }

                        //post loading
                        else if (state is PostLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return const Center(
                            child: Text("no post"),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        } else if (state is ProfileLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return const Center(
            child: Text("no profile"),
          );
        }
      },
    );
  }
}
