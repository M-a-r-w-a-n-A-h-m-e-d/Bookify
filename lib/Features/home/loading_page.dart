import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../auth/auth_page.dart';
import 'navigationbar.dart';
import 'welcome_page.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  bool _showCards = false;
  bool isDark = false;
  bool _initialized = false;
  bool _isFirstLaunch = true;
  bool _haveUpgrade = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _checkFirstLaunch();
  }

  Future<void> _checkFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    _isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;
    if (_isFirstLaunch) {
      await prefs.setBool('isFirstLaunch', false);
    }
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      await Future.wait([
        //_permissionsHandler(),
        _checkForUpdate()
      ]);
    } catch (e) {
      print('Initialization error: $e');
    }
  }

  Future<void> _checkForUpdate() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    try {
      await remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: Duration.zero,
        ),
      );
      await remoteConfig.fetchAndActivate();

      final latestVersion = remoteConfig.getString('latest_version');
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;
      if (mounted) {
        setState(() {
          _haveUpgrade = currentVersion != latestVersion;
        });
      }

      if (_haveUpgrade) {
        _showUpdateDialog();
      } else {
        _navigateToNextPage();
      }
    } catch (e) {
      Sentry.captureException(e);
      print('Error fetching remote config: $e');
      await Future.delayed(const Duration(seconds: 8));
      _checkForUpdate();
    }
  }

  Future<void> _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isDark = prefs.getBool('dark_mode') ?? false;
    });
  }

  void _navigateToNextPage() {
    if (_initialized) {
      if (_haveUpgrade) {
        Navigator.of(context, rootNavigator: true).pop();
      }
      Future.delayed(const Duration(seconds: 5)).then(
        (_) => Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const AuthPage(),
          ),
        ),
      );
    } else {
      if (mounted) {
        setState(() {
          _showCards = _isFirstLaunch;
          _initialized = true;
        });
      }
      if (_haveUpgrade) {
        Navigator.of(context, rootNavigator: true).pop();
      }
      Future.delayed(const Duration(seconds: 5)).then(
        (_) => Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => _showCards ? const Cards() : const AuthPage(),
          ),
        ),
      );
    }
  }

  void _showUpdateDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text('Update Available',
              style: TextStyle(color: Theme.of(context).colorScheme.primary)),
          content: Text(
              'A new version of the app is available. Please update to the latest version.',
              style:
                  TextStyle(color: Theme.of(context).colorScheme.onSecondary)),
          actions: [
            TextButton(
              onPressed: _navigateToNextPage,
              child: Text('Later',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary)),
            ),
            TextButton(
              onPressed: launchURL,
              child: Text('Update',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary)),
            ),
          ],
        );
      },
    );
  }

  Future<void> launchURL() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    try {
      await remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: Duration.zero,
        ),
      );
      await remoteConfig.fetchAndActivate();

      final String updateUrl = remoteConfig.getString('download_link');

        await launch(updateUrl);

    } catch (e) {
      _showErrorMessage('An error occurred while trying to launch the URL.');
    }
  }

  void _showErrorMessage(String msg) {
    if (mounted) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.red,
            title: Center(
              child: Text(
                msg,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: false,
      body: Center(
        child: SizedBox.expand(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: isDark
                    ? const AssetImage('assets/loading_background_dark.png')
                    : const AssetImage('assets/loading_background_light.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: _showCards
                ? const SizedBox()
                : Center(
                    child: isDark
                        ? Image.asset('assets/main_app.jpg')
                        : Image.asset('assets/main_app.jpg'),
                  ),
          ),
        ),
      ),
    );
  }
}

class Cards extends StatefulWidget {
  const Cards({super.key});

  @override
  State<Cards> createState() => _CardsState();
}

class _CardsState extends State<Cards> {
  final controller = PageController();
  bool nextScreen = false;
  bool notFirstpage = false;
  int? last;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          PageView(
            controller: controller,
            onPageChanged: (index) {
              setState(() {
                if (index == 3) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Home(
                        myIndex: 0,
                      ),
                    ),
                  );
                }
              });
            },
            children: const [
              OnboardingPage(
                title: 'Track Accidents',
                description: 'Easily track and report accidents in real-time.',
                imageAsset: 'assets/IVision.png',
                color: Colors.blue,
              ),
              OnboardingPage(
                title: 'Get Notifications',
                description:
                    'Receive timely notifications about accidents and updates.',
                imageAsset: 'assets/IVision.png',
                color: Colors.yellow,
              ),
              OnboardingPage(
                title: 'Google Maps',
                description: 'Built In Google Maps and its Service.\n',
                imageAsset: 'assets/IVision.png',
                color: Colors.red,
              ),
              OnboardingPage(
                title: 'User-Friendly Interface',
                description:
                    'Enjoy a seamless and user-friendly interface for tracking and reporting.',
                imageAsset: 'assets/IVision.png',
                color: Colors.green,
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 16,
            right: 32,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Home(
                          myIndex: 0,
                        ),
                      ),
                    );
                  },
                  child: Text('Skip', style: TextStyle(color: Colors.grey)),
                ),
                SmoothPageIndicator(
                  controller: controller,
                  count: 4,
                  effect: ExpandingDotsEffect(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String title;
  final String description;
  final String imageAsset;
  final Color color;

  const OnboardingPage(
      {super.key,
      required this.title,
      required this.description,
      required this.imageAsset,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(imageAsset),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(description, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
