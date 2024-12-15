import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:my_doctor/Features/doctors/doctor_card.dart';
import 'package:my_doctor/Features/home/navigationbar.dart';
import '../../core/models/doctor_model.dart';

class AllDoctors extends StatefulWidget {
  const AllDoctors({super.key});

  @override
  State<AllDoctors> createState() => _AllDoctorsState();
}

class _AllDoctorsState extends State<AllDoctors> {
  late DatabaseReference _databaseReference;
  List<Doctor> doctors = [];

  @override
  void initState() {
    super.initState();
    _databaseReference = FirebaseDatabase.instance.ref().child('doctors');
    _fetchDoctorsData();
  }

  Future<void> _fetchDoctorsData() async {
    DataSnapshot snapshot = await _databaseReference.get();

    if (snapshot.exists) {
      Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;

      setState(() {
        doctors = data.values.map((doctorData) {
          return Doctor.fromJson(Map<String, dynamic>.from(doctorData));
        }).toList();

        doctors.sort((a, b) {
          double starsA = double.tryParse(a.stars) ?? 0;
          double starsB = double.tryParse(b.stars) ?? 0;
          return starsB.compareTo(starsA);
        });
      });
    } else {
      print('No doctors found.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
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
        ),
        title: Text(
          'All Doctors',
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        centerTitle: true,
      ),
      body: doctors.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: doctors.length,
              itemBuilder: (context, index) {
                return DoctorCard(doctor: doctors[index]);
              },
            ),
    );
  }
}
