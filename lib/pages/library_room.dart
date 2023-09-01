import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'constants.dart';
import 'btmnavbar.dart';
import 'sidebar.dart';

class LibraryRoom extends StatefulWidget {
  const LibraryRoom({super.key});

  @override
  State<LibraryRoom> createState() => _LibraryRoomState();
}

class _LibraryRoomState extends State<LibraryRoom> {
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

  bool isOverlayOpen = false;

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
          BtmNavBar(currentIndex: 2, onItemSelected: _onItemSelected),
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
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Row(
                                children: [
                                  roomBlock(),
                                  roomBlock(),
                                  roomBlock(),
                                  roomBlock()
                                ],
                              ),
                            ),
                          ),
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
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: openOverlay,
                                    child: roomBlock(),
                                  ),
                                  roomBlock()
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
            room: '',
            members: ''),
      ]),
    );
  }

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

  Row roomBlock() {
    return Row(
      children: [
        Container(
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
                  const Text(
                    'Room 101\nL1-001\n5ppl',
                    textAlign: TextAlign.center,
                  ),
                  Container(
                    height: 12, // Rectangle at the bottom
                    color: Colors.green,
                  ),
                ])),
        SizedBox(
          width: mobileDeviceWidth * 0.02,
        ),
      ],
    );
  }

  _onItemSelected(int p1) {}
}

class SlidingOverlayContainer extends StatefulWidget {
  final bool isOpen;
  final VoidCallback onClose;
  final String room, members;

  const SlidingOverlayContainer(
      {super.key,
      required this.isOpen,
      required this.onClose,
      required this.room,
      required this.members});

  @override
  State<SlidingOverlayContainer> createState() =>
      _SlidingOverlayContainerState();
}

class _SlidingOverlayContainerState extends State<SlidingOverlayContainer> {
  @override
  Widget build(BuildContext context) {
    String room = widget.room;
    String members = widget.members;

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeInOut,
      bottom: widget.isOpen ? 0 : -400, // Change the value as needed
      left: 0,
      right: 0,
      height: mobileDeviceHeight * 0.28, // Change the height as needed
      child: Container(
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(50), topRight: Radius.circular(50)),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                offset: const Offset(0, -2),
                blurRadius: 15,
                spreadRadius: 4,
              )
            ]),
        padding: const EdgeInsets.only(left: 30, right: 30, top: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Room Details',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
                IconButton(
                    onPressed: widget.onClose, icon: const Icon(Icons.close))
              ],
            ),
            Text(
                "Room $room \nMaximum members: $members\nMaximum time: 3 hours\nStatus: Available"),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(
                            255, 43, 166, 129)), // Set your desired color
                  ),
                  onPressed: () {},
                  child: const Text("Book Now")),
            ),
          ],
        ),
      ),
    );
  }
}
