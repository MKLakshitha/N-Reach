import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String userUid = '';
  var verId = '';
  int? resendTokenId;
  bool phoneAuthCheck = false;
  dynamic credentials;
  String? currentUserUMISID;
  var isProfileUploading = false.obs;

  bool isLoginAsDriver = false;

  // In your AuthController class
  storeUserCard(String number, String expiry, String cvv, String name) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('cards')
        .add({'name': name, 'number': number, 'cvv': cvv, 'expiry': expiry});

    return true;
  }

  RxList userCards = [].obs;

  getUserCards() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('cards')
        .snapshots()
        .listen((event) {
      userCards.value = event.docs;
    });
  }

  setCurrentUserUMISID() async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot userSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      currentUserUMISID = userSnapshot.get('UMIS_ID');
      update(); // Update the UI
    } catch (e) {
      print('Error fetching UMIS_ID: $e');
    }
  }
}
