import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../constants/constants.dart';

class BlogPage extends StatefulWidget {
  const BlogPage({Key? key}) : super(key: key);

  @override
  _BlogPageState createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final TextEditingController tweetController = TextEditingController();

  String? currentUserDisplayName;
  bool isTextFieldVisible = false;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    fetchCurrentUserDisplayName();
  }

  Future<void> fetchCurrentUserDisplayName() async {
    final User? currentUser = auth.currentUser;
    if (currentUser != null) {
      final DocumentSnapshot userSnapshot =
          await firestore.collection('users').doc(currentUser.uid).get();
      final userData = userSnapshot.data() as Map<String, dynamic>?;
      if (userData != null && userData.containsKey('display_name')) {
        setState(() {
          currentUserDisplayName = userData['display_name'];
        });
      }
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void toggleTextFieldVisibility() {
    setState(() {
      isTextFieldVisible = !isTextFieldVisible;
    });
  }

  Future<void> sendTweet() async {
    final currentUser = auth.currentUser;
    if (currentUser != null) {
      final Timestamp timestamp = Timestamp.fromMillisecondsSinceEpoch(
        DateTime.now().millisecondsSinceEpoch ~/ 1000 * 1000,
      );

      Map<String, dynamic> tweetData = {
        'text': tweetController.text,
        'timestamp': timestamp,
        'author': currentUserDisplayName?.replaceAll(' ', '_'),
        'image_url': "",
      };

      if (_imageFile != null) {
        // Upload image if available
        final imageStorageRef = FirebaseStorage.instance
            .ref()
            .child('tweet_images')
            .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

        final UploadTask uploadTask = imageStorageRef.putFile(_imageFile!);

        await uploadTask.whenComplete(() async {
          final imageUrl = await imageStorageRef.getDownloadURL();
          tweetData['image_url'] = imageUrl;
        });
      }

      // Upload tweet data to Firestore
      await firestore.collection('tweets').add(tweetData);

      // Clear the text and image selection
      tweetController.clear();
      setState(() {
        _imageFile = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons
              .arrow_back_ios_new_rounded), // Replace with your desired leading icon
          onPressed: () {
            Navigator.pushNamed(context, '/home');
          },
        ),
        title: const Row(
          children: <Widget>[
            Text(
              'the',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            Text(
              'Blogged ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 10.0,
              width: 100.0,
              child: ElevatedButton(
                onPressed: toggleTextFieldVisibility,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.black),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
                child: const Text(
                  'Blog Now',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      body: Stack(children: [
        Positioned(
          top: mobileDeviceWidth * 0.04,
          bottom: 0,
          left: mobileDeviceWidth * 0.85,
          child: Container(
            width: 1, // Adjust the height of the line as needed
            color: const Color.fromARGB(
                255, 74, 74, 74), // Adjust the color as needed
          ),
        ),
        Column(
          children: <Widget>[
            const SizedBox(
              child: Divider(
                height: 10,
                color: Colors.black,
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: firestore
                    .collection('tweets')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final tweets = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: tweets.length,
                    itemBuilder: (context, index) {
                      final tweet = tweets[index];
                      final tweetText = tweet['text'];
                      final tweetAuthor = tweet['author'];
                      final tweetdate = tweet['timestamp'];
                      final tweetId = tweet.id;

                      return TweetWidget(
                        tweetText: tweetText,
                        tweetAuthor: tweetAuthor,
                        tweetId: tweetId,
                        imageUrl: tweet['image_url'],
                        date: tweetdate,
                      );
                    },
                  );
                },
              ),
            ),
            Visibility(
              visible: isTextFieldVisible,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: tweetController,
                            decoration: const InputDecoration(
                              labelText: 'What\'s happening?',
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: _pickImage,
                        ),
                        IconButton(
                          icon: const Icon(Icons.send),
                          onPressed: () {
                            sendTweet();
                          },
                        ),
                      ],
                    ),
                    if (_imageFile != null) ...[
                      const SizedBox(height: 10),
                      Image.file(
                        _imageFile!,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ]),
      bottomNavigationBar: BottomAppBar(
        color: Colors.black,
        child: Container(
          padding: const EdgeInsets.only(top: 2.0, left: 15, right: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Text(
                  "Start blogging at the students' centre",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: mobileDeviceWidth < 400 ? 12.0 : 14.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: ElevatedButton(
                  onPressed: toggleTextFieldVisibility,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                  child: Text(
                    'Create',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: mobileDeviceWidth < 400 ? 12.0 : 14.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    tweetController.dispose();
    super.dispose();
  }
}

class TweetWidget extends StatefulWidget {
  final String tweetText;
  final String tweetAuthor;
  final String tweetId;
  final String imageUrl;
  final Timestamp date;

  const TweetWidget({
    Key? key,
    required this.tweetText,
    required this.tweetAuthor,
    required this.tweetId,
    required this.imageUrl,
    required this.date,
  }) : super(key: key);

  @override
  _TweetWidgetState createState() => _TweetWidgetState();
}

class _TweetWidgetState extends State<TweetWidget> {
  int likeCount = 0;
  bool isLiked = false;
  int reportCount = 0;

  @override
  void initState() {
    super.initState();
    fetchLikeStatus();
    fetchTotalLikeCount();
    fetchReportCount();
  }

  Future<void> fetchLikeStatus() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final likeDocRef = FirebaseFirestore.instance
          .collection('tweets')
          .doc(widget.tweetId)
          .collection('likes')
          .doc(currentUser.uid);

      final likeDoc = await likeDocRef.get();
      if (likeDoc.exists) {
        setState(() {
          isLiked = likeDoc['liked'];
        });
      }
    }
  }

  Future<void> fetchTotalLikeCount() async {
    final tweetRef =
        FirebaseFirestore.instance.collection('tweets').doc(widget.tweetId);
    final likeQuerySnapshot = await tweetRef.collection('likes').get();
    setState(() {
      likeCount = likeQuerySnapshot.docs.length;
    });
  }

  Future<void> fetchReportCount() async {
    final tweetRef =
        FirebaseFirestore.instance.collection('tweets').doc(widget.tweetId);
    final reportQuerySnapshot = await tweetRef.collection('reports').get();
    if (mounted) {
      setState(() {
        reportCount = reportQuerySnapshot.docs.length;
      });
    }
    // Check if report count reaches 3, and delete the tweet if so
    if (reportCount >= 3) {
      tweetRef.delete();
    }
  }

  Future<void> updateLikeStatus() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final tweetRef =
          FirebaseFirestore.instance.collection('tweets').doc(widget.tweetId);
      final likeDocRef = tweetRef.collection('likes').doc(currentUser.uid);

      if (isLiked) {
        await likeDocRef.delete();
      } else {
        await likeDocRef.set({
          'liked': true,
        });
      }

      fetchTotalLikeCount();
    }
  }

  Future<void> reportTweet() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final tweetRef =
          FirebaseFirestore.instance.collection('tweets').doc(widget.tweetId);

      final reportDocRef = tweetRef.collection('reports').doc(currentUser.uid);

      final reportDoc = await reportDocRef.get();

      if (!reportDoc.exists) {
        // Increment the report count and check if it reaches 3
        reportCount++;
        await reportDocRef.set({
          'reported': true,
        });

        // Check if report count reaches 3, and delete the tweet if so
        if (reportCount >= 1) {
          if (mounted) {
            setState(() {
              // Update the state variables here
              tweetRef.delete();
            });
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 2));

        setState(() {});
      },
      child: Padding(
        padding: EdgeInsets.only(
          left: mobileDeviceWidth * 0.05,
          right: mobileDeviceWidth * 0.01,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: mobileDeviceWidth * 0.78,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        '@${widget.tweetAuthor}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      ClipRRect(
                        child: PopupMenuButton<String>(
                          padding: const EdgeInsets.all(0),
                          onSelected: (value) {
                            if (value == 'report') {
                              reportTweet();
                            }
                          },
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<String>>[
                            const PopupMenuItem<String>(
                              value: 'report',
                              child: Text('Report',
                                  style:
                                      TextStyle(fontWeight: FontWeight.w500)),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Text(
                    widget.tweetText,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14.5,
                    ),
                  ),
                  SizedBox(
                    height: mobileDeviceHeight * 0.0098,
                  ),
                  if (widget.imageUrl.isNotEmpty) ...[
                    Image.network(
                      widget.imageUrl,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(
                      height: mobileDeviceHeight * 0.0098,
                    ),
                  ],
                  Text(
                    'blogged ${formatTimestamp(widget.date)}',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  SizedBox(
                    height: mobileDeviceHeight * 0.0098,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.89,
                    child: const Divider(
                      height: 1,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            likesCounter()
          ],
        ),
      ),
    );
  }

  Column likesCounter() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(
            isLiked ? Icons.favorite : Icons.favorite_border,
            color: isLiked ? Colors.red : null,
          ),
          padding: const EdgeInsets.all(0),
          //alignment: Alignment.topCenter,
          onPressed: () {
            updateLikeStatus();
          },
        ),
        Text('$likeCount'),
      ],
    );
  }
}

String formatTimestamp(Timestamp timestamp) {
  final now = DateTime.now();
  final dateTime = timestamp.toDate();
  final diff = now.difference(dateTime);

  if (diff.inSeconds < 20) {
    return 'just now';
  } else if (diff.inSeconds < 60) {
    final seconds = diff.inSeconds;
    return '${seconds}s ago';
  } else if (diff.inMinutes < 60) {
    final minutes = diff.inMinutes;
    return '$minutes min${minutes != 1 ? 's' : ''} ago';
  } else if (diff.inHours < 24) {
    final hours = diff.inHours;
    return '$hours hour${hours != 1 ? 's' : ''} ago';
  } else {
    return DateFormat('dd MMM yyyy hh:mm a').format(dateTime);
  }
}
