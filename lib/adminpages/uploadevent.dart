import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class AddEventPage extends StatefulWidget {
  const AddEventPage({super.key});

  @override
  _AddEventPageState createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  final TextEditingController _clubNameController = TextEditingController();
  final TextEditingController _eventNameController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
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
            .child('events/${DateTime.now().millisecondsSinceEpoch}.jpg');
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
    String clubName = _clubNameController.text;
    String eventName = _eventNameController.text;
    final Timestamp now = Timestamp.now();

    if (clubName.isNotEmpty && eventName.isNotEmpty && _imageURL.isNotEmpty) {
      // Upload data to Firestore
      final QuerySnapshot qs2 = await FirebaseFirestore.instance
          .collection('clubs')
          .where('abbr', isEqualTo: clubName)
          .get();

      if (qs2.docs.isNotEmpty) {
        DocumentReference docRef =
            await FirebaseFirestore.instance.collection('events').add({
          'club': clubName,
          'event': eventName,
          'image': _imageURL,
          'date_added': now,
          'date_event': selectedDate,
          'likes': 0
        });
        String documentId = docRef.id;
        //print('document id of event: $documentId');
        final DocumentReference clubDocRef = qs2.docs.first.reference;

        await clubDocRef.update({
          'events': FieldValue.arrayUnion([documentId]),
        });

        // Clear input fields
        _clubNameController.clear();
        _eventNameController.clear();
        setState(() {
          _imageURL = '';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Event added successfully!')),
        );
      } else {
        print('entered club name invalid');
      }
    } else {
      // Show an error message if any field is empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please fill in all fields and select an image.')),
      );
    }
    setState(() {
      selectedDate = DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title:
              const Text('Add Event', style: TextStyle(color: Colors.black))),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _clubNameController,
              decoration: const InputDecoration(labelText: 'Club Name'),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _eventNameController,
              decoration: const InputDecoration(labelText: 'Event Name'),
            ),
            const SizedBox(height: 16.0),
            Text(
                'Event Date: ${DateFormat('yyyy-MM-dd').format(selectedDate)}'),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () => _selectDate(context),
              child: const Text('Pick Event Date'),
            ),
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
              child: const Text('Upload Event'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(home: AddEventPage()));
}
