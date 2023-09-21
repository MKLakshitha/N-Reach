import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LibraryDashboard extends StatelessWidget {
  final TextEditingController typeController = TextEditingController();
  final TextEditingController roomnoController = TextEditingController();
  final TextEditingController maxmemController = TextEditingController();

  LibraryDashboard({super.key});
  void _bulkInsert() {
    final List<Map<String, dynamic>> Library = [
      {
        'roomno': '006',
        'maxmem': '25',
        'status': '1',
        'type': 'room',
      },
      {
        'roomno': '007',
        'maxmem': '25',
        'status': '1',
        'type': 'room',
      },
      {
        'roomno': '102',
        'maxmem': '15',
        'status': '1',
        'type': 'room',
      },
      {
        'roomno': '103',
        'maxmem': '15',
        'status': '1',
        'type': 'room',
      },
      {
        'roomno': '203',
        'maxmem': '20',
        'status': '1',
        'type': 'room',
      },

      // Add more data entries as needed
    ];

    for (final library in Library) {
      FirebaseFirestore.instance.collection('library_rooms').add(library);
    }
  }

  void _addLibrary() {
    final String roomno = roomnoController.text;
    final String maxmem = maxmemController.text;
    final String type = typeController.text;

    FirebaseFirestore.instance.collection('library_rooms').add({
      'roomno': roomno,
      'maxmem': maxmem,
      'status': '1',
      'type': type,
    });

    // Clear text fields after adding the Library
    typeController.clear();
    roomnoController.clear();
    maxmemController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Library Room Management',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Add New Library room',
                  style: TextStyle(fontSize: 16),
                ),
                TextFormField(
                  controller: typeController,
                  decoration: const InputDecoration(labelText: 'Type'),
                ),
                TextFormField(
                  controller: roomnoController,
                  decoration: const InputDecoration(labelText: 'Room no'),
                ),
                TextFormField(
                  controller: maxmemController,
                  decoration:
                      const InputDecoration(labelText: 'Maximum Members'),
                ),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: _addLibrary,
                      child: const Text('Add Library room'),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: _bulkInsert,
                      child: const Text('Add Bulk Data'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text('Rooms allocation', style: TextStyle(fontSize: 16)),
                SizedBox(height: double.maxFinite, child: method1())
              ],
            ),
          ),
        ));
  }
}

StreamBuilder<QuerySnapshot<Map<String, dynamic>>> method1() {
  return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
    stream: FirebaseFirestore.instance.collection('library_rooms').snapshots(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const CircularProgressIndicator(); // Show a loading indicator while data is loading.
      }

      if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      }

      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
        return const Text(
            'No rooms available.'); // Handle the case when there are no rooms.
      }

      final roomDocs = snapshot.data!.docs;

      return ListView.builder(
        itemCount: roomDocs.length,
        //scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final roomData = roomDocs[index].data();

          // Extract room details
          final roomNo = roomData['roomno'];
          final maxMem = roomData['maxmem'];
          final type = roomData['type'];
          final status = roomData['status'];
          final Status = status == '1'
              ? 'Room Available'
              : status == '2'
                  ? 'Pending approval'
                  : 'Room booked';
          return FutureBuilder<String>(
            future: getStudentId(roomNo),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Show a loading indicator while waiting for the result
                return const Padding(
                    padding: EdgeInsets.all(20),
                    child: CupertinoActivityIndicator());
              } else if (snapshot.hasError) {
                // Handle errors
                return Text('Error: ${snapshot.error}');
              } else {
                // Async operation completed successfully
                final id = snapshot.data;

                // Create a widget to display room details including id
                return ListTile(
                    title: Text('Room No: $roomNo'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Max Members: $maxMem'),
                        Text('Type: $type'),
                        Text(
                          'Status: $Status',
                          style: TextStyle(
                              color: status == '1'
                                  ? Colors.green
                                  : const Color.fromARGB(255, 185, 0,
                                      0) // Change color based on status
                              ),
                        ),
                        Visibility(
                            visible: status != '1',
                            child: Text('Student booked: $id'))
                      ],
                    ),
                    trailing: Column(
                      children: [
                        Visibility(
                            visible: status == '1',
                            child: ElevatedButton(
                                onPressed: () {
                                  allocateRoom(context, roomNo);
                                },
                                child: const Text('Allocate'))),
                        Visibility(
                            visible: status == '2',
                            child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<
                                          Color>(
                                      const Color.fromARGB(255, 255, 196, 0)),
                                ),
                                onPressed: () {
                                  approveRoom(roomNo, context);
                                },
                                child: const Text('approve'))),
                        Visibility(
                            visible: status == '3',
                            child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          const Color.fromARGB(255, 195, 0, 0)),
                                ),
                                onPressed: () {
                                  revokeRoom(roomNo, context);
                                },
                                child: const Text('Revoke'))),
                      ],
                    ));
              }
            },
          );
        },
      );
    },
  );
}

void revokeRoom(String roomno, BuildContext context) async {
  try {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('library_room_bookings')
        .where('roomno', isEqualTo: roomno)
        .get();
    for (QueryDocumentSnapshot document in querySnapshot.docs) {
      await document.reference.delete();
      print('Document deleted successfully: ${document.id}');
    }
    final QuerySnapshot querySnapshot2 = await FirebaseFirestore.instance
        .collection('library_rooms')
        .where('roomno', isEqualTo: roomno)
        .get();

    final DocumentSnapshot doc = querySnapshot2.docs.first;
    await doc.reference.update({'status': '1'});

    ScaffoldMessenger.of(context)
        .showSnackBar(snackbarSuccess("Succesfully revoked room"));
  } catch (e) {
    print(e);
  }
}

void approveRoom(String roomno, BuildContext context) async {
  try {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('library_room_bookings')
        .where('roomno', isEqualTo: roomno)
        .get();
    final QuerySnapshot querySnapshot2 = await FirebaseFirestore.instance
        .collection('library_rooms')
        .where('roomno', isEqualTo: roomno)
        .get();
    final DocumentSnapshot doc = querySnapshot2.docs.first;
    await doc.reference.update({'status': '3'});

    if (querySnapshot.docs.isNotEmpty) {
      final DocumentSnapshot doc = querySnapshot.docs.first;
      await doc.reference.update({'status': '3'});
      ScaffoldMessenger.of(context)
          .showSnackBar(snackbarError('Succesfully approved room.'));
    }
  } catch (e) {
    print(e);
  }
}

void allocateRoom(BuildContext context, String roomno) {
  String userInput = '';

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: const Padding(
          padding: EdgeInsets.all(2.0),
          child: Text('Enter student ID'),
        ),
        content: CupertinoTextField(
          placeholder: '',
          onChanged: (value) {
            userInput = value;
          },
        ),
        actions: <Widget>[
          CupertinoDialogAction(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          CupertinoDialogAction(
            child: const Text('Allocate'),
            onPressed: () async {
              print('User input: $userInput');
              try {
                final QuerySnapshot querySnapshot = await FirebaseFirestore
                    .instance
                    .collection('library_rooms')
                    .where('roomno', isEqualTo: roomno)
                    .get();

                final QuerySnapshot qs2 = await FirebaseFirestore.instance
                    .collection('library_room_bookings')
                    .where('student_booked', isEqualTo: userInput)
                    .get();

                if (qs2.docs.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      snackbarError("Already booking available $userInput"));
                } else {
                  FirebaseFirestore.instance
                      .collection('library_room_bookings')
                      .add({
                    'student_booked': userInput,
                    'roomno': roomno,
                    'status': '3',
                    'booked_time': ''
                  });
                  print('added lib_room_booking');
                  if (querySnapshot.docs.isNotEmpty) {
                    final DocumentSnapshot doc = querySnapshot.docs.first;
                    await doc.reference.update({'status': '3'});
                    print('added lib_room status = booked');
                  } else {
                    print('no data');
                  }

                  Navigator.of(context).pop(); // Close the dialog
                  ScaffoldMessenger.of(context).showSnackBar(snackbarSuccess(
                      "You have successfully booked for student $userInput"));
                }
              } catch (e) {
                print(e);
              }
            },
          ),
        ],
      );
    },
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

Future<String> getStudentId(String roomno) async {
  try {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('library_room_bookings')
        .where('roomno', isEqualTo: roomno)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      final DocumentSnapshot doc = querySnapshot.docs.first;

      final studentNumber = doc['student_booked'];
      //print(studentNumber);
      return studentNumber;
    } else {
      return "";
    }
  } catch (e) {
    print(e);
  }
  return "";
}
