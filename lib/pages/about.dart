import 'package:flutter/material.dart';
import 'constants.dart';
import 'btmnavbar.dart';
import 'package:url_launcher/url_launcher.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0),
      ),
      bottomNavigationBar:
          BtmNavBar(currentIndex: 2, onItemSelected: (int n) {}),
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
              padding: EdgeInsets.only(
                  top: mobileDeviceWidth * 0.04,
                  left: mobileDeviceWidth * 0.04,
                  right: mobileDeviceWidth * 0.04),
              child: Column(
                children: [
                  Text(
                    'NSBM Green University',
                    style: TextStyle(
                        fontSize: mobileDeviceWidth < 370 ? 23 : 26,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const Text(
                    '100% Government owned global level university',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                    textAlign: TextAlign.center,
                  ),
                  Divider(
                    indent: mobileDeviceWidth * 0.05,
                    endIndent: mobileDeviceWidth * 0.05,
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(mobileDeviceWidth * 0.04),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(mobileDeviceWidth * 0.05),
                    width: mobileDeviceWidth,
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 240, 240, 240),
                        borderRadius: BorderRadius.circular(20)),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Our Vision',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'To be Sri Lanka’s best-performing graduate school and to be recognized internationally.',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                  const Divider(),
                  Container(
                    padding: EdgeInsets.all(mobileDeviceWidth * 0.05),
                    width: mobileDeviceWidth,
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 240, 240, 240),
                        borderRadius: BorderRadius.circular(20)),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Our Mision',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'To develop globally competitive and responsible graduates that businesses demand, working in synergy with all our stakeholders and contributing to our society.',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                  const Divider(),
                  const Text(
                    'Get connected with NSBM on socials\n',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          // ignore: deprecated_member_use
                          if (await canLaunch(
                              'https://www.instagram.com/nsbmgreenuniversity')) {
                            // ignore: deprecated_member_use
                            await launch(
                                'https://www.instagram.com/nsbmgreenuniversity');
                          } else {
                            throw 'Could not launch https://www.instagram.com/nsbmgreenuniversity';
                          }
                        },
                        child: Image.asset('assets/inst.png',
                            height: mobileDeviceHeight * 0.07),
                      ),
                      GestureDetector(
                        onTap: () async {
                          // ignore: deprecated_member_use
                          if (await canLaunch(
                              'https://web.facebook.com/nsbm.lk')) {
                            // ignore: deprecated_member_use
                            await launch('https://web.facebook.com/nsbm.lk');
                          } else {
                            throw 'Could not launch https://web.facebook.com/nsbm.lk';
                          }
                        },
                        child: Image.asset('assets/fb.png',
                            height: mobileDeviceHeight * 0.07),
                      ),
                      GestureDetector(
                        onTap: () async {
                          // ignore: deprecated_member_use
                          if (await canLaunch('https://www.nsbm.ac.lk')) {
                            // ignore: deprecated_member_use
                            await launch('https://www.nsbm.ac.lk');
                          } else {
                            throw 'Could not launch https://www.nsbm.ac.lk';
                          }
                        },
                        child: Image.asset('assets/web.png',
                            height: mobileDeviceHeight * 0.07),
                      )
                    ],
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
