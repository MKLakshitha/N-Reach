import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AnnouncementPage extends StatefulWidget {
  const AnnouncementPage({super.key});

  @override
  _AnnouncementPageState createState() => _AnnouncementPageState();
}

class _AnnouncementPageState extends State<AnnouncementPage> {
  final TextEditingController _announcementController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();
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
        final storageReference = FirebaseStorage.instance.ref().child(
            'announcements/${DateTime.now().millisecondsSinceEpoch}.jpg');
        final uploadTask = storageReference.putFile(imageFile);
        await uploadTask.whenComplete(() => null);

        // Get the image URL
        String imageUrl = await storageReference.getDownloadURL();

        setState(() {
          _imageURL = imageUrl;
        });
      }
    } catch (error, stackTrace) {
      print("Error Uploading image : $error");
      print(stackTrace);
    }
  }

  void _uploadEvent() async {
    String announcement = _announcementController.text;
    String details = _detailsController.text;

    if (announcement.isNotEmpty && _imageURL.isNotEmpty) {
      // Upload data to Firestore
      await FirebaseFirestore.instance.collection('announcements').add({
        'title': announcement,
        'details': details,
        'date': Timestamp.fromDate(DateTime.now()),
        'imageurl': _imageURL,
      });

      // Clear input fields
      _announcementController.clear();
      _detailsController.clear();
      setState(() {
        _imageURL = '';
      });

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Announcement added successfully!')),
      );
    } else {
      // Show an error message if any field is empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please fill in all fields and select an image.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Event')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _announcementController,
              decoration: const InputDecoration(labelText: 'announcement Name'),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _detailsController,
              decoration: const InputDecoration(labelText: 'Details: '),
            ),
            const SizedBox(height: 16.0),
            SizedBox(
              height: 150.0,
              child: _imageURL.isNotEmpty
                  ? Image.network(_imageURL, fit: BoxFit.cover)
                  : Container(),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _uploadImage,
              child: const Text('Select Image'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _uploadEvent,
              child: const Text('Upload announcement'),
            ),
          ],
        ),
      ),
    );
  }
}
