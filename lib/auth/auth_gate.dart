import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'login_page.dart';
import 'security_choice_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Color(0xFFFAF7FC),
            body: Center(
              child: CircularProgressIndicator(
                color: Color(0xFF0040A1),
              ),
            ),
          );
        }

        if (snapshot.hasData) {
          return SecurityChoicePage();
        }

        return const LoginPage();
      },
    );
  }
}