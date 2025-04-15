import 'package:flutter/material.dart';
import 'package:social_media_app/features/auth/presentation/pages/login_page.dart';
import 'package:social_media_app/features/auth/presentation/pages/register_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPage();
}

class _AuthPage extends State<AuthPage> {
  bool showlogginPage = true;
  void togglePages() {
    setState(() {
      showlogginPage = !showlogginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showlogginPage) {
      return LoginPage(
        tooglePages: togglePages,
      );
    } else {
      return RegisterPage(
        tooglePages: togglePages,
      );
    }
  }
}
