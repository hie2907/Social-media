import 'package:flutter/material.dart';

class FollowButton extends StatelessWidget {
  final void Function()? onpressed;
  final bool isFollowing;
  const FollowButton(
      {super.key, required this.onpressed, required this.isFollowing});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: MaterialButton(
          onPressed: onpressed,
          color:
              isFollowing ? Theme.of(context).colorScheme.primary : Colors.blue,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              isFollowing ? "Unfollow" : "Follow",
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
          ),
        ),
      ),
    );
  }
}
