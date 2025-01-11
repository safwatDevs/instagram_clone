import 'package:flutter/material.dart';

class Priv extends StatelessWidget {
  const Priv({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Padding(
        padding: EdgeInsets.all(20),
        child: Text(
            'Your data is stored on firebase \n We are not responosible for google security problems. \nShare data on your own risk!'),
      ),
      appBar: AppBar(
        title: const Text('Privacy Policy'),
      ),
    );
  }
}
