import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/screens/auth.dart';
import 'package:instagram_clone/screens/home.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
        stream: Supabase.instance.client.auth.onAuthStateChange,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
                body: const Center(child: CircularProgressIndicator()));
          }

          final session = Supabase.instance.client.auth.currentSession;

          if (session != null) {
            return const HomeScreen();
          }
          return const AuthScreen();
        });
  }
}
