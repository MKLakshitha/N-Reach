import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simple_flutter_app/constants/constants.dart';
import 'package:simple_flutter_app/pages/btmnavbar.dart';
import 'package:simple_flutter_app/pages/sidebar.dart';

class Medical extends StatefulWidget {
  const Medical({Key? key}) : super(key: key);

  @override
  State<Medical> createState() => _MedicalState();
}

class _MedicalState extends State<Medical> {
  int currentindex = 2;
  String studentid = '';
  // Date and time variables
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  // Text editing controller for medical history
  TextEditingController medicalHistoryController = TextEditingController();
  TextEditingController dateTimeController = TextEditingController();
  DateTime selectedtime = DateTime.now();

  void _onItemTapped(int index) {
    currentindex = index;
  }

  String? selectedMedicalReason;
  final List<String> medicalReasons = [
    'General checkup',
    'Common Fever and flu',
    'Cough and Sore throat',
    'Dental and oral',
    'Eye care',
    'Allergies',
    'Skin conditions',
    'Chronic conditions',
    'Pain and inflammation',
    'Mental health',
    'Infections',
    'Injuries',
    "Men's health",
    "Women's health",
    'Pregnancy and Prenatal Care',
    'Other'
  ];

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Medical Appointment',
          style: TextStyle(color: primaryColor),
        ),
        titleSpacing: 1.0,
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              'assets/lib.jpeg',
              height: height * 0.25,
              width: width,
              fit: BoxFit.cover,
            ),
            Container(
              padding: EdgeInsets.all(width * 0.04),
              child: Column(
                children: [
                  const Text(
                    'NSBM Medical Centre',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: width * 0.01,
                  ),
                  const Text(
                    'NSBM provides free medical services to students and staffs\nBook your appointment and consult our doctor.\nWorking hours : 9.00 a.m - 5.00 p.m',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12),
                  ),
                  SizedBox(
                    height: width * 0.01,
                  ),
                  const Divider(
                    color: Colors.black, // Specify the color of the line
                    thickness: 1.0, // Specify the thickness of the line
                    indent: 70.0, // Specify the start indentation of the line
                    endIndent: 70.0, // Specify the end indentation of the line
                  ),
                  SizedBox(
                    height: width * 0.06,
                  ),
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Book an appointment',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: width * 0.01,
                  ),
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Fill out the details below and select the book now option to book an appointment',
                      style: TextStyle(fontSize: 12),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  SizedBox(
                    height: width * 0.03,
                  ),
                  Container(
                    padding: EdgeInsets.only(
                        left: width * 0.05,
                        right: width * 0.05,
                        bottom: width * 0.05),
                    width: width,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 243, 243, 243),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        DropdownButtonFormField<String>(
                          value: selectedMedicalReason,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedMedicalReason = newValue;
                            });
                          },
                          items: medicalReasons.map((String reason) {
                            return DropdownMenuItem<String>(
                              value: reason,
                              child: Text(reason),
                            );
                          }).toList(),
                          decoration: const InputDecoration(
                            labelText: 'Medical illness/reason:',
                            labelStyle: TextStyle(fontSize: 14),
                            contentPadding: EdgeInsets.all(0),
                          ),
                        ),
                        TextFormField(
                          controller: dateTimeController,
                          decoration: const InputDecoration(
                            labelText: 'Select Date and Time',
                            labelStyle: TextStyle(fontSize: 14),
                          ),
                          readOnly: true, // Make the input field read-only
                          onTap: () {
                            _selectDateAndTime(context);
                          },
                        ),
                        TextFormField(
                          controller: medicalHistoryController,
                          decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(0),
                              labelText: 'Any other medical notes',
                              labelStyle: TextStyle(fontSize: 14)),
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        const Text(
                          'Note - You will be contacted by the medical centre for the available time slot and confirmation of the appointment.',
                          textAlign: TextAlign.justify,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _bookappointment();
          medicalHistoryController.clear();
          dateTimeController.clear();
        },
        icon: const Icon(Icons.add_circle_outline_sharp),
        label: const Text(
          'Book Now',
          style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'DM Sans'),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        backgroundColor: buttonColor,
      ),
      bottomNavigationBar: BtmNavBar(
        currentIndex: currentindex,
        onItemSelected: _onItemTapped,
      ),
    );
  }

  Future<void> _selectDateAndTime(context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: selectedTime,
      );

      if (pickedTime != null) {
        setState(() {
          selectedDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );

          // Format the selected date and time as desired (e.g., 'yyyy-MM-dd hh:mm a')
          String formattedDateTime =
              DateFormat('yyyy-MM-dd hh:mm a').format(selectedDate);
          selectedtime = selectedDate;
          dateTimeController.text = formattedDateTime;
        });
      }
    }
  }

  Future<void> fetchUserData() async {
    try {
      // Get the current user's UID from Firebase Auth
      final User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Use the UID to query the Firestore collection for user details
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        // Check if the document exists and contains the batch and faculty fields
        if (userDoc.exists) {
          studentid = userDoc['UMIS_ID'] ?? '';
          setState(() {});
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  void _bookappointment() {
    if (selectedMedicalReason == null || selectedtime == DateTime.now()) {
      print('no data');
    } else {
      if (FirebaseAuth.instance.currentUser != null) {
        // Create a reference to the "appointments" collection
        final appointmentCollection =
            FirebaseFirestore.instance.collection('medical_appointments');
        fetchUserData();
        // Prepare the data to be added
        final appointmentData = {
          'userId': studentid, // Store the user's ID for reference
          'medicalReason': selectedMedicalReason,
          'selectedTime': selectedtime,
          'medicalNotes': medicalHistoryController.text,
        };

        // Add the appointment data to the collection
        appointmentCollection.add(appointmentData).then((appointmentDoc) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Appointment booked successfully!'),
              duration: Duration(seconds: 3), // Adjust the duration as needed
            ),
          );
          // You can add any further actions or navigation here if needed.
        }).catchError((error) {
          print('Error adding appointment: $error');
        });
      }
    }
  }
}
