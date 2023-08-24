import 'package:flutter/material.dart';

class BtmNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onItemSelected;

  const BtmNavBar({
    Key? key,
    required this.currentIndex,
    required this.onItemSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //print('BtmNavBar rebuild with index: $currentIndex');
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: <BottomNavigationBarItem>[
        const BottomNavigationBarItem(
          icon: Icon(Icons.sos),
          label: 'SOS',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.location_on),
          label: 'GPS',
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            "assets/nreach.png",
            width: 30,
            height: 30,
          ),
          label: 'Home',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.payment),
          label: 'Payment',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
      iconSize: 28,
      currentIndex: currentIndex,
      selectedItemColor: Colors.black,
      selectedIconTheme: const IconThemeData(
        color: Colors.blue,
      ),
      unselectedItemColor: const Color.fromARGB(255, 146, 146, 146),
      showUnselectedLabels: false,
      showSelectedLabels: false,
    );
  }
}
