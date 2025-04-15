import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/profiles/presentation/components/user_title.dart';
import 'package:social_media_app/features/search/presentation/cubit/search_cubit.dart';
import 'package:social_media_app/features/search/presentation/cubit/search_state.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController searchController = TextEditingController();
  late final searchCubit = context.read<SearchCubit>();

  void onSearchChange() {
    final query = searchController.text;
    searchCubit.searchUser(query);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    searchController.addListener(onSearchChange);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchController,
          decoration: InputDecoration(
              hintText: "Search users",
              hintStyle: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              )),
        ),
      ),
      body: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          //loaded
          if (state is SearchLoaded) {
            //no user
            if (state.users.isEmpty) {
              return const Center(
                child: Text("no user found"),
              );
            }
            //user
            return ListView.builder(
                itemCount: state.users.length,
                itemBuilder: (context, index) {
                  final user = state.users[index];
                  return UserTitle(user: user!);
                });
          }
          //loading
          else if (state is SearchLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          //error
          else if (state is SearchError) {
            return Center(
              child: Text(state.message),
            );
          }
          //default
          return const Center(
            child: Text("start user search"),
          );
        },
      ),
    );
  }
}
