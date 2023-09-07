import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/constants.dart';
import 'btmnavbar.dart';

class Magazines extends StatefulWidget {
  const Magazines({super.key});

  @override
  State<Magazines> createState() => _MagazinesState();
}

class _MagazinesState extends State<Magazines> {
  List<Magaz> magazines = [];

  @override
  void initState() {
    super.initState();
    // Fetch magazines from Firestore when the widget initializes
    fetchMagaz().then((magazinesData) {
      setState(() {
        magazines = magazinesData;
      });
    });
  }

  Future<void> _refresh() async {
    // Simulate a delay before refreshing data
    await Future.delayed(const Duration(seconds: 2));

    // Replace this with your data fetching logic
    final updatedMagazines = await fetchMagaz();
    setState(() {
      magazines = updatedMagazines;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'NSBM Magazines',
          style: blackText,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(mobileDeviceWidth * 0.02),
            child: const Text('Explore a wide range of NSBM magazines here '),
          ),
          Expanded(
            child: FutureBuilder<List<Magaz>>(
                future: fetchMagaz(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(
                      height: 100,
                      width: 100,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  if (snapshot.hasData) {
                    List<Magaz> magazines = snapshot.data!;
                    return RefreshIndicator(
                      onRefresh: _refresh,
                      child: ListView.builder(
                        itemCount: magazines.length,
                        itemBuilder: (context, index) {
                          final magazine = magazines[index];
                          return GestureDetector(
                            onTap: () async {
                              // ignore: deprecated_member_use
                              if (await canLaunch(magazine.pdfUrl)) {
                                // ignore: deprecated_member_use
                                await launch(magazine.pdfUrl);
                              } else {
                                throw 'Could not launch pdf Url';
                              }
                            },
                            child: magazineCards(magazine.imgUrl,
                                magazine.title, magazine.pdfUrl),
                          );
                        },
                      ),
                    );
                  }
                  return const Padding(
                    padding: EdgeInsets.only(top: 160, left: 8, right: 8),
                    child: Center(
                        child: Text(
                      'Database under maintenance. Thank you for your patience',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.blue),
                    )),
                  );
                }),
          ),
        ],
      ),
      bottomNavigationBar:
          BtmNavBar(currentIndex: 2, onItemSelected: onItemSelected),
    );
  }

  Padding magazineCards(String imgUrl, String title, String pdfUrl) {
    return Padding(
      padding: EdgeInsets.only(
        top: mobileDeviceWidth * 0.04,
        left: mobileDeviceWidth * 0.04,
        right: mobileDeviceWidth * 0.04,
      ),
      child: Container(
        padding: EdgeInsets.all(mobileDeviceHeight * 0.015),
        height: mobileDeviceHeight * 0.2,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey[200],
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(255, 177, 177, 177),
              offset: Offset(0, 4), // Offset of the shadow
              blurRadius: 10, // Spread of the shadow
              spreadRadius: 0,
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image.network(
              imgUrl,
              fit: BoxFit.cover,
              height: mobileDeviceHeight * 0.14,
              width: double.infinity,
            ),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          ],
        ),
      ),
    );
  }

  void onItemSelected(int p1) {
    // Handle bottom navigation item selection here
  }
}

class Magaz {
  final String title, imgUrl, pdfUrl;

  Magaz({required this.title, required this.imgUrl, required this.pdfUrl});
  factory Magaz.fromFirestore(Map<String, dynamic> data) {
    return Magaz(
        imgUrl: data['imgUrl'], title: data['title'], pdfUrl: data['pdfUrl']);
  }
}

Future<List<Magaz>> fetchMagaz() async {
  try {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('magazines').get();

    List<Magaz> magaz = snapshot.docs.map((doc) {
      return Magaz.fromFirestore(doc.data() as Map<String, dynamic>);
    }).toList();

    return magaz;
  } catch (e) {
    print('Error fetching magazines: $e');
    return [];
  }
}
