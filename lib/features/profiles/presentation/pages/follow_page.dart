import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/profiles/presentation/components/user_title.dart';
import 'package:social_media_app/features/profiles/presentation/cubits/profile_cubit.dart';

class FollowPage extends StatelessWidget {
  final List<String> follower;
  final List<String> following;
  const FollowPage(
      {super.key, required this.follower, required this.following});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              dividerColor: Colors.transparent,
              labelColor: Theme.of(context).colorScheme.inversePrimary,
              unselectedLabelColor: Theme.of(context).colorScheme.primary,
              tabs: const [
                Tab(text: "Follower"),
                Tab(text: "Following"),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              _buildUserList(follower, "No follower", context),
              _buildUserList(following, "No following", context),
            ],
          ),
        ));
  }

  //builder user list
  Widget _buildUserList(
      List<String> uids, String emptyMessage, BuildContext context) {
    return uids.isEmpty
        ? Center(child: Text(emptyMessage))
        : ListView.builder(
            itemCount: uids.length,
            itemBuilder: (context, index) {
              //get each uid
              final uid = uids[index];

              return FutureBuilder(
                future: context.read<ProfileCubit>().getUserProfile(uid),
                builder: (context, snapshot) {
                  //user loaded
                  if (snapshot.hasData) {
                    final user = snapshot.data!;
                    return UserTitle(user: user);
                  }
                  //loading
                  else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const ListTile(
                      title: Text("Loading"),
                    );
                  }
                  //not found
                  else {
                    return const ListTile(
                      title: Text("User not found"),
                    );
                  }
                },
              );
            },
          );
  }
}
