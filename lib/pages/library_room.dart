import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simple_flutter_app/constants/constants.dart';
import 'package:simple_flutter_app/pages/btmnavbar.dart';
import 'package:simple_flutter_app/pages/sidebar.dart';

class LibraryRoom extends StatefulWidget {
  const LibraryRoom({super.key});
  static String user = '23926'; //change user name here : using provider

  @override
  State<LibraryRoom> createState() => _LibraryRoomState();
}

class _LibraryRoomState extends State<LibraryRoom> {
  bool isOverlayOpen = false;
  String roomno = '999';
  String members = '99';
  String status = 'available';

  String getFormattedDate() {
    DateTime now = DateTime.now();
    DateTime next = DateTime.now().add(const Duration(days: 1));
    DateTime fivePm = DateTime(now.year, now.month, now.day, 17, 0);

    // Compare the current time with 5 PM
    if (now.isBefore(fivePm)) {
      String formattedDate = DateFormat('dd/MM/yy').format(now);
      return formattedDate; // Today's date
    } else {
      String formattedDate = DateFormat('dd/MM/yy').format(next);
      return formattedDate; // Tomorrow's date
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Study Room Booking & Guidelines'),
            content: const Text(
              'Students can book group study rooms for upto 4 hours.\nAll student IDs should be kept at the counter.\nStudy rooms are only for groups study not for individuals.\nLibrary staff reserves the right to cancel or re-allocate a booking',
              style: TextStyle(fontSize: 14),
              textAlign: TextAlign.justify,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    });
  }

  void openOverlay() {
    setState(() {
      isOverlayOpen = true;
    });
  }

  void closeOverlay() {
    setState(() {
      isOverlayOpen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Library Room Booking',
          style: TextStyle(color: Colors.black),
        ),
        titleSpacing: 1.0,
        automaticallyImplyLeading: true,
      ),
      bottomNavigationBar:
          BtmNavBar(currentIndex: 2, onItemSelected: (index) {}),
      body: Stack(children: [
        SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(
                'assets/lib.jpeg',
                height: mobileDeviceHeight * 0.25,
                width: mobileDeviceWidth,
                fit: BoxFit.cover,
              ),
              Container(
                padding: EdgeInsets.all(mobileDeviceWidth * 0.04),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Rooms available as at ${getFormattedDate()}',
                        textAlign: TextAlign.left,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: mobileDeviceWidth * 0.01,
                    ),
                    const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        '**Students are required to physically confirm the bookings before 10.a.m by providing their ID cards to the librarian. ',
                        style: TextStyle(fontSize: 12),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    const Divider(
                      color: Colors.black, // Specify the color of the line
                      thickness: 1.0, // Specify the thickness of the line
                      indent: 70.0, // Specify the start indentation of the line
                      endIndent:
                          70.0, // Specify the end indentation of the line
                    ),
                    SizedBox(
                      height: mobileDeviceWidth * 0.02,
                    ),
                    availability(),
                    SizedBox(
                      height: mobileDeviceWidth * 0.02,
                    ),
                    Container(
                      padding: EdgeInsets.all(
                        mobileDeviceWidth * 0.03,
                      ),
                      width: mobileDeviceWidth,
                      height: 150,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 244, 244, 244),
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color:
                                Colors.black.withOpacity(0.25), // Shadow color
                            spreadRadius: -2, // Spread radius
                            blurRadius: 10, // Blur radius
                            offset: const Offset(
                                0, 1), // Offset in x and y direction
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Private Rooms 5-10 members',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: mobileDeviceHeight * 0.01,
                          ),
                          Expanded(
                            child: StreamBuilder<
                                    QuerySnapshot<Map<String, dynamic>>>(
                                stream: FirebaseFirestore.instance
                                    .collection('library_rooms')
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return const CircularProgressIndicator(); // Show a loading indicator while data is loading.
                                  }

                                  final roomDocs = snapshot.data!.docs;

                                  return ListView.builder(
                                    padding: const EdgeInsets.all(2),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: roomDocs.length,
                                    itemBuilder: (context, index) {
                                      final roomData = roomDocs[index].data();

                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            roomno = roomData['roomno'];
                                            members = roomData['maxmem'];
                                            status = roomData['status'];
                                          });
                                          openOverlay();
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              right: mobileDeviceWidth * 0.015,
                                              top: mobileDeviceWidth * 0.02,
                                              bottom: mobileDeviceWidth * 0.02),
                                          child: roomBlock(
                                              roomData['roomno'],
                                              roomData['maxmem'],
                                              roomData['status']),
                                        ),
                                      );
                                    },
                                  );
                                }),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: mobileDeviceHeight * 0.02,
                    ),
                    Container(
                      padding: EdgeInsets.all(
                        mobileDeviceWidth * 0.03,
                      ),
                      width: mobileDeviceWidth,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 244, 244, 244),
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color:
                                Colors.black.withOpacity(0.25), // Shadow color
                            spreadRadius: -2, // Spread radius
                            blurRadius: 10, // Blur radius
                            offset: const Offset(
                                0, 1), // Offset in x and y direction
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Conference Rooms',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: mobileDeviceHeight * 0.01,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title:
                                                const Text('Conference Rooms'),
                                            content: const Text(
                                              'Conference Rooms can only be booked at the information and circulation counter at the ground floor of the library. ',
                                              textAlign: TextAlign.justify,
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('OK'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: roomBlock('Conf..', '30', '1'),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title:
                                                const Text('Conference Rooms'),
                                            content: const Text(
                                              'Conference Rooms can only be booked at the information and circulation counter at the ground floor of the library. ',
                                              textAlign: TextAlign.justify,
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('OK'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: roomBlock('Conf..', '35', '1'),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title:
                                                const Text('Conference Rooms'),
                                            content: const Text(
                                              'Conference Rooms can only be booked at the information and circulation counter at the ground floor of the library. ',
                                              textAlign: TextAlign.justify,
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('OK'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: roomBlock('Conf..', '40', '1'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SlidingOverlayContainer(
          isOpen: isOverlayOpen,
          onClose: closeOverlay,
          room: roomno,
          members: members,
          status: status,
        ),
      ]),
    );
  }

//color description of available rooms
  Row availability() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          color: Colors.green,
          width: mobileDeviceWidth * 0.03,
          height: 10,
        ),
        SizedBox(
          width: mobileDeviceWidth * 0.01,
        ),
        const Text('Available'),
        SizedBox(
          width: mobileDeviceWidth * 0.03,
        ),
        Container(
          color: Colors.yellow,
          width: mobileDeviceWidth * 0.03,
          height: 10,
        ),
        SizedBox(
          width: mobileDeviceWidth * 0.01,
        ),
        const Text('Pending booking'),
        SizedBox(
          width: mobileDeviceWidth * 0.03,
        ),
        Container(
          color: Colors.red,
          width: mobileDeviceWidth * 0.03,
          height: 10,
        ),
        SizedBox(
          width: mobileDeviceWidth * 0.01,
        ),
        const Text('Booked'),
      ],
    );
  }

  Container roomBlock(String no, String mem, String status) {
    return Container(
        width: mobileDeviceWidth * 0.2,
        //alignment: Alignment.bottomCenter,
        height: mobileDeviceWidth * 0.2,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                offset: const Offset(0, 2),
                blurRadius: 5,
                spreadRadius: -2,
              )
            ]),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Room \n$no\n$mem ppl',
                textAlign: TextAlign.center,
              ),
              Container(
                height: 12, // Rectangle at the bottom
                color: status == "1"
                    ? Colors.green
                    : status == "2"
                        ? Colors.yellow
                        : Colors.red,
              ),
            ]));
  }

  _onItemSelected(int p1) {}
}

class SlidingOverlayContainer extends StatefulWidget {
  final bool isOpen;
  final VoidCallback onClose;
  final String room, members, status;

  const SlidingOverlayContainer(
      {super.key,
      required this.isOpen,
      required this.onClose,
      required this.room,
      required this.members,
      required this.status});

  @override
  State<SlidingOverlayContainer> createState() =>
      _SlidingOverlayContainerState();
}

class _SlidingOverlayContainerState extends State<SlidingOverlayContainer> {
  @override
  Widget build(BuildContext context) {
    String room = widget.room;
    String members = widget.members;
    String status = widget.status == '1'
        ? "Available"
        : widget.status == "2"
            ? "Approval Pending"
            : "Occupied";

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeInOut,
      bottom: widget.isOpen ? 0 : -mobileDeviceHeight,
      left: 0,
      right: 0,
      height: mobileDeviceHeight * 0.25,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30)),
            color: const Color.fromARGB(255, 243, 243, 243),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                offset: const Offset(0, -2),
                blurRadius: 15,
                spreadRadius: 4,
              )
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 30, right: 30, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Room details',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                      onPressed: widget.onClose,
                      icon: const Icon(Icons.arrow_drop_down_circle))
                ],
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Room: $room \nMin students: 3    Max students: $members\nMaximum time: 4 hours\nStatus: $status",
                    style: const TextStyle(fontSize: 16),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: mobileDeviceWidth,
                        child: Visibility(
                          visible: widget.status == '1',
                          child: ElevatedButton(
                              onPressed: () {
                                bookRoom();
                              },
                              child: const Text('Book now')),
                        ),
                      ),
                      Visibility(
                          visible: widget.status == '2',
                          child: const Text(
                            '\nApproval pending for room. If student does not register in given time, this room will be available.',
                            style: TextStyle(
                                color: Color.fromARGB(255, 236, 213, 3),
                                fontSize: 13),
                            textAlign: TextAlign.center,
                          )),
                      Visibility(
                          visible: widget.status == '3',
                          child: const Text(
                            '\nRoom occupied, please wait till the librarian revokes the room.',
                            style: TextStyle(color: Colors.red, fontSize: 13),
                            textAlign: TextAlign.center,
                          )),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //booking table create when student selects available booking
  Future<void> bookRoom() async {
    try {
      FirebaseFirestore.instance.collection('library_room_bookings').add({
        'student_booked': LibraryRoom.user,
        'roomno': widget.room,
        'status': '2',
        'booked_time': ''
      });

      final roomCollection =
          FirebaseFirestore.instance.collection('library_rooms');
      final roomDoc =
          await roomCollection.where('roomno', isEqualTo: widget.room).get();
      if (roomDoc.docs.isNotEmpty) {
        // Assuming there is only one document with the matching room number
        final docId = roomDoc.docs[0].id;
        await roomCollection.doc(docId).update({
          'status': '2',
        });

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'You have booked the room, please secure the room by providing the student ID card at the counter. ',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ));
      }
    } catch (e) {
      print('error');
    }
  }

  //
}
