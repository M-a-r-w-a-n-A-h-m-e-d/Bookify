import 'dart:async';
import 'package:flutter/material.dart';

class AutoSlide extends StatefulWidget {
  final int totalPages;
  final ValueChanged<int> onPageChanged;
  final PageController pageController;

  const AutoSlide({
    Key? key,
    required this.totalPages,
    required this.onPageChanged,
    required this.pageController,
  }) : super(key: key);

  @override
  _AutoSlideState createState() => _AutoSlideState();
}

class _AutoSlideState extends State<AutoSlide> {
  int currentPage = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), _autoSlide);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _autoSlide(Timer timer) {
    if (currentPage < widget.totalPages - 1) {
      setState(() {
        currentPage++;
      });
      widget.pageController.animateToPage(
        currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      setState(() {
        currentPage = 0;
      });
      widget.pageController.animateToPage(
        currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      height: 150,
      child: Stack(
        children: [
          PageView.builder(
            controller: widget.pageController,
            itemCount: widget.totalPages,
            onPageChanged: (index) {
              setState(() {
                currentPage = index;
              });
              widget.onPageChanged(index);
            },
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(left: 7,right: 7),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/image${index + 1}.png'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
              );
            },
          ),
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.totalPages,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  height: 8,
                  width: currentPage == index ? 10 : 10,
                  decoration: BoxDecoration(
                    color: currentPage == index
                        ? Colors.white
                        : Colors.grey,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
