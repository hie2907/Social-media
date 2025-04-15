import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/auth/domain/entities/app_user.dart';
import 'package:social_media_app/features/auth/presentation/components/my_text_field.dart';
import 'package:social_media_app/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:social_media_app/features/home/presentation/pages/home.dart';

import 'package:social_media_app/features/post/domain/entities/post.dart';
import 'package:social_media_app/features/post/presentation/cubits/post_cubit.dart';
import 'package:social_media_app/features/post/presentation/cubits/post_state.dart';

class UploadPostPage extends StatefulWidget {
  const UploadPostPage({super.key});

  @override
  State<UploadPostPage> createState() => _UploadPostPageState();
}

class _UploadPostPageState extends State<UploadPostPage> {
  //mobile pick
  PlatformFile? imagePickerFile;
  // current user
  AppUser? currentUser;
  final textController = TextEditingController();

  //pick image
  Future<void> pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
      withData: kIsWeb,
    );
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        imagePickerFile = result.files.first;
      });
    }
  }

  void updatePost() {
    if (imagePickerFile == null || textController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an image and enter a caption.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    //create a new post object
    final newPost = Post(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      userId: currentUser!.uid,
      userName: currentUser!.name,
      text: textController.text,
      imageUrl: '',
      timestamp: DateTime.now(),
      likes: [],
      comments: [],
    );

    //upload the post to the server or database
    final postCubit = context.read<PostCubit>();
    postCubit.createPost(newPost, imagePath: imagePickerFile?.path);
  }

  //disponse
  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  //get current user
  void getCurrentUser() async {
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostCubit, PostState>(builder: (context, state) {
      if (state is PostLoading) {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }
      return buildUploadPage();
    }, listener: (context, state) {
      if (state is PostLoaded) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Home()),
            (_) => false);
      }
    });
  }

  Widget buildUploadPage() {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Upload Post',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          actions: [
            IconButton(
              onPressed: updatePost,
              icon: const Icon(Icons.upload),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                if (!kIsWeb && imagePickerFile != null)
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: FileImage(File(imagePickerFile!.path!)),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                //Material button to pick image
                MaterialButton(
                  onPressed: pickImage,
                  color: Colors.blue,
                  textColor: Colors.white,
                  child: const Text('Pick Image'),
                ),
                MyTextField(
                  hintText: "Caption",
                  controller: textController,
                  obscureText: false,
                ),
              ],
            ),
          ),
        ));
  }
}
