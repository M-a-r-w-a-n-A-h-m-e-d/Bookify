import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_doctor/Features/doctors/doctor_card.dart';
import '../models/doctor_model.dart';

class Api extends StatefulWidget {
  const Api({super.key});

  @override
  State<Api> createState() => _ApiState();
}

class _ApiState extends State<Api> {
  late CollectionReference _doctorCollection;
  List<Doctor> doctorsList = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _doctorCollection = FirebaseFirestore.instance.collection('doctors');
    _fetchDoctorsData();
  }

  Future<void> _fetchDoctorsData() async {
    try {
      QuerySnapshot snapshot = await _doctorCollection.get();
      print('Fetched snapshot: ${snapshot.docs.length} documents');

      if (snapshot.docs.isNotEmpty) {
        setState(() {
          print('1');
          doctorsList = snapshot.docs.map((doc) {
            print('Document ID: ${doc.id}');
            print('Document Data: ${doc.data()}');
            return Doctor.fromJson(doc.data() as Map<String, dynamic>);
          }).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          errorMessage = "No doctors found in the database.";
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = "Failed to fetch data. Please try again later.";
      });
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Doctors List'),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : doctorsList.isEmpty
              ? Center(child: Text(errorMessage))
              : ListView.builder(
                  itemCount: doctorsList.length,
                  itemBuilder: (context, index) {
                    return DoctorCard(doctor: doctorsList[index]);
                  },
                ),
    );
  }
}
