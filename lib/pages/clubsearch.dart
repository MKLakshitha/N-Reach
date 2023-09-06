import 'package:flutter/material.dart';
import 'package:n_reach_nsbm/pages/sidebar.dart';

import '../components/constants.dart';
import '../model/clubdata.dart';
import 'btmnavbar.dart';
import 'clubs.dart';

class SearchClub extends StatefulWidget {
  const SearchClub({super.key});

  @override
  State<SearchClub> createState() => _SearchClubState();
}

class _SearchClubState extends State<SearchClub> {
  final TextEditingController _searchController = TextEditingController();
  List<Club> filteredClubs = [];
  final Future<List<Club>> futureClubs = fetchClubs();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    //futureClubs = fetchClubs();
  }

  void filterClubs(String query) async {
    List<Club> allClubs = await futureClubs; // Wait for the future to complete
    setState(() {
      filteredClubs = allClubs.where((club) {
        final clubName = club.name.replaceAll(' ', '').toLowerCase();
        final clubAbbreviation =
            club.abbreviation.replaceAll(' ', '').toLowerCase();
        final lowercaseQuery = query.replaceAll(' ', '').toLowerCase();

        return clubName.contains(lowercaseQuery) ||
            clubAbbreviation.contains(lowercaseQuery);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Clubs at NSBM',
            style: blackText,
          ),
        ),
        bottomNavigationBar:
            BtmNavBar(currentIndex: 2, onItemSelected: onItemSelected),
        body: Container(
          color: white,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(
                  left: mobileDeviceWidth * 0.05,
                  right: mobileDeviceWidth * 0.05,
                  top: mobileDeviceWidth * 0.01,
                  bottom: mobileDeviceWidth * 0.02,
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Search clubs...',
                    suffixIcon: Icon(
                      Icons.search,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(40),
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    filterClubs(value);
                  },
                ),
              ),
              Container(
                  alignment: Alignment.topRight,
                  padding: EdgeInsets.only(
                    right: mobileDeviceWidth * 0.05,
                  ),
                  child: const Text(
                    'Sorted by popularity',
                    style: greyText,
                  )),
              FutureBuilder<List<Club>>(
                  future: fetchClubs(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox(
                        height: 100,
                        width: 100,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    if (snapshot.hasError) {
                      print(snapshot.error);
                      return const Center(
                          child: Text(
                              'There was an error retrieving clubs, please try again later.'));
                    }
                    if (snapshot.hasData) {
                      List<Club> clubs = snapshot.data!;
                      List<Club> clubsToDisplay =
                          filteredClubs.isNotEmpty ? filteredClubs : clubs;

                      if (clubsToDisplay.isEmpty) {
                        return const Center(
                            child: Text(
                          'Sorry, we are updating our database. Please wait till we complete the maintenance. Thank you for your patience',
                          textAlign: TextAlign.justify,
                        ));
                      }
                      return Expanded(
                        child: GridView.builder(
                          padding: EdgeInsets.all(mobileDeviceWidth * 0.05),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: mobileDeviceWidth *
                                0.03, // Horizontal spacing between grid items
                            mainAxisSpacing: mobileDeviceWidth * 0.03,
                          ),
                          itemCount: clubsToDisplay.length,
                          itemBuilder: (context, index) {
                            bool hasValidLogo =
                                clubsToDisplay[index].logo != '' &&
                                    clubsToDisplay[index].logo.isNotEmpty;

                            return GestureDetector(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Clubs(
                                          clubName: clubsToDisplay[index]
                                              .abbreviation))),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      mobileDeviceWidth *
                                          0.025), // Rounded corners
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      mobileDeviceWidth * 0.025),
                                  child: hasValidLogo
                                      ? Image.network(
                                          clubsToDisplay[index].logo,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            //print(error);
                                            return Container(
                                              color: Colors.grey,
                                              height: 80,
                                              width: 100,
                                              child: const Center(
                                                  child: Text('No image')),
                                            );
                                          },
                                        )
                                      : Container(
                                          color: Colors
                                              .grey, // Grey container when no logo URL is available
                                          height: 100,
                                          width: 100,
                                          child: const Center(
                                              child: Text('No image',
                                                  style: TextStyle(
                                                      color: white)))),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }
                    return const Padding(
                      padding: EdgeInsets.only(top: 160, left: 8, right: 8),
                      child: Center(
                          child: Text(
                        'Database under maintenance. Thank you for your patience',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.blue),
                      )),
                    );
                  }),
            ],
          ),
        ));
  }

  onItemSelected(int p1) {}
}
