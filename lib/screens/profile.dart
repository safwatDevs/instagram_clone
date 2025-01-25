import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instagram_clone/main.dart';
import 'package:instagram_clone/screens/add_post.dart';
import 'package:instagram_clone/screens/auth.dart';
import 'package:instagram_clone/widgets/post_view.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});
  final supabase = Supabase.instance.client;
  Future<List<Map<String, dynamic>>> fetchProfilesData() async {
    final currentUserData = await supabase
        .from('profiles')
        .select('id, created_at, username, email, avatar_url, followers')
        .eq('email', supabase.auth.currentUser!.email!);

    return currentUserData.toList();
  }

  Future<List<Map<String, dynamic>>> fetchPostData() async {
    final currentUserData = await supabase.from('posts').select(
        'id, created_at, email, post_text, post_image_url, likes, username, profile_img');

    return currentUserData.toList();
  }

  void _logOut(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'Are you sure you want to log out!',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'No',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Supabase.instance.client.auth.signOut();
                  Navigator.of(context).pop();
                },
                style: const ButtonStyle(
                    shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)))),
                    backgroundColor: WidgetStatePropertyAll(buttonColor)),
                child: const Text(
                  'Log Out',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.white),
                ),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: litePrimaryColor,
      body: Align(
        alignment: Alignment.center,
        child: Center(
            child: FutureBuilder(
                future: fetchProfilesData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.data == null || snapshot.data!.isEmpty) {
                    Text('No user');
                  }
                  if (snapshot.error != null) {
                    return Text('Error Occurred: ${snapshot.error}');
                  }
                  final user = snapshot.data!.first;
                  return Column(
                    children: [
                      SizedBox(height: 30),
                      CircleAvatar(
                        backgroundColor: buttonColor,
                        radius: 53,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(user['avatar_url']),
                          radius: 50,
                          child: user['avatar_url'] == ''
                              ? Icon(
                                  Icons.person,
                                  size: 40,
                                  color: buttonColor,
                                )
                              : Container(),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        user['username'],
                        style: GoogleFonts.lato(
                            color: Colors.black,
                            fontSize: 28,
                            fontWeight: FontWeight.w900),
                      ),
                      SizedBox(height: 5),
                      Text(
                        user['email'],
                        style: GoogleFonts.lato(
                            color: buttonColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 16),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ElevatedButton.icon(
                              icon: Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Icon(
                                  Icons.add,
                                  size: 23,
                                  color: Colors.white,
                                ),
                              ),
                              onPressed: () {
                                showModalBottomSheet(
                                    isDismissible: false,
                                    context: context,
                                    builder: (context) =>
                                        KeyboardAvoider(child: AddPostScreen()),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    useSafeArea: true,
                                    isScrollControlled: true);
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: buttonColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18))),
                              label: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 8),
                                child: Text(
                                  'Post',
                                  style: GoogleFonts.lato(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                            ElevatedButton.icon(
                              icon: Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Icon(
                                  Icons.logout,
                                  size: 23,
                                  color: buttonColor,
                                ),
                              ),
                              onPressed: () {
                                _logOut(context);
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: litePrimaryColor,
                                  side: BorderSide(color: buttonColor),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18))),
                              label: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 8),
                                child: Text(
                                  'Log Out',
                                  style: GoogleFonts.lato(
                                      color: buttonColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Divider(
                          color: buttonColor,
                          thickness: 2,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Member Since: ${user['created_at'].toString().split('T').first}',
                        style: GoogleFonts.lato(
                          color: buttonColor,
                          fontSize: 16,
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 26, vertical: 10),
                          child: Text(
                            'I am Abdullah Safwat, The founder of Safwat Development. We created this from scratch using Flutter and Supabase. We are ready to create any app you want.',
                            style: GoogleFonts.lato(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                })),
      ),
    );
  }
}
