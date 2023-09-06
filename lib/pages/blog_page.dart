import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

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
        'author': currentUserDisplayName,
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
        title: const Row(
          children: <Widget>[
            Text(
              'Blogged By ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              'NReach',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
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
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      body: Column(
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
                    final tweetId = tweet.id;

                    return TweetWidget(
                      tweetText: tweetText,
                      tweetAuthor: tweetAuthor,
                      tweetId: tweetId,
                      imageUrl: tweet['image_url'],
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
      bottomNavigationBar: BottomAppBar(
        color: Colors.black,
        child: Container(
          padding: const EdgeInsets.only(top: 2.0, left: 15, right: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Text(
                'Start blogging at the students’ centre',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
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
                  child: const Text(
                    'Create',
                    style: TextStyle(
                      color: Colors.black,
                    ),
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

  const TweetWidget({
    Key? key,
    required this.tweetText,
    required this.tweetAuthor,
    required this.tweetId,
    required this.imageUrl,
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
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          left: BorderSide(width: 4.0, color: Colors.blue),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  '@${widget.tweetAuthor}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  width: 80,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(
                      12.0), // Adjust the radius as needed
                  child: PopupMenuButton<String>(
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
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 4.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width - 150,
                  child: Text(
                    widget.tweetText,
                    style: const TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? Colors.red : null,
                  ),
                  onPressed: () {
                    updateLikeStatus();
                  },
                ),
              ],
            ),
            if (widget.imageUrl.isNotEmpty) ...[
              const SizedBox(height: 10),
              Image.network(
                widget.imageUrl,
                width: MediaQuery.of(context).size.width - 150,
                fit: BoxFit.cover,
              ),
            ],
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  DateFormat('yyyy-MM-dd hh:mm:ss a')
                      .format(DateTime.now().toLocal()),
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
                Row(
                  children: [
                    Text('$likeCount Likes'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: MediaQuery.of(context).size.width - 150,
              child: const Divider(
                height: 1,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
