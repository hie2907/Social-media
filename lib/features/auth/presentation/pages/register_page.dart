// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:social_media_app/features/auth/presentation/components/my_button.dart';
import 'package:social_media_app/features/auth/presentation/components/my_text_field.dart';
import 'package:social_media_app/features/auth/presentation/cubits/auth_cubit.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? tooglePages;
  const RegisterPage({
    Key? key,
    required this.tooglePages,
  }) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailControntroller = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();
  final nameController = TextEditingController();

  void register() {
    final String email = emailControntroller.text;
    final String password = passwordController.text;
    final String confirmPassword = passwordConfirmController.text;
    final String name = nameController.text;

    // auth cubit
    final authCubit = context.read<AuthCubit>();

    if (email.isNotEmpty && password.isNotEmpty && name.isNotEmpty) {
      if (password == confirmPassword) {
        authCubit.register(name, email, password);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Password do not match"),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill in all fields"),
        ),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    emailControntroller.dispose();
    passwordController.dispose();
    passwordConfirmController.dispose();
    nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.lock_open,
                  size: 100,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 30),
                Text(
                  "Register Social Media App Van Hieu",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const MySizeBox(),
                MyTextField(
                    hintText: "Name",
                    controller: nameController,
                    obscureText: false),
                const MySizeBox(),
                MyTextField(
                    hintText: "Email",
                    controller: emailControntroller,
                    obscureText: false),
                const MySizeBox(),
                MyTextField(
                    hintText: "Password",
                    controller: passwordController,
                    obscureText: true),
                const MySizeBox(),
                MyTextField(
                    hintText: "Password Confirm",
                    controller: passwordConfirmController,
                    obscureText: true),
                const MySizeBox(),
                MyButton(
                  text: "Register",
                  onTap: register,
                ),
                const MySizeBox(),
                Row(
                  children: [
                    Text(
                      "Already have account?",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    GestureDetector(
                      onTap: widget.tooglePages,
                      child: const Text(
                        " Login now",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
