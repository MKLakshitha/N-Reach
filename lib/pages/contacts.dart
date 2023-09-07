import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:../constants/constants.dart';
import 'btmnavbar.dart';

class Contacts extends StatefulWidget {
  const Contacts({super.key});

  @override
  State<Contacts> createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Useful Contacts',
            style: blackText,
          ),
        ),
        bottomNavigationBar:
            BtmNavBar(currentIndex: 2, onItemSelected: onItemSelected),
        body: Padding(
          padding: EdgeInsets.only(
            left: mobileDeviceWidth * 0.04,
            bottom: mobileDeviceWidth * 0.04,
            right: mobileDeviceWidth * 0.04,
          ),
          child: FutureBuilder<Map<String, List<Contact>>>(
            future: fetchAndOrganizeContacts(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Text('No contacts found.');
              } else {
                final categorizedContacts = snapshot.data;
                final categories = categorizedContacts!.keys.toList();

                return ListView.builder(
                  itemCount: categories.length *
                      2, // Multiply by 2 for category headings
                  itemBuilder: (context, index) {
                    if (index.isOdd) {
                      // Render contacts
                      final categoryIndex = index ~/ 2;
                      final category = categories[categoryIndex];
                      final contacts = categorizedContacts[category]!;
                      String title;

                      switch (category) {
                        case ('foc'):
                          title = "Faculty of Computing";
                        case ('fob'):
                          title = "Faculty of Business";
                        case ('foe'):
                          title = "Faculty of Engineering";
                        case ('it'):
                          title = "IT department";
                        default:
                          title = category;
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title, // Category heading
                            style: const TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(
                            height: mobileDeviceWidth * 0.01,
                          ),
                          ...contacts.map((contact) {
                            return Padding(
                              padding: EdgeInsets.only(
                                top: mobileDeviceWidth * 0.01,
                                bottom: mobileDeviceWidth * 0.01,
                                right: mobileDeviceWidth * 0.01,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text("${contact.name} ",
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400)),
                                      Text('(${contact.position})',
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: const TextStyle(
                                              fontSize: 14, color: grey)),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        contact.mobile,
                                        style: const TextStyle(
                                            color: Color.fromARGB(
                                                255, 81, 81, 81)),
                                      ),
                                      Text(contact.email,
                                          style: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 81, 81, 81)))
                                    ],
                                  )
                                ],
                              ),
                            );
                          }),
                        ],
                      );
                    } else {
                      // Render separators
                      return const Divider();
                    }
                  },
                );
              }
            },
          ),
        ));
  }

  onItemSelected(int p1) {}
}

//model class
class Contact {
  final String type;
  final String name;
  final String position;
  final String email;
  final String mobile;

  Contact({
    required this.type,
    required this.name,
    required this.position,
    required this.email,
    required this.mobile,
  });

  factory Contact.fromFirestore(Map<String, dynamic> data) {
    return Contact(
      type: data['type'] ?? '',
      name: data['name'] ?? '',
      position: data['position'] ?? '',
      email: data['email'] ?? '',
      mobile: data['mobile'] ?? '',
    );
  }
}

//fetch data from firestore - method
Future<List<Contact>> fetchContacts() async {
  try {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('contacts').get();

    List<Contact> contacts = snapshot.docs.map((doc) {
      return Contact.fromFirestore(doc.data() as Map<String, dynamic>);
    }).toList();

    return contacts;
  } catch (e) {
    print('Error fetching contacts: $e');
    return [];
  }
}

Future<Map<String, List<Contact>>> fetchAndOrganizeContacts() async {
  try {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('contacts').get();

    Map<String, List<Contact>> categorizedContacts = {};

    for (var doc in snapshot.docs) {
      final contact = Contact.fromFirestore(doc.data() as Map<String, dynamic>);
      final type = contact.type;

      if (!categorizedContacts.containsKey(type)) {
        categorizedContacts[type] = [];
      }

      categorizedContacts[type]!.add(contact);
    }

    return categorizedContacts;
  } catch (e) {
    print('Error fetching contacts: $e');
    return {};
  }
}
