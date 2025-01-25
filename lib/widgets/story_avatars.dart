import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instagram_clone/screens/auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StoryAvatars extends StatelessWidget {
  // Sample image URLs - replace with your actual data
  final List<String> imageUrls = [
    'https://picsum.photos/200',
    'https://picsum.photos/201',
    'https://picsum.photos/202',
    'https://picsum.photos/200',
    'https://picsum.photos/201',
    'https://picsum.photos/202',
  ];

  final supabase = Supabase.instance.client;

  Future<List<String>> fetchUsers() async {
    final usernames =
        await Supabase.instance.client.from('profiles').select('username');

    List<String> usernameList =
        usernames.map((row) => row['username'] as String).toList();
    print(usernameList);
    return usernameList;
  }

  Future<List<String>> fetchAvatars() async {
    final avatars =
        await Supabase.instance.client.from('profiles').select('avatar_url');
    List<String> avatarList =
        avatars.map((d) => d['avatar_url'] as String).toList();
    print(avatarList);
    return avatarList;
  }

  StoryAvatars({super.key});

  @override
  Widget build(BuildContext context) {
    fetchUsers();
    fetchAvatars();
    return Container(
      padding: EdgeInsets.only(top: 8),
      decoration: const BoxDecoration(
          // color: litePrimaryColor,

          ),
      height: 120,
      child: Center(
          child: FutureBuilder(
              future: Future.wait([fetchUsers(), fetchAvatars()]),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error Fetching Users');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text('No Users Found');
                } else {
                  final users = snapshot.data![0];
                  final avatars = snapshot.data![1];
                  return SizedBox(
                    width: imageUrls.length * 80,
                    child: ListView.builder(
                      itemBuilder: (context, index) => Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: CircleAvatar(
                              backgroundColor: buttonColor,
                              radius: 32,
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(avatars[index]),
                                radius: 30,
                                child: avatars[index] == ''
                                    ? Icon(
                                        Icons.person,
                                        size: 40,
                                        color: buttonColor,
                                      )
                                    : Container(),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            users[index],
                            style: GoogleFonts.alata(
                                textStyle: TextStyle(color: buttonColor)),
                          )
                        ],
                      ),
                      scrollDirection: Axis.horizontal,
                      itemCount: users.length,
                    ),
                  );
                }
              })),
    );
  }
}
