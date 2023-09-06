import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';
import 'package:url_launcher/url_launcher.dart';

import 'attendance_page.dart';
import 'btmnavbar.dart';
import 'progress_page.dart';
import 'sidebar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  void _onItemTapped(int index) {}

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late User _user;
// Set the default URL
  final TextEditingController _degreeController = TextEditingController();
  final TextEditingController _facultyController = TextEditingController();
  final TextEditingController _intakeController = TextEditingController();
  final TextEditingController _umisController = TextEditingController();
  final TextEditingController _nicController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _offerController = TextEditingController();
  final TextEditingController _linkedinController = TextEditingController();
  final TextEditingController _githubController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  // ... add controllers for other fields

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser!;
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    DocumentSnapshot userData =
        await _firestore.collection('users').doc(_user.uid).get();
    setState(() {
      _degreeController.text = userData['Degree'];
      _facultyController.text = userData['Faculty'];
      _intakeController.text = userData['Intake'];
      _umisController.text = userData['UMIS_ID'];
      _nicController.text = userData['NIC'];
      _emailController.text = userData['personal_email'];
      _mobileController.text = userData['phone_number'];
      _offerController.text = userData['offered_by'];
      _linkedinController.text = userData['linkedin_link'];
      _githubController.text = userData['github_link'];
      _nameController.text = userData['display_name'];
      // ... set other text controllers
      _imageURL = userData['photo_url'];
    });
  }

  Future<void> _updateUserData() async {
    await _firestore.collection('users').doc(_user.uid).update({
      'Degree': _degreeController.text,
      'Faculty': _facultyController.text,
      'Intake': _intakeController.text,
      'photo_url': _imageURL,
      'UMIS_ID': _umisController.text,
      'NIC': _nicController.text,
      'personal_email': _emailController.text,
      'phone_number': _mobileController.text,
      'offered_by': _offerController.text,
      'linkedin_link': _linkedinController.text,
      'github_link': _githubController.text,
      'display_name': _nameController.text
      // ... update other fields
    });
    _showSuccessSnackbar('Profile Updated Successfully');
  }

  String _imageURL = '';

  Future<void> _uploadImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        File imageFile = File(pickedFile.path);

        // Convert the Image object to a File object
        //File compressedFile = await imageFile.compress(quality: 50);

        // Upload image to Firebase Storage
        final storageReference = FirebaseStorage.instance
            .ref()
            .child('profilepic/${DateTime.now().millisecondsSinceEpoch}.jpg');
        final uploadTask = storageReference.putFile(imageFile);
        await uploadTask.whenComplete(() => null);

        // Get the image URL
        String imageUrl = await storageReference.getDownloadURL();

        setState(() {
          _imageURL = imageUrl;
        });
      }
      _showSuccessSnackbar('Profile Picture Uploaded');
    } catch (error, stackTrace) {
      _showErrorSnackbar("Error Uploading image : $error");
      print(stackTrace);
    }
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      // Handle error
      _showErrorSnackbar('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text(
              'profile',
              style: TextStyle(color: primaryColor),
            ),
            titleSpacing: 1.0,
            automaticallyImplyLeading: true,
            backgroundColor: white,
            iconTheme: const IconThemeData(
              color: Colors.black, // Change the color of the leading icon here
            ),
            elevation: 0),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () => _launchURL(_linkedinController.text),
                      icon: const Icon(Ionicons.logo_linkedin),
                    ),
                    IconButton(
                      onPressed: () => _launchURL(_githubController.text),
                      icon: const Icon(
                        Ionicons.logo_github,
                      ),
                    ),
                  ],
                ),
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: NetworkImage(_imageURL),
                    ),
                    Positioned(
                      bottom: 0,
                      child: IconButton(
                        onPressed: _uploadImage,
                        icon: const Icon(Icons.add_a_photo),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  _nameController
                      .text, // Display the name fetched from Firestore
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        // Navigate to the About page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const ProfilePage()), // Replace AboutPage with your actual page
                        );
                      },
                      child: const Row(
                        children: [
                          Text('About             ',
                              style: TextStyle(
                                  color: Color.fromRGBO(88, 126, 255, 1),
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Navigate to the Progress page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const ProgressPage()), // Replace ProgressPage with your actual page
                        );
                      },
                      child: const Text(
                        'Progress',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Navigate to the Attendance page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const AttendancePage()), // Replace AttendancePage with your actual page
                        );
                      },
                      child: const Text('Attendance',
                          style: TextStyle(color: Colors.black)),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text('Academic Details'),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200], // Light gray background color
                      borderRadius:
                          BorderRadius.circular(10.0), // Border radius
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(children: [
                        TextFormField(
                          controller: _umisController,
                          style: const TextStyle(
                              fontSize: 12,
                              height:
                                  1), // Decrease font size and adjust line spacing
                          decoration:
                              const InputDecoration(labelText: 'UMIS ID'),
                        ),
                        TextFormField(
                          controller: _nicController,
                          style: const TextStyle(fontSize: 12, height: 1),
                          decoration: const InputDecoration(labelText: 'NIC'),
                        ),
                        TextFormField(
                          controller: _emailController,
                          style: const TextStyle(fontSize: 12, height: 1),
                          decoration:
                              const InputDecoration(labelText: 'Campus Email'),
                        ),
                        TextFormField(
                          controller: _mobileController,
                          style: const TextStyle(fontSize: 12, height: 1),
                          decoration:
                              const InputDecoration(labelText: 'Mobile Phone'),
                        ),
                        TextFormField(
                          controller: _facultyController,
                          style: const TextStyle(fontSize: 12, height: 1),
                          decoration:
                              const InputDecoration(labelText: 'Faculty'),
                        ),
                        TextFormField(
                          controller: _degreeController,
                          style: const TextStyle(fontSize: 12, height: 1),
                          decoration:
                              const InputDecoration(labelText: 'Degree'),
                        ),
                        TextFormField(
                          controller: _offerController,
                          style: const TextStyle(fontSize: 12, height: 1),
                          decoration:
                              const InputDecoration(labelText: 'Offered By'),
                        ),
                        TextFormField(
                          controller: _intakeController,
                          style: const TextStyle(fontSize: 12, height: 1),
                          decoration:
                              const InputDecoration(labelText: 'Intake'),
                        ),
                      ]),
                    ),
                  ),
                ),
                // ... add other text fields
                const SizedBox(height: 20),
                const Text('Social Details'),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200], // Light gray background color
                      borderRadius:
                          BorderRadius.circular(10.0), // Border radius
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _linkedinController,
                            style: const TextStyle(fontSize: 12, height: 1),
                            decoration: const InputDecoration(
                                labelText: 'Linkedin Profile'),
                          ),
                          TextFormField(
                            controller: _githubController,
                            style: const TextStyle(fontSize: 12, height: 1),
                            decoration: const InputDecoration(
                                labelText: 'Github Profile'),
                          ),
                          TextFormField(
                            controller: _nameController,
                            style: const TextStyle(fontSize: 12, height: 1),
                            decoration:
                                const InputDecoration(labelText: 'Your Name'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        await _updateUserData();
                        // Update the fields in your Firebase database
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(43, 166, 129, 1),
                      ),
                      child: const Text('Update'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BtmNavBar(
          currentIndex: 4,
          onItemSelected: _onItemTapped,
        ));
  }
}
