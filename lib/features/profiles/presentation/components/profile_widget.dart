import 'package:flutter/material.dart';

class RelationWidget extends StatelessWidget {
  final int postCount;
  final int followerCount;
  final int followingCount;
  final void Function()? onTap;

  const RelationWidget({
    super.key,
    required this.postCount,
    required this.followerCount,
    required this.followingCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    var textStyleColor =
        TextStyle(color: Theme.of(context).colorScheme.primary);
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text(
                  postCount.toString(),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Text(
                  "Post",
                  style: textStyleColor,
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  followerCount.toString(),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Text(
                  "Follower",
                  style: textStyleColor,
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  followingCount.toString(),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Text(
                  "Following",
                  style: textStyleColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileButton extends StatelessWidget {
  final String text;
  final void Function()? onTap;

  const ProfileButton({super.key, required this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(child: Text(text)),
          ),
        ),
      ),
    );
  }
}

class BubbleStories extends StatelessWidget {
  final String text;

  const BubbleStories({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(text),
        ],
      ),
    );
  }
}

class StyleText extends StatelessWidget {
  final String text;

  const StyleText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 12,
        color: Colors.white,
      ),
    );
  }
}
// profile post widget

class StoriesData {
  static List<String> stories = const [
    'My Story',
    '2024',
    '2025',
    'My Story',
    '2024',
    '2025',
    'My Story',
    '2024',
    '2025',
  ];
}
