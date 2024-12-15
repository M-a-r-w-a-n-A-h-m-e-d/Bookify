import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AddDoctorPage extends StatefulWidget {
  @override
  _AddDoctorPageState createState() => _AddDoctorPageState();
}

class _AddDoctorPageState extends State<AddDoctorPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController specialtyController = TextEditingController();
  TextEditingController experienceController = TextEditingController();
  TextEditingController starsController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController paymentController = TextEditingController();
  TextEditingController imageController = TextEditingController();

  TextEditingController dayController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  List<Map<String, String>> availableTime = [];

  final databaseReference = FirebaseDatabase.instance.ref();

  Future<String> _getDoctorId() async {
    DataSnapshot snapshot = await databaseReference.child('doctors').get();
    if (snapshot.exists) {
      Map data = snapshot.value as Map;
      int doctorCount = data.length;
      return 'doctor${doctorCount + 1}';
    } else {
      return 'doctor1';
    }
  }

  void _addDoctor() async {
    if (_formKey.currentState?.validate() ?? false) {
      String doctorId = await _getDoctorId();

      Map<String, dynamic> doctorData = {
        'id': doctorId,
        'name': nameController.text,
        'specialty': specialtyController.text,
        'experience': experienceController.text,
        'stars': starsController.text,
        'description': descriptionController.text,
        'payment': paymentController.text,
        'image': imageController.text,
        'availableTime': availableTime,
      };

      databaseReference
          .child('doctors')
          .child(doctorId)
          .set(doctorData)
          .then((_) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Doctor added successfully")));

        nameController.clear();
        specialtyController.clear();
        experienceController.clear();
        starsController.clear();
        descriptionController.clear();
        paymentController.clear();
        imageController.clear();
        dayController.clear();
        timeController.clear();
        setState(() {
          availableTime.clear();
        });
      }).catchError((error) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Failed to add doctor")));
      });
    }
  }

  void _addAvailableTime() {
    if (dayController.text.isNotEmpty && timeController.text.isNotEmpty) {
      setState(() {
        availableTime
            .add({'day': dayController.text, 'time': timeController.text});
      });
      dayController.clear();
      timeController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Doctor"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Doctor Name'),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter the doctor\'s name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: specialtyController,
                  decoration: InputDecoration(labelText: 'Specialty'),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter the specialty';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: experienceController,
                  decoration: InputDecoration(labelText: 'Years of Experience'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter experience';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: starsController,
                  decoration: InputDecoration(labelText: 'Stars Rating'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter the stars rating';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: paymentController,
                  decoration: InputDecoration(labelText: 'Payment'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter the payment';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: imageController,
                  decoration: InputDecoration(labelText: 'Image URL'),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter the image URL';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                Text(
                  "Available Time",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: dayController,
                        decoration: InputDecoration(labelText: 'Day'),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: timeController,
                        decoration: InputDecoration(labelText: 'Time'),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: _addAvailableTime,
                    ),
                  ],
                ),
                Column(
                  children: availableTime.map((timeSlot) {
                    return ListTile(
                      title: Text("${timeSlot['day']} - ${timeSlot['time']}"),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            availableTime.remove(timeSlot);
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _addDoctor,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 100, vertical: 17),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: const Size(double.infinity, 50),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: Text(
                    'Add Doctor',
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
    );
  }
}
