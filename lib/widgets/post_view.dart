import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instagram_clone/screens/auth.dart';
import 'package:instagram_clone/widgets/photo_focus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PostView extends StatefulWidget {
  PostView({
    super.key,
    required this.email,
    required this.id,
    required this.profileImg,
    required this.createdAt,
    required this.username,
    this.postText,
    this.imageUrl,
    required this.likes,
  });
  String email;
  int id;
  String profileImg;
  String username;
  String createdAt;
  String? postText;
  String? imageUrl;
  int likes;

  @override
  State<PostView> createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  final supabase = Supabase.instance.client;

  Future<String> fetchPostData() async {
    final currentNumberOfLikes =
        await supabase.from('posts').select('id, email').eq('id', widget.id);

    print(currentNumberOfLikes.first['email']);
    return currentNumberOfLikes.first['email'];
  }

  bool liked = false;

  @override
  Widget build(BuildContext context) {
    fetchPostData();
    var width = MediaQuery.sizeOf(context).width;
    width -= width * 35 / 100;

    fetchPostData();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      child: Card(
        shadowColor: Colors.transparent,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(color: Colors.white),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 12, left: 12, right: 12),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    CircleAvatar(
                      backgroundColor: buttonColor,
                      radius: 24,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(widget.profileImg),
                        radius: 22,
                      ),
                    ),
                    SizedBox(width: 15),
                    SizedBox(
                      width: width,
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              textAlign: TextAlign.left,
                              widget.username,
                              style: GoogleFonts.lato(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 14,
                                  color: Colors.black),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              widget.createdAt,
                              style: GoogleFonts.lato(
                                  color: buttonColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (supabase.auth.currentUser!.email == widget.email)
                      IconButton(
                          onPressed: () {
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
                                      'Post will be deleted forever!',
                                      style: GoogleFonts.lato(
                                        color: buttonColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Cancel',
                                        style: GoogleFonts.lato(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: buttonColor)),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        backgroundColor: Colors.red),
                                    onPressed: () async {
                                      await supabase
                                          .from('posts')
                                          .delete()
                                          .eq('id', widget.id);
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Delete',
                                        style: GoogleFonts.lato(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white)),
                                  ),
                                ],
                              ),
                            );
                          },
                          icon: Icon(
                            Icons.delete_outline,
                            size: 30,
                            color: buttonColor,
                          ))
                  ],
                ),
              ),
              SizedBox(height: 12),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.postText ?? '',
                    style: GoogleFonts.lato(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              SizedBox(
                  height: (widget.imageUrl == null ||
                          widget.imageUrl!.isEmpty ||
                          widget.imageUrl == '')
                      ? 0
                      : 15),
              if (widget.imageUrl != null && widget.imageUrl != '')
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PhotoFocus(widget.imageUrl!)),
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: (widget.imageUrl == null ||
                              widget.imageUrl!.isEmpty ||
                              widget.imageUrl == '')
                          ? SizedBox(height: 0)
                          : Image.network(
                              widget.imageUrl!,
                              fit: BoxFit.fitWidth,
                            ),
                    ),
                  ),
                ),
              // SizedBox(
              //     height:
              //         (imageUrl == null || imageUrl!.isEmpty || imageUrl == '')
              //             ? 0
              //             : 12),

              Padding(
                padding: EdgeInsets.all(8),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shadowColor: Colors.transparent,
                      side: BorderSide(color: buttonColor)),
                  onPressed: () async {
                    setState(() {
                      liked = !liked;
                      liked ? widget.likes += 1 : widget.likes -= 1;
                    });

                    await supabase
                        .from('posts')
                        .update({'likes': widget.likes}).eq('id', widget.id);
                  },
                  label: Text(
                    widget.likes.toString(),
                    style: GoogleFonts.lato(
                        color: buttonColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12),
                  ),
                  icon: Icon(
                    liked ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                    color: buttonColor,
                    size: 26,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
