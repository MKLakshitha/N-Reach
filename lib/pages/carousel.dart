// ignore: file_names
import 'package:cached_network_image/cached_network_image.dart'; // Import Cached Network Image package
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore package
import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:popup_card/src/hero_route.dart';

Future<List<String>> getImageUrls() async {
  List<String> imageUrls = [];

  QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection('events').get();

  for (var doc in snapshot.docs) {
    imageUrls.add(doc[
        'image']); // 'imageUrl' is the field in your Firestore documents where you store the image URLs
  }

  return imageUrls;
}

class ImageCarousel extends StatelessWidget {
  const ImageCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: getImageUrls(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('No images available');
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
