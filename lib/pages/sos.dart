import 'package:flutter/material.dart';
import 'package:n_reach_nsbm/pages/btmnavbar.dart';
import 'package:n_reach_nsbm/pages/sidebar.dart';

class SOS extends StatelessWidget {
  const SOS({Key? key}) : super(key: key);

  void _onItemTapped(int index) {}

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            'Emergency Alert',
            style: TextStyle(color: primaryColor),
          ),
          titleSpacing: 1.0,
          automaticallyImplyLeading: true,
          backgroundColor: white,
          iconTheme: const IconThemeData(
            color: Colors.black, // Change the color of the leading icon here
          ),
          elevation: 0),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(width * 0.03),
          child: Column(
            children: [
              const Text(
                'Alert our security members and get assistance immediately, if not responded within 5 minutes, use the call button to get in contact with our security.',
                style: TextStyle(
                    fontSize: 8, color: Color.fromARGB(255, 144, 144, 144)),
              ),
              SizedBox(height: width * 0.027),
              Row(
                children: [
                  sosCards(
                    width * 0.45,
                    width * 0.27,
                    'assets/sos1.png',
                    'Medical Emergency',
                  ),
                  SizedBox(width: width * 0.027),
                  sosCards(
                    width * 0.45,
                    width * 0.27,
                    'assets/sos2.png',
                    'Fire and Hazards',
                  ),
                ],
              ),
              SizedBox(height: width * 0.027),
              Row(
                children: [
                  sosCards(
                    width * 0.45,
                    width * 0.27,
                    'assets/sos3.png',
                    'Security Breaches and Thefts',
                  ),
                  SizedBox(width: width * 0.027),
                  sosCards(
                    width * 0.45,
                    width * 0.27,
                    'assets/sos4.png',
                    'Natural Disasters',
                  ),
                ],
              ),
              SizedBox(height: width * 0.027),
              Row(
                children: [
                  sosCards(
                    width * 0.45,
                    width * 0.27,
                    'assets/sos5.png',
                    'Mental Health Crisis',
                  ),
                  SizedBox(width: width * 0.027),
                  sosCards(
                    width * 0.45,
                    width * 0.27,
                    'assets/sos6.png',
                    'Personal safety',
                  ),
                ],
              ),
              SizedBox(height: width * 0.027),
              sosCards2(
                  width * 1,
                  width * 0.21,
                  'assets/sos7.png',
                  'Personal Escort',
                  'Request security assistance to walk out when its too late or dark'),
              SizedBox(height: width * 0.027),
              sosCards2(width * 1, width * 0.21, 'assets/sos8.png',
                  'Emergency Call', 'Call for security support via app '),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BtmNavBar(
        currentIndex: 0,
        onItemSelected: _onItemTapped,
      ),
    );
  }

  Container sosCards(
    double width,
    double height,
    String imgUrls,
    String sosMessage,
  ) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      padding: const EdgeInsets.only(left: 20, right: 10),
      decoration: BoxDecoration(
        color: Colors.white30,
        borderRadius: BorderRadius.circular(14),
        image: DecorationImage(
          image: AssetImage(imgUrls),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(
                0.2), // Adjust the opacity value (0.0 to 1.0) to control brightness
            BlendMode
                .darken, // Use BlendMode.darken to make the image darker, BlendMode.lighten to make it brighter
          ),
        ),
        boxShadow: [shadowcard()],
      ),
      child: Text(
        sosMessage,
        //textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: [
            Shadow(
              offset: Offset(1.5, 1.5),
              color: Color.fromARGB(120, 0, 0, 0),
              blurRadius: 3.0,
            ),
          ],
        ),
      ),
    );
  }

  Container sosCards2(double width, double height, String imgUrls,
      String sosMessage, String sosSubMessage) {
    return Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        padding: const EdgeInsets.only(left: 20, right: 10),
        decoration: BoxDecoration(
          color: Colors.white30,
          borderRadius: BorderRadius.circular(14),
          image: DecorationImage(
            image: AssetImage(imgUrls),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(
                  0.2), // Adjust the opacity value (0.0 to 1.0) to control brightness
              BlendMode
                  .darken, // Use BlendMode.darken to make the image darker, BlendMode.lighten to make it brighter
            ),
          ),
          boxShadow: [shadowcard()],
        ),
        child: Stack(alignment: Alignment.center, children: [
          Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // Vertically centers the content
            children: [
              Text(
                sosMessage,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      offset: Offset(1.5, 1.5),
                      color: Color.fromARGB(120, 0, 0, 0),
                      blurRadius: 3.0,
                    ),
                  ],
                ),
              ),
              Text(
                sosSubMessage,
                style: const TextStyle(
                  fontSize: 9,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      offset: Offset(1.5, 1.5),
                      color: Color.fromARGB(120, 0, 0, 0),
                      blurRadius: 3.0,
                    ),
                  ],
                ),
              )
            ],
          )
        ]));
  }

  BoxShadow shadowcard() {
    return BoxShadow(
      color:
          const Color.fromARGB(255, 0, 0, 0).withOpacity(0.25), // Shadow color
      spreadRadius: -1, // How much the shadow should spread
      blurRadius: 6, // How blurry the shadow should be
      offset: const Offset(0, 4), // Offset from the container
    );
  }
}
