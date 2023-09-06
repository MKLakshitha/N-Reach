import 'package:flutter/material.dart';
import 'package:n_reach_nsbm/pages/add_paymentcard_page.dart';
import 'package:n_reach_nsbm/pages/nroad_page.dart';
import 'package:n_reach_nsbm/pages/transportation.dart';
import 'package:n_reach_nsbm/pages/wallet_page.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:url_launcher/url_launcher.dart';

import 'clubsearch.dart';
import 'group_enrollment.dart';
import 'home_page.dart';
import 'library.dart';
import 'medicalPage.dart';
import 'news_page.dart';
import 'sos.dart';
import 'time_table.dart';

class ExampleSidebarX extends StatelessWidget {
  const ExampleSidebarX({
    Key? key,
    required SidebarXController controller,
  })  : _controller = controller,
        super(key: key);

  final SidebarXController _controller;

  _launchURLCalendar() async {
    const url =
        'https://calendar.google.com/calendar/u/0?cid=MTVhNmEzNzY5NjNjNWMwM2FhMzdjZDk5Yzg2YzFlZDJhYmVmYjg3N2M3ODNmZGYzNjEwNjc1MmU3N2YzOWRmZkBncm91cC5jYWxlbmRhci5nb29nbGUuY29t';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchURLTimeTable() async {
    const url =
        'https://nsbm365-my.sharepoint.com/:x:/g/personal/mklakshitha_students_nsbm_ac_lk/EfBnmSSw4CJPnOLpHBcTN4wBp-2BHVg2U2GJP3ayWhyOCA?e=iiqeqW';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SidebarX(
      controller: _controller,
      theme: SidebarXTheme(
        margin: const EdgeInsets.all(0),
        padding: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: canvasColor,
          borderRadius: BorderRadius.circular(20),
        ),
        hoverColor: scaffoldBackgroundColor,
        textStyle: const TextStyle(
            color: Color.fromARGB(255, 38, 38, 38), fontSize: 18),
        selectedTextStyle: const TextStyle(
            color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        itemTextPadding: const EdgeInsets.only(left: 22),
        selectedItemTextPadding: const EdgeInsets.only(left: 22),
        //selectedItemDecoration: BoxDecoration(
        //borderRadius: BorderRadius.circular(10),
        //border: Border.all(
        //color: const Color.fromARGB(255, 52, 52, 52).withOpacity(0.37),
        //),
        //),
        iconTheme: IconThemeData(
          color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.7),
          size: 20,
        ),
        selectedIconTheme: const IconThemeData(
          color: Color.fromARGB(255, 52, 52, 52),
          size: 20,
        ),
      ),
      extendedTheme: SidebarXTheme(
        width: 300,
        padding: const EdgeInsets.only(bottom: 12),
        itemPadding: const EdgeInsets.only(top: 5, left: 20),
        selectedItemPadding: const EdgeInsets.only(top: 5, left: 20),
        decoration: BoxDecoration(
            color: canvasColor, borderRadius: BorderRadius.circular(20)),
      ),
      footerDivider: divider,
      /*footerBuilder: (context, extended) {
        return Container(
          //color: Colors.amber,
          //padding: const EdgeInsets.all(16),
          alignment: Alignment.center,
          child: const Text('Powered by Dart Squad'),
        );
      },*/
      /*headerBuilder: (context, extended) {
        return const SizedBox(
          // height: 100,
          child: Padding(
            padding: EdgeInsets.only(top: 10),
            //child: Text('Categories'),
            //child: Image.asset('assets/images/avatar.png'),
            child: Icon(Icons.menu),
          ),
        );
      },*/
      items: [
        //SidebarXItem()
        SidebarXItem(
          icon: Icons.arrow_back,
          label: 'Services',
          onTap: () {
            Scaffold.of(context).closeDrawer();
          },
        ),

        SidebarXItem(
          icon: Icons.home,
          label: 'Home',
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          },
        ),
        SidebarXItem(
          icon: Icons.emergency_share_sharp,
          label: 'Emergency Alert',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SOS()),
            );
          },
        ),
        SidebarXItem(
          icon: Icons.location_on,
          label: 'N-Map',
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MapPage()),
            );
          },
        ),
        SidebarXItem(
          icon: Icons.shopping_bag_rounded,
          label: 'NSBM Shop',
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MapPage()),
            );
          },
        ),
        SidebarXItem(
          icon: Icons.qr_code_2,
          label: 'QR Scanner',
          onTap: () {},
        ),
        SidebarXItem(
          icon: Icons.wallet,
          label: 'N-Wallet',
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const AddPaymentCardScreen()),
            );
          },
        ),
        SidebarXItem(
          icon: Icons.payments_outlined,
          label: 'Payments',
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const WalletPage()),
            );
          },
        ),
        SidebarXItem(
            icon: Icons.medical_services_outlined,
            label: 'Medical Appointments',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Medical()),
              );
            }),
        SidebarXItem(
          icon: Icons.people_sharp,
          label: 'Clubs',
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const SearchClub()),
            );
          },
        ),
        SidebarXItem(
          icon: Icons.table_view,
          label: 'Semester Timetable',
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const TimetablePage()),
            );
          },
        ),
        SidebarXItem(
          icon: Icons.local_library,
          label: 'Library',
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Library()),
            );
          },
        ),
        const SidebarXItem(
          icon: Icons.menu_book,
          label: 'Study Materials',
        ),
        const SidebarXItem(
          icon: Icons.apartment,
          label: 'Hostel',
        ),
        const SidebarXItem(
          icon: Icons.assignment,
          label: 'Examinations',
        ),
        SidebarXItem(
          icon: Icons.directions_bus_rounded,
          label: 'Transportation',
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Transportation()),
            );
          },
        ),
        const SidebarXItem(
          icon: Icons.food_bank,
          label: 'Food and canteen',
        ),
        SidebarXItem(
            icon: Icons.event_available,
            label: 'Events and Calender',
            onTap: () {
              _launchURLCalendar();
            }),
        SidebarXItem(
          icon: Icons.group_add_outlined,
          label: 'Batch Group',
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const BatchGroup()),
            );
          },
        ),
        SidebarXItem(
          icon: Icons.newspaper_outlined,
          label: 'Latest News',
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const NewsFeed()),
            );
          },
        ),
        SidebarXItem(
          icon: Icons.book,
          label: 'Magazine',
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const NewsFeed()),
            );
          },
        ),
        const SidebarXItem(
          icon: Icons.contact_support,
          label: 'Support',
        ),
        const SidebarXItem(
          icon: Icons.support_agent,
          label: 'Complaints',
        ),
      ],
    );
  }
}

class ScreensExample extends StatelessWidget {
  const ScreensExample({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final SidebarXController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final pageTitle = _getTitleByIndex(controller.selectedIndex);
        switch (controller.selectedIndex) {
          case 0:
            return ListView.builder(
              padding: const EdgeInsets.only(top: 10),
              itemBuilder: (context, index) => Container(
                height: 100,
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 10, right: 10, left: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  //color: Theme.of(context).canvasColor,
                  //boxShadow: const [BoxShadow()],
                ),
              ),
            );
          default:
            return Text(
              pageTitle,
              style: theme.textTheme.headlineSmall,
            );
        }
      },
    );
  }
}

String _getTitleByIndex(int index) {
  switch (index) {
    case 0:
      return 'Home';
    case 1:
      return 'Search';
    case 2:
      return 'People';
    case 3:
      return 'Favorites';
    case 4:
      return 'Custom iconWidget';
    case 5:
      return 'Profile';
    case 6:
      return 'Settings';
    default:
      return 'Not found page';
  }
}

const primaryColor = Color.fromARGB(255, 0, 0, 0);
const canvasColor = Color.fromARGB(255, 244, 244, 244);
const scaffoldBackgroundColor = Color(0xFF464667);
const accentCanvasColor = Color.fromARGB(255, 161, 161, 161);
const white = Colors.white;
final actionColor = const Color.fromARGB(255, 165, 165, 165).withOpacity(0.6);
final divider = Divider(color: Colors.black.withOpacity(0.3), height: 1);
