import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/screens/priv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const primaryColor = Color.fromRGBO(109, 1, 151, 1);
const buttonColor = Color.fromRGBO(109, 1, 151, 1);
const textColor = Color.fromRGBO(21, 21, 21, 1);
const bgColor = Color.fromRGBO(213, 189, 255, 1);
const litePrimaryColor = Color.fromRGBO(246, 222, 255, 1);

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  var isLogin = false;
  var enteredUsername;
  var enteredEmail;
  var enteredPassword;
  final _key = GlobalKey<FormState>();
  File? _image;
  final supabase = Supabase.instance.client;
  var isLoading = false;
  XFile? image;
  String? imageUrl;
  bool checkBoxValue = false;

  void getImage() async {
    image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = File(image!.path);
      });
    }
    return;
  }

  Future<void> submitForm() async {
    if (!_key.currentState!.validate() && checkBoxValue == false) {
      return;
    }
    _key.currentState!.save();
    setState(() {
      isLoading = true;
    });

    String? uploadedImageUrl;

    if (image != null) {
      final imageExtension = image!.path.split('.').last.toLowerCase();
      final imageBytes = await image!.readAsBytes();
      final imagePath =
          '$enteredUsername-${DateTime.now().toIso8601String()}/avatar.$imageExtension';

      await supabase.storage.from('avatars').uploadBinary(imagePath, imageBytes,
          fileOptions: FileOptions(contentType: 'image/$imageExtension'));

      uploadedImageUrl =
          supabase.storage.from('avatars').getPublicUrl(imagePath);
    }

    try {
      if (!isLogin) {
        // Sign Up
        final response = await supabase.auth.signUp(
          email: enteredEmail,
          password: enteredPassword,
        );

        if (response.user != null) {
          await supabase.from('profiles').insert({
            'username': enteredUsername,
            'email': enteredEmail,
            'avatar_url': uploadedImageUrl ?? '',
          });
        }
      } else {
        //Sign In
        await supabase.auth
            .signInWithPassword(email: enteredEmail, password: enteredPassword);
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${error.toString()}'),
      ));
      print('Error: ${error.toString()}');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: primaryColor),
        child: Container(
          margin: EdgeInsets.only(
            top: screenHeight - screenHeight * 77 / 100,
          ),
          width: double.infinity,
          height: double.infinity,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
                bottomLeft: Radius.zero,
                bottomRight: Radius.zero,
              ),
              border: Border.all(color: Colors.transparent),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                        !isLogin ? 'Get Started' : 'Welcome back',
                        style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: primaryColor),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      if (!isLogin)
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: InkWell(
                            onTap: getImage,
                            child: CircleAvatar(
                              backgroundColor: primaryColor,
                              radius: 40.0,
                              child: CircleAvatar(
                                radius: 38.0,
                                backgroundColor: Colors.white,
                                child: _image != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: Image.file(
                                          _image!,
                                          width: 100,
                                          height: 76,
                                        ))
                                    : const Icon(
                                        Icons.person,
                                        size: 35,
                                        color: Colors.grey,
                                      ),
                              ),
                            ),
                          ),
                        ),
                      Form(
                        key: _key,
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            if (!isLogin)
                              TextFormField(
                                validator: (username) {
                                  if (username == null ||
                                      username.isEmpty ||
                                      username.length < 5) {
                                    return 'Username should be at least 5 characters';
                                  }
                                  enteredUsername = username;
                                  return null;
                                },
                                decoration: InputDecoration(
                                  labelText: 'Username',
                                  hintText: 'Enter Username',
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 16.0,
                                    horizontal: 16.0,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade300, width: 2),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: primaryColor, width: 2),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                            const SizedBox(height: 20),
                            TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              validator: (email) {
                                if (email == null ||
                                    email.isEmpty ||
                                    email.contains('@') == false ||
                                    email.length < 8) {
                                  return 'Please enter a valid email address';
                                }
                                enteredEmail = email;
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: 'Email',
                                hintText: 'Enter Email',
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 16.0,
                                  horizontal: 16.0,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey.shade300, width: 2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: primaryColor, width: 2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              obscureText: true,
                              validator: (password) {
                                if (password == null ||
                                    password.isEmpty ||
                                    password.length < 8) {
                                  return 'Passwords must be at least 8 characters';
                                }
                                enteredPassword = password;
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: 'Password',
                                hintText: 'Enter Password',
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 16.0,
                                  horizontal: 16.0,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey.shade300, width: 2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: primaryColor, width: 2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            if (!isLogin)
                              Row(
                                children: [
                                  Checkbox(
                                    value: false,
                                    onChanged: (checked) {
                                      checkBoxValue = !checkBoxValue;
                                    },
                                    activeColor: primaryColor,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const Priv()));
                                    },
                                    child: RichText(
                                      text: const TextSpan(
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.black,
                                        ),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text:
                                                  'I agree to the proccessing of '),
                                          TextSpan(
                                              text: 'Personal Data',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: primaryColor)),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              height: 55,
                              child: ElevatedButton(
                                onPressed: submitForm,
                                style: const ButtonStyle(
                                    shape: WidgetStatePropertyAll(
                                        RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20)))),
                                    backgroundColor:
                                        WidgetStatePropertyAll(primaryColor)),
                                child: Text(
                                  isLogin ? 'Sign In' : 'Sign Up',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                            // const SizedBox(height: 20),
                            // const Divider(),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      InkWell(
                        onTap: () {
                          setState(() {
                            isLogin = !isLogin;
                          });
                        },
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 14.0,
                              color: Colors.black,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                  text: !isLogin
                                      ? 'Already have an accont? '
                                      : 'Dont have an account? '),
                              TextSpan(
                                  text: !isLogin ? 'Sign In' : 'Sign Up',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: primaryColor)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
