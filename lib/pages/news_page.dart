import 'dart:convert';

import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import 'btmnavbar.dart';

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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const NewsFeed(),
    );
  }
}

class NewsFeed extends StatefulWidget {
  const NewsFeed({Key? key}) : super(key: key);

  @override
  NewsFeedState createState() => NewsFeedState();
}

class NewsFeedState extends State<NewsFeed> {
  List<Story> stories = [];
  List<String> categories = [
    'general',
    'technology',
    'business',
    'science',
    'engineering',
    'health',
    'sports',
    'entertainment',
  ];
  String selectedCategory = 'general'; // Default selected category
  List<String> filteredCategories = [];
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

  List<Story> latestStoriesData = [];

  Future<void> fetchAndSetLatestStories() async {
    final latestStories = await fetchLatestStories();
    setState(() {
      latestStoriesData = latestStories;
    });
  }

  Future<void> fetchAllStories() async {
    const apiKey = '82ea0012ab0a4c1c87fd6b34b5e8f6a7';

    for (String category in categories) {
      final apiUrl =
          'https://newsapi.org/v2/top-headlines?country=us&category=$category&apiKey=$apiKey';

      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (mounted) {
          if (jsonResponse.containsKey('articles')) {
            final List<dynamic> articles = jsonResponse['articles'];
            setState(() {
              stories.addAll(articles.map((item) {
                final imageUrl = item['urlToImage'] ??
                    'https://st2.depositphotos.com/2026267/5233/i/950/depositphotos_52334423-stock-photo-news-article-on-digital-tablet.jpg'; // Default image URL
                final articleUrl = item['url'] ??
                    'https://example.com'; // Default URL if 'url' is null
                return Story(
                  title: item['title'] ?? 'No Title',
                  imageUrl: imageUrl,
                  category: category,
                  description: item['description'] ?? 'No Description',
                  url: articleUrl,
                );
              }));
            });
          }
        } else {
          throw Exception('No articles found in the response');
        }
      } else {
        throw Exception('Failed to load data');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // Fetch articles for all categories
    fetchAllStories();
    filteredCategories = List.from(categories);
    // Fetch the latest two stories
    fetchAndSetLatestStories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'N - Global',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: categories.map((category) {
                final isSelected = selectedCategory == category;
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedCategory = category;
                      });
                    },
                    style: ButtonStyle(
                      elevation: isSelected
                          ? MaterialStateProperty.all<double>(4.0)
                          : MaterialStateProperty.all<double>(0.0),
                      backgroundColor: isSelected
                          ? MaterialStateProperty.all<Color>(Colors.green)
                          : MaterialStateProperty.all<Color>(
                              Colors.transparent),
                      foregroundColor: isSelected
                          ? MaterialStateProperty.all<Color>(Colors.white)
                          : MaterialStateProperty.all<Color>(Colors.black),
                    ),
                    child: Text(category),
                  ),
                );
              }).toList(),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20.0),
            child: const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Top Stories',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: stories.length,
              itemBuilder: (context, index) {
                // Filter stories based on the selected categories
                if (selectedCategory.isEmpty ||
                    selectedCategory == stories[index].category) {
                  return StoryCard(story: stories[index]);
                } else {
                  return Container(); // Hide non-matching stories
                }
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BtmNavBar(
        currentIndex: 2,
        onItemSelected: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.filter_list),
        onPressed: () async {
          final selectedListData = await FilterListDialog.display<String>(
            context,
            listData: categories,
            selectedListData:
                selectedCategory.isEmpty ? [] : [selectedCategory],
            height: 480,
            headlineText: "Select Categories",
            choiceChipLabel: (item) {
              return item;
            },
            validateSelectedItem: (list, val) {
              return list!.contains(val);
            },
            onApplyButtonClick: (list) {
              if (list != null && list.isNotEmpty) {
                setState(() {
                  selectedCategory = list[0];
                });
              } else {
                setState(() {
                  selectedCategory = '';
                });
              }
              Navigator.pop(context);
            },
            onItemSearch: (list, text) {
              return false;
              // Implement search functionality if needed
            },
          );
          if (selectedListData != null && selectedListData.isNotEmpty) {
            setState(() {
              selectedCategory = selectedListData[0];
            });
          }
        },
      ),
    );
  }

  void _onItemTapped(int index) {
    // TODO: Handle bottom navigation bar item tap
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
