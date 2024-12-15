import 'package:my_doctor/Features/auth/forgot_pass_page.dart';
import 'package:my_doctor/Features/auth/sign_up_page.dart';
import 'package:my_doctor/core/services/auth_service.dart';
import 'package:my_doctor/core/Widgets/my_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_doctor/core/Widgets/passText_customWidget.dart';

import 'auth_page.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> with SingleTickerProviderStateMixin {
  bool canPop = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _showErrorMessage(String msg) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.red,
          title: Center(
            child: Text(
              msg,
              style: const TextStyle(color: Color(0xFFFFFFFF)),
            ),
          ),
        );
      },
    );
  }

  Future<void> _signUserIn() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showErrorMessage('Please fill all fields');
      return;
    }

    try {
      final userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;

      if (user != null) {
        if (user.emailVerified) {
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => const Home( //!Change
          //       myIndex: 1,
          //     ),
          //   ),
          // );
        }
      } else {
        _showErrorMessage('User does not exist');
      }
    } catch (e) {
      _showErrorMessage('Error signing in');
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool value) async {
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => const WelcomePage(),//! Change
        //   ),
        // );
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.onPrimary,
          resizeToAvoidBottomInset: false,
          body: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
              minWidth: MediaQuery.of(context).size.width,
            ),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: Text(
                      'Welcome',
                      style: TextStyle(
                          fontSize: 26,
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 25, bottom: 10),
                    child: Text('Sign In',
                        style: TextStyle(
                            fontSize: 22,
                            color: Colors.black,
                            fontWeight: FontWeight.bold)),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 25, bottom: 10),
                    child: Text(
                        'Here you can sign in to your account to use the app',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        )),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 25, bottom: 10),
                    child: Text('Email',
                        style: TextStyle(
                            fontSize: 22,
                            color: Colors.black,
                            fontWeight: FontWeight.bold)),
                  ),
                  MyTextField(
                    controller: emailController,
                    label: 'Enter Your Email',
                    obscureText: false,
                    prefixIcon: const Icon(Icons.mail_outlined),
                  ),
                  const SizedBox(height: 25),
                  const Padding(
                    padding: EdgeInsets.only(left: 25, bottom: 10),
                    child: Text(
                      'Password',
                      style: TextStyle(
                          fontSize: 22,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  PassTextField(
                    controller: passwordController,
                    label: 'Enter Your Password',
                    obscureText: true,
                    prefixIcon: const Icon(Icons.lock_outline),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 17),
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ForgotPass(),
                              ),
                            );
                          },
                          child: const Text(
                            'Forgot Password',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: ElevatedButton(
                      onPressed: _signUserIn,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 160, vertical: 17),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text('Sign In',
                          style: TextStyle(
                              fontSize: 18,
                              color: Theme.of(context).colorScheme.onSecondary,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: Text(
                      'OR',
                      style: TextStyle(
                          fontSize: 19,
                          color: Theme.of(context).colorScheme.onSecondary),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () => AuthService.signInWithFacebook(),
                        icon: Image.asset(
                          'assets/facebook.png',
                          height: 80,
                          width: 80,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          var google = await AuthService().signInWithGoogle();
                          if (google != null) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AuthPage(),
                              ),
                            );
                          }
                        },
                        icon: Image.asset(
                          'assets/google.png',
                          height: 80,
                          width: 80,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Dont have an account?',
                        style: TextStyle(
                            fontSize: 15,
                            color: Theme.of(context).colorScheme.onSecondary),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignUp(),
                            ),
                          );
                        },
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    DateTime currentTime = DateTime.now();
    final difference = currentTime.difference(lastBackPressed);
    bool isExitWarning = difference >= const Duration(seconds: 2);

    lastBackPressed = currentTime;

    if (isExitWarning) {
      Fluttertoast.showToast(
        msg: 'Press back again to exit',
        fontSize: 18,
      );
      return Future.value(false);
    } else {
      Fluttertoast.cancel();
      return Future.value(true);
    }
  }

  DateTime lastBackPressed = DateTime.now();
}
