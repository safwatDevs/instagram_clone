import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/widgets/auth_gate.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const primaryColor = Color.fromRGBO(183, 0, 255, 1);
const textColor = Color.fromRGBO(21, 21, 21, 1);
const bgColor = Color.fromRGBO(213, 189, 255, 1);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://wduipzitdljmnrxmsrmd.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndkdWlweml0ZGxqbW5yeG1zcm1kIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzcwMTQwOTEsImV4cCI6MjA1MjU5MDA5MX0.QeMnCPCKgM_-eI9KAl7N-JOkihUDEXYI7GbQv6hcKqA',
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: AuthGate(),
      debugShowCheckedModeBanner: false,
    );
  }
}
