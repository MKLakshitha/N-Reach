import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../components/constants.dart';
import 'btmnavbar.dart';

class BatchGroup extends StatefulWidget {
  const BatchGroup({super.key});

  @override
  State<BatchGroup> createState() => _BatchGroupState();
}

class _BatchGroupState extends State<BatchGroup> {
  late String batch = ''; // Declare batch as an instance variable
  late String faculty = ''; // Declare faculty as an instance variable

  @override
  void initState() {
    super.initState();
    // Call a function to fetch batch and faculty details when the widget is initialized
    fetchUserData();
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
          batch =
              userDoc['Intake'] ?? ''; // Assign the batch value from Firestore
          faculty = userDoc['Faculty'] ??
              ''; // Assign the faculty value from Firestore

          // Update the widget with the fetched data
          setState(() {});
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  // Replace with actual faculty
  Future<String?> getLinkFromFirestore(String batch, String faculty) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('whatsappgroup')
          .where('batch', isEqualTo: batch)
          .where('faculty', isEqualTo: faculty)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final link = querySnapshot.docs[0]['link'] as String?;
        return link;
      } else {
        return null; // No matching document found
      }
    } catch (e) {
      print('Error retrieving data: $e');
      return null;
    }
  }

  FutureBuilder<String?> displaylink() {
    return FutureBuilder<String?>(
      future: getLinkFromFirestore(batch, faculty),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Display loading indicator
        } else if (snapshot.hasError || !snapshot.hasData) {
          return const Text('Error retrieving link'); // Display error message
        } else {
          final link = snapshot.data!;
          return Text(
            link, // Display the retrieved link
            style: const TextStyle(fontSize: 18),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'WhatsApp Group Link',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0), // Set the radius value
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
                    child: Text('Join $batch WhatsApp Group'),
                    onPressed: () async {
                      final linkSnapshot =
                          await getLinkFromFirestore(batch, faculty);
                      if (linkSnapshot != null) {
                        final whatsappLink = linkSnapshot;
                        if (await canLaunch(whatsappLink)) {
                          await launch(whatsappLink);
                        } else {
                          print('Could not launch $whatsappLink');
                        }
                      } else {
                        print('WhatsApp group link not found.');
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: mobileDeviceWidth * 0.02,
                ),
                const Text(
                  'If the above mentioned details are incorrect on your login, please contact the it support and fix the issue. You may not be able to join to your respective groups if the details are incorrect. ',
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 10),
                )
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
