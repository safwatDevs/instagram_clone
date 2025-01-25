import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PhotoFocus extends StatelessWidget {
  PhotoFocus(this.url, {super.key});
  String url;
  @override
  Widget build(BuildContext context) {
    return Dismissible(
        dismissThresholds: {
          DismissDirection.startToEnd: 0.5, // Threshold to complete dismiss
        },
        key: ValueKey(''),
        direction: DismissDirection.vertical,
        onDismissed: (direction) {
          Navigator.of(context).pop();
        },
        child: Image.network(url));
  }
}
