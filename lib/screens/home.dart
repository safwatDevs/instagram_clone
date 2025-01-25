import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instagram_clone/screens/add_post.dart';
import 'package:instagram_clone/screens/auth.dart';
import 'package:instagram_clone/screens/feed.dart';
import 'package:instagram_clone/screens/profile.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final bottomHighlight = Color.fromARGB(255, 238, 191, 255);
  bool isHomeActive = true;
  bool isProfileActive = false;
  int bottomBarIndex = 0;

  @override
  Widget build(BuildContext context) {
    final _page = isHomeActive ? FeedScreen() : ProfileScreen();
    return Scaffold(
      backgroundColor: litePrimaryColor,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: litePrimaryColor,
        surfaceTintColor: litePrimaryColor,
        shadowColor: buttonColor,
        title: Text(
          'SafwatGram',
          textAlign: TextAlign.center,
          style: GoogleFonts.pacifico(
              textStyle: TextStyle(color: buttonColor, fontSize: 24)),
        ),
      ),
      body: Column(
        children: [
          Expanded(child: _page),
          Container(
            margin: EdgeInsets.only(bottom: 25, right: 50, left: 50),
            decoration: BoxDecoration(
                color: litePrimaryColor,
                borderRadius: BorderRadius.circular(15)),
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      isHomeActive = true;
                      isProfileActive = false;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color:
                          isHomeActive ? bottomHighlight : Colors.transparent,
                    ),
                    child: Icon(
                      isHomeActive ? Icons.home : Icons.home_outlined,
                      color: buttonColor,
                      size: 32,
                    ),
                  ),
                ),
                Spacer(),
                InkWell(
                  onTap: () {
                    showModalBottomSheet(
                        isDismissible: false,
                        context: context,
                        builder: (context) =>
                            KeyboardAvoider(child: AddPostScreen()),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        useSafeArea: true,
                        isScrollControlled: true);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.transparent,
                    ),
                    child: Icon(
                      Icons.add_circle_outline,
                      color: buttonColor,
                      size: 32,
                    ),
                  ),
                ),
                Spacer(),
                InkWell(
                  onTap: () {
                    setState(() {
                      isProfileActive = true;
                      isHomeActive = false;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: isProfileActive
                          ? bottomHighlight
                          : Colors.transparent,
                    ),
                    child: Icon(
                      isProfileActive ? Icons.person : Icons.person_outline,
                      color: buttonColor,
                      size: 32,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
