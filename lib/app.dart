import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/auth/data/firebase_auth_repo.dart';
import 'package:social_media_app/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:social_media_app/features/auth/presentation/cubits/auth_states.dart';
import 'package:social_media_app/features/auth/presentation/pages/auth_page.dart';
import 'package:social_media_app/features/home/presentation/pages/home.dart';
import 'package:social_media_app/features/post/data/firebase_post_repo.dart';
import 'package:social_media_app/features/post/presentation/cubits/post_cubit.dart';
import 'package:social_media_app/features/profiles/data/firebase_profile_repo.dart';
import 'package:social_media_app/features/profiles/presentation/cubits/profile_cubit.dart';
import 'package:social_media_app/features/search/data/firebase_search_repo.dart';
import 'package:social_media_app/features/search/presentation/cubit/search_cubit.dart';
import 'package:social_media_app/features/storage/data/cloudinary_storage_repo.dart';
import 'package:social_media_app/themes/light_mode.dart';

class MyApp extends StatelessWidget {
  final firebasAuthRepo = FirebaseAuthRepo();
  final firebasProfileRepo = FirebaseProfileRepo();
  final firebasPostRepo = FirebasePostRepo();
  final firebaseSearchRepo = FirebaseSearchRepo();
  final cloudinaryStorageRepo = CloudinaryStorageRepo();
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        //auth cubit
        BlocProvider<AuthCubit>(
            create: (context) =>
                AuthCubit(authRepo: firebasAuthRepo)..checkAuth()),
        //profile cubit
        BlocProvider(
            create: (context) => ProfileCubit(
                  profileRepo: firebasProfileRepo,
                  storageRepo: cloudinaryStorageRepo,
                )),
        //post cubit
        BlocProvider(
            create: (context) => PostCubit(
                  postRepo: firebasPostRepo,
                  storageRepo: cloudinaryStorageRepo,
                )),
        //search cubit
        BlocProvider(
            create: (context) => SearchCubit(searchRepo: firebaseSearchRepo)),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightMode,
        home: BlocConsumer<AuthCubit, AuthStates>(
          builder: (context, authState) {
            print(authState);
            if (authState is UnAuthencated) {
              return const AuthPage();
            }
            if (authState is Authencated) {
              return Home();
            } else {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
          listener: (context, state) {
            if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
