import 'package:flutter/material.dart';

class DonePayment extends StatelessWidget {
  const DonePayment({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_box,
                    size: 150,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Congratulations',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 34,
                        color: Theme.of(context).colorScheme.primary),
                  ),
                  const Text(
                    'Your Payment Is Successfully Completed',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              padding:
                  const EdgeInsets.symmetric(horizontal: 160, vertical: 17),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text('back',
                style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
