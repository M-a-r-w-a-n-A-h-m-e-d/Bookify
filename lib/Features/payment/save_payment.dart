import 'package:my_doctor/Features/home/navigationbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/Widgets/my_textfield.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'load_saved_payment.dart';

class SavePayment extends StatefulWidget {
  const SavePayment({super.key});

  @override
  State<SavePayment> createState() => _SavePaymentState();
}

class _SavePaymentState extends State<SavePayment> {
  final cardNumber = TextEditingController();
  final expiryDate = TextEditingController();
  final name = TextEditingController();
  final cvv = TextEditingController();

  Future<void> savePaymentCard() async {
    final prefs = await SharedPreferences.getInstance();

    Map<String, String> card = {
      'cardNumber': cardNumber.text,
      'expiryDate': expiryDate.text,
      'name': name.text,
      'cvv': cvv.text,
    };

    String cardJson = jsonEncode(card);

    List<String> savedCardsList = prefs.getStringList('savedCards') ?? [];

    savedCardsList.add(cardJson);

    await prefs.setStringList('savedCards', savedCardsList);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Payment Method Saved'),
      ),
    );

    cardNumber.clear();
    expiryDate.clear();
    name.clear();
    cvv.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoadSavedPayment(),
                ),
              );
            },
            icon: const Icon(Icons.payment_outlined),
          ),
        ],
        leading: IconButton(
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
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const Text(
          'Payment',
          style: TextStyle(
            fontSize: 27,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            Container(
              height: MediaQuery.of(context).size.height / 1.6,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Text(
                          'Save Payment Method',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 26,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Padding(
                        padding: EdgeInsets.only(left: 30.0),
                        child: Text(
                          'Card Number',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      MyTextField(
                        controller: cardNumber,
                        obscureText: false,
                        prefixIcon: const Icon(Icons.payment),
                        label: 'Card Number',
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(left: 30.0),
                                  child: Text(
                                    'Expiry Date',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                MyTextField(
                                  controller: expiryDate,
                                  obscureText: false,
                                  prefixIcon: const Icon(Icons.date_range),
                                  label: 'MM/YY',
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(left: 30.0),
                                  child: Text(
                                    'CVV',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                MyTextField(
                                  controller: cvv,
                                  obscureText: true,
                                  prefixIcon: const Icon(Icons.security),
                                  label: 'CVV',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Padding(
                        padding: EdgeInsets.only(left: 30.0),
                        child: Text(
                          'Name on Card',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      MyTextField(
                        controller: name,
                        obscureText: false,
                        prefixIcon: const Icon(Icons.account_circle),
                        label: 'Full Name',
                      ),
                      const SizedBox(height: 40),
                      ElevatedButton(
                        onPressed: savePaymentCard,

                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 160, vertical: 17),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Save',
                          style: TextStyle(
                              fontSize: 18,
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
