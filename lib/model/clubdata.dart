import 'package:cloud_firestore/cloud_firestore.dart';

class Club {
  final String logo;
  final String name;
  final String desc;
  final String abbreviation;
  final List<String> gallery;
  final List<String> events;
  final int members;
  final String cover;
  final List<String> quote;
  final List<String> topboard, topboardimages, contact;

  Club(
      {required this.logo,
      required this.name,
      required this.desc,
      required this.abbreviation,
      required this.gallery,
      required this.events,
      required this.members,
      required this.cover,
      required this.quote,
      required this.topboard,
      required this.topboardimages,
      required this.contact});

  factory Club.fromFirestore(Map<String, dynamic> data) {
    return Club(
        name: data['Name'] ?? '',
        logo: data['logo'] ?? '',
        desc: data['Description'] ?? '',
        abbreviation: data['abbr'] ?? '',
        gallery: List<String>.from(data['gallery'] ?? []),
        events: List<String>.from(data['events'] ?? []),
        members: data['Members'] ?? 0,
        cover: data['cover'] ?? '',
        quote: List<String>.from(data['quotes'] ?? []),
        topboard: List<String>.from(data['topboard'] ?? []),
        topboardimages: List<String>.from(data['topboardimgs'] ?? []),
        contact: List<String>.from(data['contact'] ?? []));
  }
}

Future<List<Club>> fetchClubByName(String name) async {
  try {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('clubs')
        .where('abbr', isEqualTo: name)
        .get();

    List<Club> clubs = snapshot.docs.map((doc) {
      return Club.fromFirestore(doc.data() as Map<String, dynamic>);
    }).toList();

    return clubs;
  } catch (e) {
    print('Error fetching club data by name: $e');
    return [];
  }
}

Future<List<Club>> fetchClubs() async {
  try {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('clubs').get();

    List<Club> clubs = snapshot.docs.map((doc) {
      return Club.fromFirestore(doc.data() as Map<String, dynamic>);
    }).toList();

    return clubs;
  } catch (e) {
    print('Error fetching club data by name: $e');
    return [];
  }
}

Future<List<String>> fetchClubNames() async {
  try {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('clubs').get();

    List<String> clubNames = snapshot.docs.map((doc) {
      return doc['name'] as String;
    }).toList();

    return clubNames;
  } catch (e) {
    print('Error fetching club names: $e');
    return [];
  }
}
