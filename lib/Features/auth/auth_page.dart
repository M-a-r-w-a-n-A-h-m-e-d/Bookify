import 'package:my_doctor/Features/auth/sign_in_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../home/navigationbar.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (FirebaseAuth.instance.currentUser != null) {
            if (snapshot.hasData) {
              var user = snapshot.data;
              if (user != null &&
                  user.providerData.any((provider) =>
                      provider.providerId == 'google.com' ||
                      provider.providerId == 'facebook.com' ||
                      provider.providerId == 'apple.com')) {
                return const Home(
                  myIndex: 0,
                );
              }
              if (user != null && user.emailVerified) {
                return const Home(
                  myIndex: 0,
                );
              }
            }
          }
          return const SignIn();
        },
      ),
    );
  }
}
