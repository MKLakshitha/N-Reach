import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:simple_flutter_app/adminpages/uploadevent.dart';
import 'package:simple_flutter_app/constants/constants.dart';
import 'package:simple_flutter_app/pages/btmnavbar.dart';

class ClubDashboard extends StatefulWidget {
  // Current authenticated user
  String abbr;

  ClubDashboard({super.key, required this.abbr});

  @override
  _ClubDashboardState createState() => _ClubDashboardState();
}

class _ClubDashboardState extends State<ClubDashboard> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController quotesController = TextEditingController();
  final TextEditingController subDescriptionController =
      TextEditingController();
  final TextEditingController topboardController = TextEditingController();
  List<File> galleryImages = [];
  File? coverImage;
  File? logoImage;

  final CollectionReference clubsCollection =
      FirebaseFirestore.instance.collection('clubs');
  final FirebaseStorage storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  // Function to upload an image to Firebase Storage and return its URL
  Future<String> _uploadImage(File image) async {
    final Reference storageReference = storage
        .ref()
        .child('club_images/${DateTime.now().millisecondsSinceEpoch}');
    final UploadTask uploadTask = storageReference.putFile(image);
    await uploadTask;
    return await storageReference.getDownloadURL();
  }

  Future<void> _saveClubData() async {
    String clubName = nameController.text;
    String quotes = quotesController.text;
    String subDescription = subDescriptionController.text;
    String topboard = topboardController.text;

    // Upload images and get URLs
    String coverImageUrl = await _uploadImage(coverImage!);
    String logoImageUrl = await _uploadImage(logoImage!);

    List<String> galleryImageUrls = [];
    for (File image in galleryImages) {
      galleryImageUrls.add(await _uploadImage(image));
    }
    QuerySnapshot querySnapshot =
        await clubsCollection.where('abbr', isEqualTo: widget.abbr).get();

    // Create a club document in Firestore
    if (querySnapshot.docs.isNotEmpty) {
      // If a document with the matching 'abbr' exists, update its data
      DocumentReference docRef = querySnapshot.docs[0].reference;
      await docRef.update({
        'Name': clubName,
        'cover': coverImageUrl,
        'logoImageUrl': logoImageUrl,
        'gallery': galleryImageUrls,
        'quotes': quotes,
        'subDescription': subDescription,
        'topboard': topboard,
      });
    }

    // Clear input fields and images
    nameController.clear();
    quotesController.clear();
    subDescriptionController.clear();
    topboardController.clear();
    setState(() {
      coverImage = null;
      logoImage = null;
      galleryImages.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            '${widget.abbr} Dashboard',
            style: blackText,
          ),
        ),
        bottomNavigationBar:
            BtmNavBar(currentIndex: 2, onItemSelected: (index) {}),
        body: ListView(
          children: [
            ExpansionTile(
              title: const Text('Edit club data'),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: editClubData(),
                )
              ],
            ),
            ExpansionTile(
              title: const Text('Add new events'),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: AddEventPage(
                    clubname: widget.abbr,
                  ),
                )
              ],
            )
          ],
        ));
  }

  Column editClubData() {
    return Column(
      children: <Widget>[
        TextFormField(
          controller: nameController,
          decoration: InputDecoration(labelText: 'Club Name ${widget.abbr}'),
        ),
        TextFormField(
          controller: quotesController,
          decoration: const InputDecoration(labelText: 'Quotes'),
        ),
        TextFormField(
          controller: subDescriptionController,
          decoration: const InputDecoration(labelText: 'Sub Description'),
        ),
        TextFormField(
          controller: topboardController,
          decoration: const InputDecoration(labelText: 'Topboard'),
        ),
        const SizedBox(height: 20),
        const Text('Cover Image'),
        coverImage != null
            ? Image.file(
                coverImage!,
                height: 100,
              )
            : const SizedBox(),
        ElevatedButton(
          onPressed: () async {
            final pickedFile =
                await _picker.pickImage(source: ImageSource.gallery);
            if (pickedFile != null) {
              setState(() {
                coverImage = File(pickedFile.path);
              });
            }
          },
          child: const Text('Pick Cover Image'),
        ),
        const SizedBox(height: 20),
        const Text('Logo Image'),
        logoImage != null
            ? Image.file(
                logoImage!,
                height: 100,
              )
            : const SizedBox(),
        ElevatedButton(
          onPressed: () async {
            final pickedFile =
                await _picker.pickImage(source: ImageSource.gallery);
            if (pickedFile != null) {
              setState(() {
                logoImage = File(pickedFile.path);
              });
            }
          },
          child: const Text('Pick Logo Image'),
        ),
        const SizedBox(height: 20),
        const Text('Gallery Images'),
        Column(
          children: galleryImages.map((image) {
            return Image.file(
              image,
              height: 100,
            );
          }).toList(),
        ),
        ElevatedButton(
          onPressed: () async {
            final pickedFiles = await _picker.pickMultiImage(
              imageQuality: 50,
            );
            setState(() {
              galleryImages =
                  pickedFiles.map((file) => File(file.path)).toList();
            });
          },
          child: const Text('Pick Gallery Images'),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _saveClubData,
          child: const Text('Save Club Data'),
        ),
      ],
    );
  }
}
