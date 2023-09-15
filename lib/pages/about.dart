import 'package:flutter/material.dart';
import 'package:simple_flutter_app/constants/constants.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0),
        title: const Text(
          'hi',
          style: blackText,
        ),
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              'assets/about.jpg',
              height: mobileDeviceHeight * 0.38,
              width: mobileDeviceWidth,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: EdgeInsets.all(mobileDeviceWidth * 0.04),
              child: Column(
                children: [
                  const Text(
                    'NSBM Green University',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  Divider(
                    indent: mobileDeviceWidth * 0.05,
                    endIndent: mobileDeviceWidth * 0.05,
                  ),
                  const Text(
                    '100% Government owned global level university',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(mobileDeviceWidth * 0.04),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(mobileDeviceWidth * 0.03),
                    width: mobileDeviceWidth,
                    color: const Color.fromARGB(255, 209, 209, 209),
                    child: const Column(),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
