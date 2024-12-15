import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_doctor/Features/auth/auth_page.dart';
import 'package:my_doctor/Features/home/notification_page.dart';
import 'package:my_doctor/Features/payment/save_payment.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/Widgets/MyLabel_customWidget.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Profile',
          style: TextStyle(
            fontSize: screenWidth * 0.065,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: screenWidth * 0.12,
                      backgroundImage: user!.photoURL != null
                          ? NetworkImage(user!.photoURL!)
                          : const AssetImage('assets/profile_pic_purple.png')
                              as ImageProvider,
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Text(
                      user!.displayName ?? 'User',
                      style: TextStyle(
                        fontSize: screenWidth * 0.05,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              MyLabel(
                context: context,
                msg: 'Personal Details',
                onTap: () {},
                icon: Icons.account_circle_outlined,
              ),
              MyLabel(
                context: context,
                msg: 'Payment',
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SavePayment(),
                    ),
                  );
                },
                icon: Icons.payment,
              ),
              MyLabel(
                context: context,
                msg: 'Contact Us',
                onTap: () async {
                  final Uri updateUrl =
                      Uri(scheme: 'https', host: 'guns.lol', path: '/kaiowa');
                  try {
                    if (await canLaunchUrl(updateUrl)) {
                      await launchUrl(updateUrl);
                    } else {
                      print('Could not launch the URL.');
                    }
                  } catch (e) {
                    print('Error: $e');
                  }
                },
                icon: Icons.help_outline,
              ),
              Container(
                margin: EdgeInsets.all(screenWidth * 0.02),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onPrimary,
                  borderRadius: BorderRadius.circular(11.0),
                ),
                child: ListTile(
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    await GoogleSignIn().signOut();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AuthPage(),
                      ),
                    );
                  },
                  tileColor: Theme.of(context).colorScheme.surface,
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.05,
                      vertical: screenHeight * 0.015),
                  leading: const Icon(
                    Icons.logout_outlined,
                    color: Colors.red,
                  ),
                  title: const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Logout',
                        style: TextStyle(color: Colors.red),
                      ),
                      Spacer(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
