import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_doctor/Features/doctors/all_doctors.dart';
import 'package:my_doctor/core/Widgets/my_autoslide.dart';
import '../../core/Widgets/my_scrollable.dart';
import '../../core/Widgets/search_bar.dart';
import '../../core/models/doctor_model.dart';
import '../doctors/doctor_card.dart';
import 'navigationbar.dart';
import 'notification_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var user = FirebaseAuth.instance.currentUser;

  late PageController _pageController;
  final int _totalPages = 4;
  int _currentPage = 0;
  late Timer _timer;
  late DatabaseReference _databaseReference;
  List<Doctor> doctorsList = [];
  final List<String> categories = [
    'Danteeth',
    'Therapist',
    'Surgeon',
    'Category 4',
    'Category 5'
  ];

  final List<Widget> _pages = [
    const Home(
      myIndex: 0,
    ),
    const Home(
      myIndex: 0,
    ),
    const Home(
      myIndex: 0,
    ),
    const Home(
      myIndex: 0,
    ),
    const Home(
      myIndex: 0,
    ),
  ];

  Future<void> _fetchDoctorsData() async {
    try {
      DataSnapshot snapshot = await _databaseReference.get();

      if (snapshot.exists) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;

        setState(() {
          var doctors = data.values.map((doctorData) {
            return Doctor.fromJson(Map<String, dynamic>.from(doctorData));
          }).toList();

          doctors.sort((a, b) {
            double starsA = double.tryParse(a.stars) ?? 0;
            double starsB = double.tryParse(b.stars) ?? 0;
            return starsB.compareTo(starsA);
          });

          doctorsList = List.from(doctors);
        });
      } else {
        print("No doctors found.");
      }
    } catch (e) {
      print("Error fetching doctors data: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _databaseReference = FirebaseDatabase.instance.ref().child('doctors');
    _fetchDoctorsData();
    _pageController = PageController();

    _timer = Timer.periodic(
      const Duration(seconds: 3),
      (timer) {
        if (_currentPage < _totalPages - 1) {
          _currentPage++;
        } else {
          _currentPage = 0;
        }

        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(seconds: 1),
          curve: Curves.easeInOut,
        );
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundImage: user!.photoURL != null
                              ? NetworkImage(user!.photoURL!)
                              : const AssetImage(
                                      'assets/profile_pic_purple.png')
                                  as ImageProvider,
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Hi, Welcome Back,'),
                            Text(
                              user!.displayName ?? 'User',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Notifications(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.notifications_none),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                MySearch(
                  context: context,
                  msg: 'Search a Doctor',
                  onTap: () {},
                ),
                AutoSlide(
                  totalPages: _totalPages,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  pageController: _pageController,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Categories',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text('See All'),
                    ),
                  ],
                ),
                MyScrollable(
                  context: context,
                  itemCount: categories.length,
                  color: Theme.of(context).colorScheme.primary,
                  categories: categories,
                  pages: _pages,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'All Doctors',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AllDoctors(),
                          ),
                        );
                      },
                      child: const Text('See All'),
                    ),
                  ],
                ),
                Column(
                  children: doctorsList.take(3).map((doctor) {
                    return DoctorCard(doctor: doctor);
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
