import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/main.dart';
import 'package:instagram_clone/widgets/story_avatars.dart';

import 'auth.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        StoryAvatars(),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Divider(
            color: buttonColor,
            thickness: 1.5,
          ),
        ),
      ],
    ));
  }
}
