import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instagram_clone/screens/add_post.dart';
import 'package:instagram_clone/screens/auth.dart';
import 'package:instagram_clone/screens/feed.dart';
import 'package:instagram_clone/screens/profile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int bottomBarIndex = 0;
  final _pages = [FeedScreen(), AddPostScreen(), ProfileScreen()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 35),
          SizedBox(
            height: 70,
            child: Center(
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  'SafwatGram',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.pacifico(
                      textStyle: TextStyle(color: buttonColor, fontSize: 24)),
                ),
              ),
            ),
          ),
          Expanded(
            child: Stack(children: [
              _pages[bottomBarIndex],
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  margin:
                      const EdgeInsets.only(right: 50, left: 50, bottom: 30),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: NavigationBar(
                      height: 30,
                      animationDuration: const Duration(milliseconds: 500),
                      labelBehavior:
                          NavigationDestinationLabelBehavior.alwaysHide,
                      backgroundColor: litePrimaryColor,
                      destinations: const [
                        NavigationDestination(
                          icon: Icon(
                            Icons.home_outlined,
                            color: buttonColor,
                          ),
                          selectedIcon: Icon(
                            Icons.home,
                            color: buttonColor,
                          ),
                          label: '',
                        ),
                        NavigationDestination(
                          icon: Icon(Icons.add_circle_outline_outlined,
                              color: buttonColor),
                          selectedIcon: Icon(
                            Icons.add_circle,
                            color: buttonColor,
                          ),
                          label: '',
                        ),
                        NavigationDestination(
                          icon: Icon(
                            Icons.person_outline,
                            color: buttonColor,
                          ),
                          label: '',
                          selectedIcon: Icon(
                            Icons.person,
                            color: buttonColor,
                          ),
                        )
                      ],
                      onDestinationSelected: (index) {
                        setState(() {
                          bottomBarIndex = index;
                        });
                      },
                      selectedIndex: bottomBarIndex,
                      indicatorColor: primaryColor.withOpacity(0.15),
                      indicatorShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side:
                              BorderSide(width: 8, color: Colors.transparent)),
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
