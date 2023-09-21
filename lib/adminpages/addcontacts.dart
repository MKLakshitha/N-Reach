import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddContactScreen extends StatelessWidget {
  final TextEditingController typeController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController positionController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();

  AddContactScreen({super.key});
  void _bulkInsert() {
    final List<Map<String, dynamic>> contacts = [
      {
        'roomno': '105',
        'maxmem': '10',
        'status': '1',
        'type': 'room',
      },
      {
        'roomno': '106',
        'maxmem': '10',
        'status': '1',
        'type': 'room',
      },
      {
        'roomno': '107',
        'maxmem': '10',
        'status': '1',
        'type': 'room',
      },
      {
        'roomno': '108',
        'maxmem': '10',
        'status': '1',
        'type': 'room',
      },
      {
        'roomno': '109',
        'maxmem': '10',
        'status': '1',
        'type': 'room',
      },

      // Add more data entries as needed
    ];

    for (final contact in contacts) {
      FirebaseFirestore.instance.collection('library_rooms').add(contact);
    }
  }

  void _addContact() {
    final String type = typeController.text;
    final String name = nameController.text;
    final String position = positionController.text;
    final String email = emailController.text;
    final String mobile = mobileController.text;

    FirebaseFirestore.instance.collection('contacts').add({
      'type': type,
      'name': name,
      'position': position,
      'email': email,
      'mobile': mobile,
    });

    // Clear text fields after adding the contact
    typeController.clear();
    nameController.clear();
    positionController.clear();
    emailController.clear();
    mobileController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Contact',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: typeController,
              decoration:
                  const InputDecoration(labelText: 'Type (FOC,IT dept)'),
            ),
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextFormField(
              controller: positionController,
              decoration: const InputDecoration(labelText: 'Position'),
            ),
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextFormField(
              controller: mobileController,
              decoration: const InputDecoration(labelText: 'Mobile'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _addContact,
              child: const Text('Add Contact'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _bulkInsert,
              child: const Text('Add Bulk Data'),
            ),
          ],
        ),
      ),
    );
  }
}
