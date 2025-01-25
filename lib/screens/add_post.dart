import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/screens/auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});
  @override
  State<StatefulWidget> createState() {
    return _AddPostScreenState();
  }
}

class _AddPostScreenState extends State<AddPostScreen> {
  late Future<List<Map<String, dynamic>>> _postsFuture;
  final supabase = Supabase.instance.client;
  File? _postImage;
  final TextEditingController _postText = TextEditingController();
  XFile? image;
  final bottomHighlight = Color.fromARGB(255, 238, 191, 255);
  String? uploadedImageUrl;

  void _addRemoveImage() async {
    if (_postImage == null) {
      showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              child: Container(
                alignment: Alignment.center,
                height: 200,
                child: Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Upload or Capture?',
                        style: GoogleFonts.lato(
                          color: buttonColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 80),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () async {
                                image = await ImagePicker()
                                    .pickImage(source: ImageSource.gallery);
                                Navigator.of(context).pop();

                                if (image != null) {
                                  setState(() {
                                    _postImage = File(image!.path);
                                  });
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 8),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: bottomHighlight),
                                child: Icon(
                                  Icons.add_photo_alternate_outlined,
                                  color: buttonColor,
                                  size: 50,
                                ),
                              ),
                            ),
                            Spacer(),
                            InkWell(
                              onTap: () async {
                                image = await ImagePicker()
                                    .pickImage(source: ImageSource.camera);
                                Navigator.of(context).pop();
                                setState(() {
                                  _postImage = File(image!.path);
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 8),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: bottomHighlight),
                                child: Icon(
                                  Icons.camera_alt_outlined,
                                  color: buttonColor,
                                  size: 50,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          });
    } else {
      setState(() {
        _postImage = null;
      });
    }
  }

  void _cancelPost() {
    if (_postText.text.trim().isNotEmpty || _postImage != null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.warning_rounded,
                color: Colors.red,
                size: 40,
              ),
              SizedBox(width: 10),
              Text(
                'Post will not be saved!',
                style: GoogleFonts.lato(
                  color: buttonColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Text('Discard',
                  style: GoogleFonts.lato(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.red)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  backgroundColor: buttonColor),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Continue',
                  style: GoogleFonts.lato(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            ),
          ],
        ),
      );
    } else {
      Navigator.of(context).pop();
    }
  }

  Future<List<Map<String, dynamic>>> fetchUserData() async {
    final currentUserData = await supabase
        .from('profiles')
        .select('username, email, avatar_url')
        .eq('email', supabase.auth.currentUser!.email!);

    return currentUserData.toList();
  }

  void _sharePost(postText, email, username, profile_img) async {
    String? uploadedImageUrl;

    final email = supabase.auth.currentUser!.email;

    try {
      if (image != null) {
        final imageExtension = image!.path.split('.').last.toLowerCase();
        final imageBytes = await image!.readAsBytes();
        final id = supabase.auth.currentUser!.id;
        final imagePath =
            '$id-${DateTime.now().toIso8601String()}/post.$imageExtension';

        await supabase.storage.from('postsimgs').uploadBinary(
            imagePath, imageBytes,
            fileOptions: FileOptions(contentType: 'image/$imageExtension'));

        uploadedImageUrl =
            supabase.storage.from('postsimgs').getPublicUrl(imagePath);
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${error.toString()}'),
      ));
    }

    await supabase.from('posts').insert({
      'email': email,
      'post_text': postText ?? '',
      'post_image_url': uploadedImageUrl ?? '',
      'username': username,
      'profile_img': profile_img,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: litePrimaryColor),
      child: FutureBuilder(
          future: fetchUserData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                      height: 400,
                      child: Center(child: CircularProgressIndicator())),
                ],
              );
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (snapshot.hasData &&
                snapshot.data != null &&
                snapshot.data!.isNotEmpty) {
              final userData = snapshot.data!.first;
              final currentUsername = userData['username'];
              final currentEmail = userData['email'];
              final currentavatarUrl = userData['avatar_url'];
              return SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.only(left: 16, right: 16, top: 20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          TextButton(
                            onPressed: _cancelPost,
                            child: Text(
                              'Cancel',
                              textAlign: TextAlign.left,
                              style: GoogleFonts.lato(
                                  color: Colors.black.withOpacity(0.7),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Spacer(),
                          ElevatedButton.icon(
                            icon: Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Icon(
                                Icons.public,
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () {
                              if (_postText.text.isNotEmpty ||
                                  _postImage != null) {
                                _sharePost(_postText.text, currentEmail,
                                    currentUsername, currentavatarUrl);
                                Navigator.of(context).pop();
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'Please enter data to share!')));
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: buttonColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18))),
                            label: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 8),
                              child: Text(
                                'Share Post',
                                style: GoogleFonts.lato(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 20),
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  CircleAvatar(
                                    backgroundColor: buttonColor,
                                    radius: 28,
                                    child: (currentavatarUrl != '' ||
                                            currentavatarUrl == null)
                                        ? CircleAvatar(
                                            backgroundImage:
                                                NetworkImage(currentavatarUrl),
                                            radius: 26,
                                          )
                                        : Icon(Icons.account_circle, size: 50),
                                  ),
                                  SizedBox(width: 15),
                                  SizedBox(
                                    width: 200,
                                    child: Column(
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            textAlign: TextAlign.left,
                                            currentUsername,
                                            style: GoogleFonts.lato(
                                                fontWeight: FontWeight.w800,
                                                fontSize: 17,
                                                color: Colors.black),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            currentEmail,
                                            style: GoogleFonts.lato(
                                                color: buttonColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14),
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: 20),
                              Card(
                                elevation: 0,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(18),
                                    border: Border.all(
                                      color: buttonColor,
                                      width: 2,
                                    ),
                                  ),
                                  height: null,
                                  child: Column(
                                    children: [
                                      if (_postImage != null)
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          child: Image.file(
                                            _postImage!,
                                            fit: BoxFit.fitWidth,
                                            width: double.infinity,
                                          ),
                                        ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextField(
                                          controller: _postText,
                                          maxLength: 300,
                                          maxLines: 3,
                                          decoration: InputDecoration(
                                            hintText: 'What is going on...',
                                            hintStyle: GoogleFonts.lato(
                                              fontSize: 16,
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide.none),
                                            enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide.none,
                                                borderRadius:
                                                    BorderRadius.circular(18)),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 8.0,
                                          right: 15,
                                          left: 15,
                                          bottom: 15,
                                        ),
                                        child: Row(
                                          children: [
                                            InkWell(
                                              onTap: _addRemoveImage,
                                              child: Icon(
                                                _postImage == null
                                                    ? Icons
                                                        .insert_photo_outlined
                                                    : Icons.delete_outline,
                                                color: _postImage == null
                                                    ? buttonColor
                                                    : Colors.red,
                                              ),
                                            ),
                                            SizedBox(width: 15),
                                            InkWell(
                                              child: Icon(
                                                Icons.emoji_emotions_outlined,
                                                color: buttonColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 25),
                    ],
                  ),
                ),
              );
            }
            return Center(child: Text('No data found'));
          }),
    );
  }
}
