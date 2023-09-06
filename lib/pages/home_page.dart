import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:http/http.dart' as http;
import 'package:n_reach_nsbm/pages/appbar.dart';
import 'package:n_reach_nsbm/pages/btmnavbar.dart';
import 'package:n_reach_nsbm/pages/carousel.dart';
import 'package:n_reach_nsbm/pages/nroad_page.dart';
import 'package:n_reach_nsbm/pages/sidebar.dart';
import 'package:n_reach_nsbm/pages/sos.dart';
import 'package:n_reach_nsbm/pages/wallet_page.dart';
import 'package:qr_bar_code_scanner_dialog/qr_bar_code_scanner_dialog.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:url_launcher/url_launcher.dart';

import 'announcment_page.dart';
import 'blog_page.dart';
import 'clubsearch.dart';

class Story {
  final String title;
  final String imageUrl;
  final String category;
  final String description;
  final String url;

  Story({
    required this.title,
    required this.imageUrl,
    required this.category,
    required this.description,
    required this.url,
  });
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Story> stories = [];
  String selectedCategory = 'general'; // Default selected category
  List<Story> latestStoriesData = [];

  Future<List<Story>> fetchLatestStories() async {
    const apiKey = '82ea0012ab0a4c1c87fd6b34b5e8f6a7';

    final apiUrl =
        'https://newsapi.org/v2/top-headlines?country=us&category=$selectedCategory&apiKey=$apiKey';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      if (jsonResponse.containsKey('articles')) {
        final List<dynamic> articles = jsonResponse['articles'];
        if (articles.isNotEmpty) {
          return articles.take(2).map((item) {
            final imageUrl = item['urlToImage'] ??
                'https://st2.depositphotos.com/2026267/5233/i/950/depositphotos_52334423-stock-photo-news-article-on-digital-tablet.jpg'; // Default image URL
            final articleUrl = item['url'] ??
                'https://example.com'; // Default URL if 'url' is null
            return Story(
              title: item['title'] ?? 'No Title',
              imageUrl: imageUrl,
              category: selectedCategory,
              description: item['description'] ?? 'No Description',
              url: articleUrl,
            );
          }).toList();
        }
      }
    }
    return [];
  }

  @override
  void initState() {
    super.initState();
    // Fetch the latest two stories
    fetchAndSetLatestStories();
  }

  Future<void> fetchAndSetLatestStories() async {
    final latestStories = await fetchLatestStories();
    setState(() {
      latestStoriesData = latestStories;
    });
  }

  int _currentIndex = 2;
  final _controller = SidebarXController(selectedIndex: 0, extended: true);
  final _key = GlobalKey<ScaffoldState>();
  final _qrBarCodeScannerDialogPlugin = QrBarCodeScannerDialog();
  String? code;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;
    return Builder(builder: (context) {
      final isSmallScreen = MediaQuery.of(context).size.width < 600;
      return Scaffold(
        key: _key,
        appBar: Appbar(
          title: getTitle(),
        ),
        drawer: ExampleSidebarX(controller: _controller),
        body: Row(
          children: [
            if (!isSmallScreen) ExampleSidebarX(controller: _controller),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(0),
                  child: Column(
                    children: [
                      // Firestore ImageSlideshow
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection(
                                'announcements') // Adjust to your Firestore collection
                            .orderBy('date', descending: true)
                            .limit(6)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          }
                          if (!snapshot.hasData) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          final List<QueryDocumentSnapshot> documents =
                              snapshot.data!.docs;

                          final List<Widget> imageWidgets =
                              documents.map((doc) {
                            final imageUrl = doc[
                                'imageurl']; // Adjust this based on your Firestore structure
                            return Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                            );
                          }).toList();

                          return ImageSlideshow(
                            indicatorColor: Colors.blue,
                            autoPlayInterval: 5000,
                            isLoop: true,
                            height: screenheight * 0.25,
                            children: imageWidgets,
                          );
                        },
                      ), //quick actions pane
                      Container(
                        padding: EdgeInsets.all(screenwidth * 0.05),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Quick Actions\n',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                            Center(
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const AnnouncementPage()));
                                    },
                                    child: Container(
                                      height: screenwidth * 0.23,
                                      width: screenwidth * 0.23,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(14),
                                        color: Colors.white30,
                                        image: DecorationImage(
                                          image: const AssetImage(
                                              'assets/card1.png'),
                                          fit: BoxFit.cover,
                                          colorFilter: brightness(),
                                        ),
                                        boxShadow: [
                                          shadowcard(),
                                        ],
                                      ),
                                      child: Center(child: cardText('Shop')),
                                    ),
                                  ),
                                  SizedBox(
                                    width: screenwidth * 0.015,
                                  ),
                                  GestureDetector(
                                    onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const SearchClub())),
                                    child: Container(
                                      height: screenwidth * 0.23,
                                      width: screenwidth * 0.23,
                                      decoration: BoxDecoration(
                                        color: Colors.white30,
                                        borderRadius: BorderRadius.circular(14),
                                        image: DecorationImage(
                                          image: const AssetImage(
                                              'assets/card2.png'),
                                          fit: BoxFit.cover,
                                          colorFilter: brightness(),
                                        ),
                                        boxShadow: [
                                          shadowcard(),
                                        ],
                                      ),
                                      child: Center(child: cardText('Clubs')),
                                    ),
                                  ),
                                  SizedBox(
                                    width: screenwidth * 0.015,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const MapPage()));
                                    },
                                    child: Container(
                                      height: screenwidth * 0.23,
                                      width: screenwidth * 0.404,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(14),
                                        color: Colors.white30,
                                        image: DecorationImage(
                                          image: const AssetImage(
                                              'assets/card3.png'),
                                          fit: BoxFit.cover,
                                          colorFilter: brightness(),
                                        ),
                                        boxShadow: [
                                          shadowcard(),
                                        ],
                                      ),
                                      child: Center(child: cardText('N-Map')),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: screenwidth * 0.02,
                            ),
                            Center(
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const SOS()));
                                    },
                                    child: Container(
                                      height: screenwidth * 0.23,
                                      width: screenwidth * 0.404,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(14),
                                        color: Colors.white30,
                                        image: DecorationImage(
                                          image: const AssetImage(
                                              'assets/card4.png'),
                                          fit: BoxFit.cover,
                                          colorFilter: brightness(),
                                        ),
                                        boxShadow: [
                                          shadowcard(),
                                        ],
                                      ),
                                      child: Center(
                                          child:
                                              cardText('Emergency Alert/SOS')),
                                    ),
                                  ),
                                  SizedBox(
                                    width: screenwidth * 0.015,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      _qrBarCodeScannerDialogPlugin
                                          .getScannedQrBarCode(
                                              context: context,
                                              onCode: (code) {
                                                setState(() {
                                                  this.code = code;
                                                });
                                              });
                                    },
                                    child: Container(
                                      height: screenwidth * 0.23,
                                      width: screenwidth * 0.23,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(14),
                                        color: Colors.white30,
                                        image: DecorationImage(
                                          image: const AssetImage(
                                              'assets/card5.png'),
                                          fit: BoxFit.cover,
                                          colorFilter: brightness(),
                                        ),
                                        boxShadow: [
                                          shadowcard(),
                                        ],
                                      ),
                                      child: Center(
                                          child:
                                              cardText(code ?? 'QR Scanner')),
                                    ),
                                  ),
                                  SizedBox(
                                    width: screenwidth * 0.015,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const WalletPage()));
                                    },
                                    child: Container(
                                      height: screenwidth * 0.23,
                                      width: screenwidth * 0.23,
                                      decoration: BoxDecoration(
                                        color: Colors.white30,
                                        borderRadius: BorderRadius.circular(14),
                                        image: DecorationImage(
                                          image: const AssetImage(
                                              'assets/card1.png'),
                                          fit: BoxFit.cover,
                                          colorFilter: brightness(),
                                        ),
                                        boxShadow: [
                                          shadowcard(),
                                        ],
                                      ),
                                      child: Center(child: cardText('Wallet')),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: screenwidth * 0.05),
                            child: const Text(
                              'Upcoming Events\n',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                          ),

                          const ImageCarousel(), //upcoming events
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: BtmNavBar(
          currentIndex: _currentIndex,
          onItemSelected: _onItemTapped,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BlogPage()),
            );
          },
          // Set the background color to grey
          child: const Icon(Icons.message,
              color: Colors.white), // Change the icon color to white
        ),
      );
    });
  }

  Text cardText(String txt) {
    return Text(txt,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: [
            Shadow(
                // bottomRight
                offset: Offset(1.5, 1.5),
                color: Color.fromARGB(120, 0, 0, 0),
                blurRadius: 3.0),
          ],
        ));
  }

  ColorFilter brightness() {
    return ColorFilter.mode(
      Colors.black.withOpacity(
          0.1), // Adjust the opacity value (0.0 to 1.0) to control brightness
      BlendMode
          .darken, // Use BlendMode.darken to make the image darker, BlendMode.lighten to make it brighter
    );
  }

  BoxShadow shadowcard() {
    return BoxShadow(
      color:
          const Color.fromARGB(255, 0, 0, 0).withOpacity(0.25), // Shadow color
      spreadRadius: -1, // How much the shadow should spread
      blurRadius: 6, // How blurry the shadow should be
      offset: const Offset(0, 4), // Offset from the container
    );
  }
}

String getTitle() {
  DateTime now = DateTime.now();
  int hour = now.hour;
  if (hour >= 6 && hour < 12) {
    return 'Good Morning';
  } else if (hour >= 12 && hour < 18) {
    return 'Good Afternoon';
  } else {
    return 'Good Evening';
  }
}

class StoryCard extends StatelessWidget {
  final Story story;

  const StoryCard({Key? key, required this.story}) : super(key: key);

  void _launchURL() async {
    if (await canLaunch(story.url)) {
      await launch(story.url);
    } else {
      throw 'Could not launch ${story.url}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            story.imageUrl,
            height: 200.0,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              story.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, bottom: 16.0),
            child: Text(
              'Category: ${story.category}',
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              story.description,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _launchURL,
              child: const Text('Read More'),
            ),
          ),
        ],
      ),
    );
  }
}
