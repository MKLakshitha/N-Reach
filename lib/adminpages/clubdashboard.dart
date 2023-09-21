import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:simple_flutter_app/constants/constants.dart';

class CreateClubs extends StatelessWidget {
  CreateClubs({super.key});
  final TextEditingController _clubnameController = TextEditingController();
  final TextEditingController _clubpassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
        'Create Clubs',
        style: blackText,
      )),
      body: ListView(
        children: <Widget>[
          ExpansionTile(
            title: const Text('Create new club'),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  color: const Color.fromARGB(255, 239, 239, 239),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Enter club Name and assign a password'),
                      TextFormField(
                        controller: _clubnameController,
                        decoration: const InputDecoration(
                            labelText: 'Name (abbreviated) without spaces'),
                      ),
                      const Text(
                        'This will be the username followed by @clubs.nsbm.ac.lk, i.e. Marketing@clubs.nsbm.ac.lk and be used as name everywhere in the app',
                        style: TextStyle(fontSize: 12),
                        textAlign: TextAlign.justify,
                      ),
                      TextFormField(
                        controller: _clubpassController,
                        decoration:
                            const InputDecoration(labelText: 'Assign password'),
                      ),
                      ElevatedButton(
                          onPressed: () {
                            createClub(_clubnameController.text,
                                _clubpassController.text, context);
                          },
                          child: const Text('Create club'))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      /**/
    );
  }

  StreamBuilder<QuerySnapshot<Map<String, dynamic>>> editClubs() {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance.collection('clubs').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Show a loading indicator while data is loading.
        }
        if (snapshot.hasError) {
          print('Error: ${snapshot.error}');
          return const Text('Please try again later');
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Text('No clubs available, please try again later');
        }

        final clubDocs = snapshot.data!.docs;

        return ListView.builder(
          itemCount: clubDocs.length,
          //scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            final clubData = clubDocs[index].data();

            // Extract club details
            final clubAbbr = clubData['abbr'];
            final clubName = clubData['Name'];

            return ListTile(
                title:
                    clubName == null ? const Text('no name') : Text(clubName),
                subtitle: Text('($clubAbbr)'), //can use column
                trailing: Column(
                  children: [
                    ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color.fromARGB(255, 179, 0, 0)),
                        ),
                        onPressed: () {
                          deleteClubs(clubAbbr, context);
                        },
                        child: const Text('delete')),
                  ],
                ));
          },
        );
      },
    );
  }

  void createClub(String clubname, String pass, BuildContext context) async {
    if (clubname.isNotEmpty && pass.isNotEmpty) {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('clubs')
          .where('abbr', isEqualTo: clubname)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        ScaffoldMessenger.of(context)
            .showSnackBar(snackbarError('Club already registered.'));
      } else {
        try {
          String mail = clubname.replaceAll(' ', '').toLowerCase();
          FirebaseFirestore.instance.collection('clubs').add({
            'abbr': clubname,
            'mail': '$mail@clubs.nsbm.ac.lk',
            'pass': md5.convert(utf8.encode(pass)).toString()
          });
          _clubnameController.clear();
          _clubpassController.clear();
          ScaffoldMessenger.of(context).showSnackBar(snackbarSuccess(
              'Club registered successfully. Use $mail@clubs.nsbm.ac.lk for login'));
        } catch (e) {
          print(e);
        }
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(snackbarError('Please fill in all fields'));
    }
  }
}

SnackBar snackbarError(String userInput) {
  return SnackBar(
    content: Row(
      children: [
        const Icon(Icons.info, color: Colors.white),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            userInput,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    ),
    backgroundColor: const Color.fromARGB(255, 205, 0, 0),
    duration: const Duration(seconds: 3),
  );
}

SnackBar snackbarSuccess(String userInput) {
  return SnackBar(
    content: Row(
      children: [
        const Icon(Icons.check_circle, color: Colors.white),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            userInput,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    ),
    backgroundColor: Colors.green,
    duration: const Duration(seconds: 3),
  );
}

void deleteClubs(String clubname, BuildContext context) async {
  final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('clubs')
      .where('abbr', isEqualTo: clubname)
      .get();

  // ignore: use_build_context_synchronously
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog.adaptive(
          title: const Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete the club $clubname'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () async {
                for (QueryDocumentSnapshot document in querySnapshot.docs) {
                  await document.reference.delete();
                  ScaffoldMessenger.of(context).showSnackBar(
                      snackbarSuccess('Successfully deleted club $clubname'));
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      });
}
