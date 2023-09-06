import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../components/constants.dart';
import 'bookdonate.dart';
import 'btmnavbar.dart';
import 'burrowedbooks.dart';
import 'library_room.dart';
import 'sidebar.dart';

class Library extends StatefulWidget {
  const Library({super.key});

  @override
  State<Library> createState() => _LibraryState();
}

class _LibraryState extends State<Library> {
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
          'Library Services',
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
                    const Text(
                      "Student's Library",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    SizedBox(
                      height: mobileDeviceWidth * 0.01,
                    ),
                    const Text(
                      "With a wide range of resources freely available for every students NSBM's Student's Library is open during the morining hours.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12),
                    ),
                    SizedBox(
                      height: mobileDeviceWidth * 0.01,
                    ),
                    const Divider(
                      color: Colors.black, // Specify the color of the line
                      thickness: 1.0, // Specify the thickness of the line
                      indent: 70.0, // Specify the start indentation of the line
                      endIndent:
                          70.0, // Specify the end indentation of the line
                    ),
                    SizedBox(
                      height: mobileDeviceWidth * 0.03,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const BorrowedBooksPage()));
                          },
                          child: Container(
                            padding: EdgeInsets.all(
                              mobileDeviceWidth * 0.03,
                            ),
                            width: mobileDeviceWidth * 0.4,
                            height: mobileDeviceWidth * 0.3,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: const AssetImage('assets/card2.png'),
                                fit: BoxFit.cover,
                                colorFilter: ColorFilter.mode(
                                    Colors.black.withOpacity(0.2),
                                    BlendMode.darken),
                              ),
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black
                                      .withOpacity(0.25), // Shadow color
                                  spreadRadius: -2, // Spread radius
                                  blurRadius: 10, // Blur radius
                                  offset: const Offset(
                                      0, 1), // Offset in x and y direction
                                ),
                              ],
                            ),
                            child: const Text('My Burrowed Books',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20)),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LibraryRoom()),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.all(
                              mobileDeviceWidth * 0.03,
                            ),
                            width: mobileDeviceWidth * 0.4,
                            height: mobileDeviceWidth * 0.3,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: const AssetImage('assets/card1.png'),
                                fit: BoxFit.cover,
                                colorFilter: ColorFilter.mode(
                                    Colors.black.withOpacity(0.2),
                                    BlendMode.darken),
                              ),
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black
                                      .withOpacity(0.25), // Shadow color
                                  spreadRadius: -2, // Spread radius
                                  blurRadius: 10, // Blur radius
                                  offset: const Offset(
                                      0, 1), // Offset in x and y direction
                                ),
                              ],
                            ),
                            child: const Text(
                              'Reserve a Study Room',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const BookDonationPage()),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(
                          mobileDeviceWidth * 0.03,
                        ),
                        width: mobileDeviceWidth * 0.85,
                        height: mobileDeviceWidth * 0.3,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: const AssetImage('assets/card3.png'),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(0.2),
                                BlendMode.darken),
                          ),
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black
                                  .withOpacity(0.25), // Shadow color
                              spreadRadius: -2, // Spread radius
                              blurRadius: 10, // Blur radius
                              offset: const Offset(
                                  0, 1), // Offset in x and y direction
                            ),
                          ],
                        ),
                        child: const Text(
                          'Donate Books',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: white,
                              fontWeight: FontWeight.w600,
                              fontSize: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }

  _onItemSelected(int p1) {}
}
