import 'package:flutter/material.dart';

class BtmNavBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onItemSelected;

  const BtmNavBar({
    Key? key,
    required this.currentIndex,
    required this.onItemSelected,
  }) : super(key: key);

  @override
  State<BtmNavBar> createState() => _BtmNavBarState();
}

class _BtmNavBarState extends State<BtmNavBar> {
  @override
  Widget build(BuildContext context) {
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
      currentIndex: widget.currentIndex,
      selectedItemColor: Colors.black,
      selectedIconTheme: const IconThemeData(
        color: Colors.blue,
      ),
      unselectedItemColor: const Color.fromARGB(255, 146, 146, 146),
      showUnselectedLabels: false,
      showSelectedLabels: false,
      onTap: (int index) {
        // Navigate to the desired page
        if (index == 0) {
          Navigator.pushNamed(context, '/sos');
        } else if (index == 1) {
          Navigator.pushNamed(context, '/map');
        } else if (index == 2) {
          Navigator.pushNamed(context, '/home');
        } else if (index == 3) {
          Navigator.pushNamed(context, '/payment');
        } else if (index == 4) {
          Navigator.pushNamed(context, '/profile');
        }
        widget.onItemSelected(index);
      },
    );
  }
}
