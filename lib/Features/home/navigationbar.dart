import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:flutter/material.dart';
import '../Chat/user_selection.dart';
import 'profile_page.dart';
import 'home_page.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.myIndex});
  final int myIndex;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late int _selectedIndex;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.myIndex;
  }

  final List<Widget> _pages = [
    const HomePage(),
    UserSelectionPage(),
    ProfilePage(),
  ];

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 15,right: 15),
        child: SalomonBottomBar(
          currentIndex: _selectedIndex,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Theme.of(context).colorScheme.onSecondary,
          backgroundColor: Theme.of(context).colorScheme.onPrimary,
          items: [
            SalomonBottomBarItem(
              icon: const Icon(
                Icons.home_outlined,
              ),
              title: const Text('Home'),
            ),
            SalomonBottomBarItem(
              icon: const Icon(Icons.message_outlined),
              title: const Text('Chat'),
            ),
            SalomonBottomBarItem(
              icon: const Icon(
                Icons.account_circle_outlined,
              ),
              title: const Text('Account'),
            ),
          ],
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
            _pageController.jumpToPage(index);
          },
        ),
      ),
      body: GestureDetector(
        onHorizontalDragUpdate: (details) {
          if (details.primaryDelta! < 0) {
            if (_selectedIndex < _pages.length - 1) {
              _selectedIndex++;
              _pageController.animateToPage(_selectedIndex,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.ease);
            }
          } else if (details.primaryDelta! > 0) {
            if (_selectedIndex > 0) {
              _selectedIndex--;
              _pageController.animateToPage(_selectedIndex,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.ease);
            }
          }
        },
        child: PageView(
          controller: _pageController,
          onPageChanged: _onPageChanged,
          children: _pages,
        ),
      ),
    );
  }
}
