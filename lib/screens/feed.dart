import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/main.dart';
import 'package:instagram_clone/widgets/post_view.dart';
import 'package:instagram_clone/widgets/story_avatars.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'auth.dart';

class FeedScreen extends StatefulWidget {
  FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> fetchPostData() async {
    final currentUserData = await supabase.from('posts').select(
        'id, created_at, email, post_text, post_image_url, likes, username, profile_img');

    return currentUserData.toList();
  }

  late Future<List<Map<String, dynamic>>> _postsFuture;

  @override
  void initState() {
    super.initState();
    _fetchPosts(); // Fetch the posts on initialization
  }

  void _fetchPosts() {
    setState(() {
      _postsFuture = fetchPostData();
    });
  }

  @override
  Widget build(BuildContext context) {
    fetchPostData();
    return Scaffold(
      backgroundColor: buttonColor.withOpacity(0.1),
      body: RefreshIndicator(
        onRefresh: () async {
          _fetchPosts();
        },
        child: SafeArea(
          bottom: false,
          child: FutureBuilder(
              future: fetchPostData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.data == null || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text('No posts'),
                  );
                }

                if (snapshot.hasData) {
                  final posts = snapshot.data as List<Map<String, dynamic>>;

                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        StoryAvatars(),
                        ...posts.map((post) {
                          return PostView(
                            email: post['email'],
                            id: post['id'],
                            profileImg: post['profile_img'],
                            createdAt:
                                post['created_at'].toString().split('T').first,
                            username: post['username'],
                            postText: post['post_text'],
                            imageUrl: post['post_image_url'] ?? '',
                            likes: post['likes'],
                          );
                        }).toList(),
                      ],
                    ),
                  );
                }
                if (snapshot.error != null) {
                  return Center(
                    child: Text('Error Occured: ${snapshot.error}'),
                  );
                }

                return Center(
                  child: Text('Other error'),
                );
              }),
        ),
      ),
    );
  }
}
