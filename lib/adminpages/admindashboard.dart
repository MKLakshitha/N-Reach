import 'package:flutter/material.dart';
import 'package:simple_flutter_app/adminpages/addLibraryroom.dart';
import 'package:simple_flutter_app/adminpages/addcontacts.dart';
import 'package:simple_flutter_app/adminpages/announcementadd.dart';
import 'package:simple_flutter_app/adminpages/clubdashboard.dart';
import 'package:simple_flutter_app/adminpages/uploadevent.dart';
import 'package:simple_flutter_app/constants/constants.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final user = "Praveen Dev";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog.adaptive(
            title: Text('Welcome $user'),
            content: const Text(
              'As an admin, you have several privileges over the content available across NReach. Check manual for more details.',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Admin Dashboard',
          style: blackText,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddContactScreen()));
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.people_alt),
                      Text(' Add important Contacts'),
                    ],
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AnnouncementPage()));
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.add_alarm_sharp),
                      Text(' Add announcements'),
                    ],
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AddEventPage()));
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.add_alarm_sharp),
                      Text(' Add Club events'),
                    ],
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LibraryDashboard()));
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.menu_book_sharp),
                      Text(' Library management'),
                    ],
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => CreateClubs()));
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.add_reaction_rounded),
                      Text(' Clubs and Societies management'),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
