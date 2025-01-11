import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/widgets/auth_gate.dart';

const primaryColor = Color.fromRGBO(183, 0, 255, 1);
const textColor = Color.fromRGBO(21, 21, 21, 1);
const bgColor = Color.fromRGBO(213, 189, 255, 1);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: AuthGate());
  }
}
