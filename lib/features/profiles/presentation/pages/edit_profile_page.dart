import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/profiles/domain/entities/profile_user.dart';
import 'package:social_media_app/features/profiles/presentation/components/profile_widget.dart';
import 'package:social_media_app/features/profiles/presentation/cubits/profile_cubit.dart';
import 'package:social_media_app/features/profiles/presentation/cubits/profile_state.dart';

class EditProfilePage extends StatefulWidget {
  final ProfileUser user;
  const EditProfilePage({super.key, required this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  //mobile pick
  PlatformFile? imagePickerFile;

  final bioController = TextEditingController();
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

  //update controller
  void updateProfile() async {
    final profileCubit = context.read<ProfileCubit>();
    //prepare image
    final String uid = widget.user.uid;
    final imageMobilePath = kIsWeb ? null : imagePickerFile?.path;
    final String? newBio =
        bioController.text.isNotEmpty ? bioController.text : null;

    //update profile if there is something to update
    if (imagePickerFile != null || newBio != null) {
      profileCubit.updateProfile(
        uid: uid,
        newBio: bioController.text,
        imageMobilePath: imageMobilePath,
      );
    }
    //nothing to update
    else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(builder: (context, state) {
      //profile loading

      if (state is ProfileLoading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else {
        return buildEditPage();
      }
    }, listener: (context, state) {
      if (state is ProfileLoaded) {
        Navigator.pop(context);
      }
    });
  }

  Widget buildEditPage() {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile picture section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    // Profile picture
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.grey[800],
                      backgroundImage: (!kIsWeb && imagePickerFile != null)
                          ? FileImage(File(imagePickerFile!.path!))
                          : NetworkImage(widget.user.profilePictureUrl),
                    ),
                    const SizedBox(width: 12),
                    // Username and display name
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'nav_hie',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'Trần Văn Hiếu',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    // Change photo button
                    ElevatedButton(
                      onPressed: pickImage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const StyleText(text: 'Change photo'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Bio section
              const Text(
                'Bio',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: bioController,
                maxLines: 3,
                maxLength: 150,
                decoration: InputDecoration(
                  hintText: widget.user.bio,
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.secondary,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 16,
                  ),
                ),
              ),

              // Submit button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: updateProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const StyleText(text: 'Update Profile'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
