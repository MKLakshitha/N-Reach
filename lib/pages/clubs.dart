// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:popup_card/src/hero_route.dart';

import '../components/constants.dart';
import '../model/clubdata.dart';
import 'btmnavbar.dart';
import 'carousel.dart';
import 'sidebar.dart';

class Clubs extends StatelessWidget {
  final String clubName;
  Clubs({super.key, required this.clubName});

  late List<String> images, events, topboard, topboardimages, quotes, contact;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Club>>(
        future: fetchClubByName(clubName),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              appBar: AppBar(),
              body: const Center(
                  child: SizedBox(
                height: 100,
                width: 100,
                child: CircularProgressIndicator(),
              )),
              //
            ); // Show a loading indicator while fetching data
          }

          if (snapshot.hasError) {
            print(snapshot.error);
            return const Text(
                'Error retrieving snapshot.Please try again in a while.');
          }

          if (snapshot.hasData) {
            List<Club> clubs = snapshot.data!;

            if (clubs.isEmpty) {
              return const Center(
                child: Text(
                  'No club found with the provided data, please go back and try again.',
                  style: TextStyle(fontSize: 16),
                ),
              );
            }

            Club club = clubs.first;
            images = club.gallery;
            events = club.events;
            topboard = club.topboard;
            quotes = club.quote;
            topboardimages = club.topboardimages;
            contact = club.contact;

            return Scaffold(
              extendBodyBehindAppBar: true,
              body: CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    expandedHeight: mobileDeviceHeight * 0.31,
                    floating: false,
                    pinned: true,
                    //backgroundColor: Colors.transparent,
                    backgroundColor: Colors.white,
                    flexibleSpace: FlexibleSpaceBar(
                      title: Text(
                        club.abbreviation,
                        style: const TextStyle(color: Colors.black),
                      ),
                      background: CachedNetworkImage(
                        imageUrl: club.cover,
                        fit: BoxFit.cover,
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {},
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: buttonColor),
                          padding: const EdgeInsets.only(
                              top: 5, left: 8, bottom: 5, right: 8),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.group_add,
                                color: white,
                              ),
                              SizedBox(
                                  width:
                                      8.0), // Add some spacing between icon and text
                              Text(
                                'join',
                                style: TextStyle(color: white),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  SliverToBoxAdapter(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.only(
                                top: mobileDeviceHeight * 0.015,
                                bottom: mobileDeviceHeight * 0.01,
                                right: mobileDeviceWidth * 0.15,
                                left: mobileDeviceWidth * 0.15),
                            child: Text(
                              club.name,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const Divider(
                            height: 1,
                            color: Colors.black,
                            thickness: 1,
                            indent: 140,
                            endIndent: 140,
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                                top: mobileDeviceHeight * 0.012,
                                bottom: mobileDeviceHeight * 0.012,
                                right: mobileDeviceWidth * 0.04,
                                left: mobileDeviceWidth * 0.04,
                              ),
                              child: Text(
                                club.desc,
                                style: const TextStyle(fontSize: 12),
                                textAlign: TextAlign.center,
                              )),
                          Padding(
                            padding: EdgeInsets.only(
                                left: mobileDeviceWidth * 0.04,
                                bottom: mobileDeviceHeight * 0.012),
                            child: const Text(
                              'Gallery',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ),
                          ImageScroll(imageUrl: images),
                          Padding(
                            padding: EdgeInsets.only(
                                top: mobileDeviceHeight * 0.025,
                                left: mobileDeviceWidth * 0.04,
                                bottom: mobileDeviceHeight * 0.012),
                            child: const Text(
                              'Events and Announcements',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ),
                          const ImageCarousel(),
                          Quotes(
                              imgurls: topboardimages,
                              topboard: topboard,
                              quote: quotes),
                          ContactBar(contact: contact),
                        ]),
                  ),
                ],
              ),
              bottomNavigationBar:
                  BtmNavBar(currentIndex: 2, onItemSelected: onItemSelected),
            );
          }
          return Notfound();
        });
  }

  onItemSelected(int p1) {}
}

class ImageScroll extends StatelessWidget {
  final List<String> imageUrl;

  const ImageScroll({super.key, required this.imageUrl});

  //late List<String> images;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: mobileDeviceHeight * 0.136, // Adjust the height as needed
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: imageUrl.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => Navigator.of(context).push(
              HeroDialogRoute(
                builder: (context) {
                  return Center(
                    child: CachedNetworkImage(
                      imageUrl: imageUrl[index],
                      fit: BoxFit.cover,
                    ),
                  ); // Return the widget with the Hero
                },
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(0),
              child: Image.network(
                imageUrl[index],
                width: mobileDeviceWidth * 0.435,
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }
}

class Notfound extends StatelessWidget {
  const Notfound({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Data not found.',
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}

class Quotes extends StatelessWidget {
  final List<String> imgurls, topboard, quote;
  const Quotes(
      {super.key,
      required this.imgurls,
      required this.topboard,
      required this.quote});

  @override
  Widget build(BuildContext context) {
    return Container(
      //width: mobileDeviceWidth,
      padding: EdgeInsets.all(mobileDeviceWidth * 0.04),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Message from the Top Board',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          SizedBox(height: mobileDeviceHeight * 0.015),
          Row(
            children: [
              CircleAvatar(
                radius: mobileDeviceWidth * 0.12,
                backgroundImage: NetworkImage(imgurls[0]),
                backgroundColor: Colors.grey,
              ),
              SizedBox(width: mobileDeviceWidth * 0.012),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      ' "${quote[0]}" ',
                      style: const TextStyle(
                          fontSize: 17,
                          fontStyle: FontStyle.italic,
                          fontFamily: 'Times New Roman'),
                      textAlign: TextAlign.justify,
                      softWrap: true,
                    ),
                    LayoutBuilder(
                      builder:
                          (BuildContext context, BoxConstraints constraints) {
                        double fontSize = constraints.maxWidth * 0.04;

                        return Text(
                          '~ ${topboard[0]}, The President',
                          style: TextStyle(
                              fontSize: fontSize, fontWeight: FontWeight.w600),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: mobileDeviceWidth * 0.04),
          //vice president
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ' "${quote[1]}" ',
                      style: const TextStyle(
                          fontSize: 17,
                          fontStyle: FontStyle.italic,
                          fontFamily: 'Times New Roman'),
                      textAlign: TextAlign.justify,
                      softWrap: true,
                    ),
                    LayoutBuilder(
                      builder:
                          (BuildContext context, BoxConstraints constraints) {
                        double fontSize = constraints.maxWidth * 0.04;

                        return Text(
                          '~ ${topboard[1]}, The Vice-President',
                          style: TextStyle(
                              fontSize: fontSize, fontWeight: FontWeight.w600),
                        );
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(width: mobileDeviceWidth * 0.012),
              CircleAvatar(
                radius: mobileDeviceWidth * 0.12,
                backgroundImage: NetworkImage(imgurls[1]),
                backgroundColor: Colors.grey,
              ),
            ],
          ),
          SizedBox(
            height: mobileDeviceWidth * 0.04,
          ),
          Row(
            children: [
              CircleAvatar(
                radius: mobileDeviceWidth * 0.12,
                backgroundImage: NetworkImage(imgurls[2]),
                backgroundColor: Colors.grey,
              ),
              SizedBox(width: mobileDeviceWidth * 0.012),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      ' "${quote[2]}" ',
                      style: const TextStyle(
                          fontSize: 17,
                          fontStyle: FontStyle.italic,
                          fontFamily: 'Times New Roman'),
                      textAlign: TextAlign.justify,
                      softWrap: true,
                    ),
                    LayoutBuilder(
                      builder:
                          (BuildContext context, BoxConstraints constraints) {
                        double fontSize = constraints.maxWidth * 0.04;

                        return Text(
                          '~ ${topboard[2]}, The Secretary',
                          style: TextStyle(
                              fontSize: fontSize, fontWeight: FontWeight.w600),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ContactBar extends StatelessWidget {
  List<String> contact;
  ContactBar({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(
          255, 196, 196, 196), // Choose any background color
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.email),
          const SizedBox(width: 5), // Provide some spacing
          Text(contact[1]),
          const SizedBox(width: 20), // Provide some spacing
          const Icon(Icons.phone),
          const SizedBox(width: 5), // Provide some spacing
          Text(contact[0]),
        ],
      ),
    );
  }
}
