import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instagram_clone/screens/auth.dart';

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

  Future<List<Map<String, dynamic>>> fetchUsers() async {
    final snapshot = await FirebaseFirestore.instance.collection('users').get();
    return snapshot.docs.map((user) => user.data()).toList();
  }

  StoryAvatars({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          // color: litePrimaryColor,

          ),
      height: 120,
      child: Center(
          child: FutureBuilder(
              future: fetchUsers(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error Fetching Users');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text('No Users Found');
                } else {
                  final users = snapshot.data!;
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
                                backgroundImage: NetworkImage(imageUrls[index]),
                                radius: 30,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            users[index]['username'],
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
