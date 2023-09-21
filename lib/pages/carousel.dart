// ignore: file_names
import 'package:cached_network_image/cached_network_image.dart'; // Import Cached Network Image package
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore package
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:popup_card/src/hero_route.dart';
import 'constants.dart';

class Event {
  final Map<String, dynamic> data;

  Event(this.data);
}

Future<List<String>> getImageUrls() async {
  List<String> imageUrls = [];
  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('events')
      .orderBy('date_added', descending: true)
      .limit(20)
      .get();
  for (var doc in snapshot.docs) {
    imageUrls.add(doc['image']);
  }

  return imageUrls;
}

Future<List<Event>> getEventData() async {
  List<Event> events = [];

  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('events')
      .orderBy('date_added', descending: true)
      .get();
  for (var doc in snapshot.docs) {
    //imageUrls.add(doc['image']); // 'imageUrl' is the field in your Firestore documents where you store the image URLs
    Map<String, dynamic>? eventData = doc.data() as Map<String, dynamic>?;
    if (eventData != null) {
      events.add(Event(eventData));
    }
  }
  return events;
}

Future<List<String>> clubEventsId(String clubname) async {
  List<String> eventIds = [];
  QuerySnapshot clubQuery = await FirebaseFirestore.instance
      .collection('clubs')
      .where('abbr', isEqualTo: clubname)
      .get();
  DocumentSnapshot clubDoc = clubQuery.docs.first;

  // Retrieve the 'events' array field from the document
  List<dynamic>? events = clubDoc['events'];

  if (events != null) {
    eventIds = events.map((event) => event.toString()).toList();
  } else {
    print('No events found for $clubname');
  }
  return eventIds;
}

Future<List<String>> getImageUrlsForEventIds(
    Future<List<String>> clubsEventId) async {
  List<String> imageUrls = [];
  List<String> eventIds = await clubsEventId;

  try {
    for (String eventId in eventIds) {
      // Reference the event document by its ID
      DocumentSnapshot eventDoc = await FirebaseFirestore.instance
          .collection('events')
          .doc(eventId)
          .get();

      if (eventDoc.exists) {
        String imageUrl = eventDoc['image'];
        imageUrls.add(imageUrl);
      } else {
        print('Event document with ID $eventId does not exist.');
      }
    }
  } catch (e) {
    print('Error fetching image URLs: $e');
  }

  return imageUrls;
}

class ImageCarousel extends StatelessWidget {
  String clubname;
  ImageCarousel({super.key, required this.clubname});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: clubname.isEmpty
          ? getImageUrls()
          : getImageUrlsForEventIds(clubEventsId(clubname)),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
              height: mobileDeviceHeight * 0.2,
              child: const Center(child: CupertinoActivityIndicator()));
        } else if (snapshot.hasError) {
          return const SizedBox(
              height: 100,
              child: Center(child: Text('No latest events available')));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox(
              height: 100,
              child: Center(child: Text('No latest events available')));
        } else {
          List<String> imageUrls = snapshot.data!;

          return CarouselSlider(
            options: CarouselOptions(
              autoPlay: false,
              aspectRatio: 2.0,
              enlargeCenterPage: true,
            ),
            items: imageUrls.asMap().entries.map((entry) {
              // ignore: unused_local_variable
              final int index = entry.key;
              final String imageUrl = entry.value;
              return GestureDetector(
                onTap: () => Navigator.of(context).push(HeroDialogRoute(
                  builder: (context) {
                    return Center(
                      child: CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ); // Return the widget with the Hero
                  },
                )),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(horizontal: 0.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.grey,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        }
      },
    );
  }
}
