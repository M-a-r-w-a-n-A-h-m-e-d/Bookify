import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:my_doctor/Features/payment/save_payment.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoadSavedPayment extends StatefulWidget {
  const LoadSavedPayment({super.key});

  @override
  State<LoadSavedPayment> createState() => _LoadSavedPaymentState();
}

class _LoadSavedPaymentState extends State<LoadSavedPayment> {
  List<Map<String, String>> savedCards = [];

  Future<void> loadPayments() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? savedCardsList = prefs.getStringList('savedCards');

    if (savedCardsList != null && savedCardsList.isNotEmpty) {
      List<Map<String, String>> tempSavedCards = [];
      for (var cardJson in savedCardsList) {
        try {
          Map<String, String> card =
              Map<String, String>.from(jsonDecode(cardJson));
          tempSavedCards.add(card);
        } catch (e) {
          print("Error decoding card JSON: $e");
        }
      }
      setState(() {
        savedCards = tempSavedCards;
      });
    } else {
      print("No saved cards found.");
    }
  }

  @override
  void initState() {
    super.initState();
    loadPayments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const SavePayment(),
              ),
            );
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const Text('Saved Payment Methods'),
      ),
      body: savedCards.isNotEmpty
          ? ListView.builder(
              itemCount: savedCards.length,
              itemBuilder: (context, index) {
                final card = savedCards[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: ListTile(
                    title: Text('Name: ${card['name']}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Card Number: ${card['cardNumber']}'),
                        Text('Expiry Date: ${card['expiryDate']}'),
                        Text('CVV: ${card['cvv']}'),
                      ],
                    ),
                  ),
                );
              },
            )
          : const Center(child: Text('No Payment Methods Saved')),
    );
  }
}
