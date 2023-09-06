import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../components/constants.dart';
import 'btmnavbar.dart';
// Replace with your button color
// Replace with your preferred width

class TimetablePage extends StatefulWidget {
  const TimetablePage({super.key});

  @override
  State<TimetablePage> createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
  late String batch = ""; // Declare batch as an instance variable
  late String faculty = ""; // Declare faculty as an instance variable
  late String timetableUrl = ""; // Declare timetableUrl as an instance variable

  @override
  void initState() {
    super.initState();
    // Call a function to fetch batch, faculty, and timetable URL when the widget is initialized
    fetchUserDataAndTimetable();
  }

  Future<void> fetchUserDataAndTimetable() async {
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
          batch =
              userDoc['Intake'] ?? ''; // Assign the batch value from Firestore
          faculty = userDoc['Faculty'] ??
              ''; // Assign the faculty value from Firestore

          // Use the batch and faculty values to query the timetable collection
          final timetableQuerySnapshot = await FirebaseFirestore.instance
              .collection('timetable')
              .where('batch', isEqualTo: batch)
              .where('faculty', isEqualTo: faculty)
              .limit(1)
              .get();

          if (timetableQuerySnapshot.docs.isNotEmpty) {
            final timetableDoc = timetableQuerySnapshot.docs[0];
            timetableUrl = timetableDoc['timetable_link'] ??
                ''; // Assign the timetable URL from Firestore
          } else {
            timetableUrl = ''; // No matching timetable document found
          }

          // Update the widget with the fetched data
          setState(() {});
        }
      }
    } catch (e) {
      print('Error fetching user data or timetable: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Timetable Page',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: const Color.fromARGB(255, 220, 220, 220),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Batch:    $batch\nFaculty:  $faculty',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: mobileDeviceWidth * 0.02,
                ),
                Center(
                  child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: buttonColor),
                    child: const Text('View Semester Timetable'),
                    onPressed: () async {
                      if (timetableUrl.isNotEmpty) {
                        if (await canLaunch(timetableUrl)) {
                          await launch(timetableUrl);
                        } else {
                          print(
                              'Could not launch timetable URL: $timetableUrl');
                        }
                      } else {
                        print('Timetable URL not found.');
                      }
                    },
                  ),
                ),
                const Text(
                  // Additional text here if needed
                  'If you encounter any conflicts or issues with your schedule, please contact the NSBM IT Support as soon as possible for assistance.',
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 10),
                ),
              ],
            ),
          ),
        ]),
      ),
      bottomNavigationBar: BtmNavBar(
        currentIndex: 2,
        onItemSelected: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {}
}
