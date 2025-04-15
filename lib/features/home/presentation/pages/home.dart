import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:social_media_app/features/auth/presentation/pages/auth_page.dart';
import 'package:social_media_app/features/home/presentation/pages/home_page.dart';
import 'package:social_media_app/features/post/presentation/pages/upload_post_page.dart';
import 'package:social_media_app/features/profiles/presentation/pages/profile_page.dart';
import 'package:social_media_app/features/search/presentation/pages/search_page.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  late final String uid;
  //change page
  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthCubit>().currentUser;
    if (user == null) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const AuthPage()));
    }
    uid = user!.uid;
  }

  //list page
  late final List<Widget> _pages = [
    const HomePage(),
    const SearchPage(),
    const UploadPostPage(),
    ProfilePage(
      uid: uid,
    ),
    ProfilePage(
      uid: uid,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        onTap: _navigateBottomBar,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_to_queue_sharp), label: 'Post'),
          BottomNavigationBarItem(icon: Icon(Icons.video_call), label: 'Reels'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Accont'),
        ],
      ),
    );
  }
}
