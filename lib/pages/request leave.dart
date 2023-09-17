import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:simple_flutter_app/constants/constants.dart';
import 'package:simple_flutter_app/pages/btmnavbar.dart';

class AbsenceForm extends StatefulWidget {
  AbsenceForm({super.key});

  final String name = "Praveen";
  final String id = "23926";
  bool isLoading = false;
  bool isOverlayOpen = false;

  @override
  _AbsenceFormState createState() => _AbsenceFormState();
}

class _AbsenceFormState extends State<AbsenceForm> {
  void openOverlay() {
    setState(() {
      widget.isOverlayOpen = true;
    });
  }

  void closeOverlay() {
    setState(() {
      widget.isOverlayOpen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Absence form',
          style: blackText,
        ),
        centerTitle: false,
        titleSpacing: 1.0,
        automaticallyImplyLeading: true,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 10.0,
              child: ElevatedButton(
                onPressed: openOverlay,
                style: ButtonStyle(
                  //backgroundColor: MaterialStateProperty.all(Colors.black),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
                child: const Text(
                  'submit reason',
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
      bottomNavigationBar:
          BtmNavBar(currentIndex: 2, onItemSelected: (index) {}),
      body: Stack(children: [
        SingleChildScrollView(
          //padding: const EdgeInsets.all(16),
          child: SizedBox(
            height: mobileDeviceHeight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding:
                      EdgeInsets.only(top: 10, bottom: 4, left: 15, right: 15),
                  child: Text(
                    'Students are required to maintain a attendance of over 75%.The absence reasons you have submitted previously will be listed below.',
                    textAlign: TextAlign.justify,
                  ),
                ),
                newMethod(),
              ],
            ),
          ),
        ),
        SlidingOverlayContainer(
          isOpen: widget.isOverlayOpen,
          onClose: closeOverlay,
        ),
      ]),
    );
  }

  StreamBuilder<QuerySnapshot<Map<String, dynamic>>> newMethod() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('absence_reasons')
          .where('studentID', isEqualTo: widget.id)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CupertinoActivityIndicator(),
          );
        }

        final List<QueryDocumentSnapshot> reasons = snapshot.data!.docs;

        if (reasons.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            child: Text(
              'You have not submitted any absence reason form.',
              style: greyText,
            ),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.all(0),
          itemCount: reasons.length,
          itemBuilder: (BuildContext context, int index) {
            final reason = reasons[index];

            return ListTile(
              title: Text('${reason['module']}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      'Date added: ${reason['date']}\nSubmission ID: ${reason.id}\nReason: ${reason['reason']}'),
                  SizedBox(
                    height: mobileDeviceHeight * 0.01,
                  ),
                  const Divider(
                    height: 1,
                    thickness: 2,
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class SlidingOverlayContainer extends StatefulWidget {
  final bool isOpen;
  final VoidCallback onClose;

  const SlidingOverlayContainer({
    super.key,
    required this.isOpen,
    required this.onClose,
  });

  @override
  State<SlidingOverlayContainer> createState() =>
      _SlidingOverlayContainerState();
}

class _SlidingOverlayContainerState extends State<SlidingOverlayContainer> {
  AbsenceForm ab = AbsenceForm();
  final TextEditingController reasonController = TextEditingController();
  final TextEditingController moduleController = TextEditingController();
  final picker = ImagePicker();
  File? imageFile;
  final String id = "23926";

  Future<void> uploadAbsenceReason() async {
    setState(() {
      ab.isLoading = true;
    });

    try {
      final CollectionReference absenceReasons =
          FirebaseFirestore.instance.collection('absence_reasons');

      //upload image to firestore
      final storageReference = FirebaseStorage.instance
          .ref()
          .child('absencereasons/${DateTime.now().millisecondsSinceEpoch}.jpg');
      final uploadTask = storageReference.putFile(imageFile!);
      await uploadTask.whenComplete(() => null);
      String imageUrl = await storageReference.getDownloadURL();

      final String docId = "${id}_${DateTime.now().millisecondsSinceEpoch}";
      await absenceReasons.doc(docId).set({
        'studentID': id,
        'date': DateFormat('dd-MM-yy').format(DateTime.now()),
        'module': moduleController.text,
        'reason': reasonController.text,
        'supporting_documents': imageUrl,
      });
      setState(() {
        ab.isLoading = false;
      });

      moduleController.clear();
      reasonController.clear();
      imageFile = null;

      const SnackBar(
        content: Text('Submitted successfully'),
        duration: Duration(seconds: 3),
      );
    } catch (e) {
      setState(() {
        ab.isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please fill all fields'),
        duration: Duration(seconds: 3),
      ));
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeInOut,
      bottom:
          widget.isOpen ? 0 : -mobileDeviceHeight, // Change the value as needed
      left: 0,
      right: 0,
      height: mobileDeviceHeight * 0.4, // Change the height as needed
      child: Container(
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30)),
            color: const Color.fromARGB(255, 243, 243, 243),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                offset: const Offset(0, -2),
                blurRadius: 15,
                spreadRadius: 4,
              )
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 30, right: 30, top: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Submit reason for absence',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                      onPressed: widget.onClose,
                      icon: const Icon(Icons.arrow_drop_down_circle))
                ],
              ),
            ),
            const Divider(),
            SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: moduleController,
                      decoration:
                          const InputDecoration(labelText: 'Module Name'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter module name';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: reasonController,
                      decoration: const InputDecoration(
                          labelText: 'Reason for Absence (include date)'),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: mobileDeviceWidth * 0.4,
                          child: ElevatedButton(
                            onPressed: _pickImage,
                            child: const Text('attach image'),
                          ),
                        ),
                        SizedBox(
                          width: mobileDeviceWidth * 0.4,
                          child: ElevatedButton(
                            onPressed: uploadAbsenceReason,
                            child: const Text('Submit reason'),
                          ),
                        ),
                      ],
                    ),
                    if (imageFile != null)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Image loaded successfully'),
                          TextButton(
                              onPressed: () {
                                setState(() {
                                  imageFile = null;
                                });
                              },
                              child: const Text('Remove image'))
                        ],
                      ),
                    if (ab.isLoading)
                      const Center(child: CupertinoActivityIndicator())
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
