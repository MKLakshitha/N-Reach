import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants/constants.dart';
import 'onboarddata.dart';
import 'size_config.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  int currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);
  AnimatedContainer dotIndicator(index) {
    return AnimatedContainer(
      margin: const EdgeInsets.only(right: 5),
      duration: const Duration(microseconds: 400),
      height: 8,
      width: 8,
      decoration: BoxDecoration(
        color: currentPage == index ? buttonColor : grey,
        shape: BoxShape.circle,
      ),
    );
  }

  Future<void> _markOnboardingSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenOnboard', true);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      //initialize Size Config
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
                flex: 7,
                child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (value) {
                      setState(() {
                        currentPage = value;
                      });
                    },
                    itemCount: OnBoardingContents.length,
                    itemBuilder: (context, index) => Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(28.0),
                              child: SizedBox(
                                height: 200,
                                child: Image.asset(
                                  OnBoardingContents[index].image,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                OnBoardingContents[index].title,
                                style: const TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Text(
                              OnBoardingContents[index].description,
                              style: const TextStyle(fontSize: 13),
                              textAlign: TextAlign.center,
                            )
                          ],
                        ))),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(OnBoardingContents.length,
                          (index) => dotIndicator(index)),
                    ),
                  ),
                  currentPage == OnBoardingContents.length - 1
                      ? Container(
                          width: mobileDeviceWidth * 0.87,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey
                                    .withOpacity(0.5), // Shadow color
                                spreadRadius: -4, // Spread radius
                                blurRadius: 8, // Blur radius
                                offset: const Offset(0, 1), // Offset
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: () async {
                              await _markOnboardingSeen();
                              Navigator.pushReplacementNamed(
                                  context, '/signup');
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              backgroundColor:
                                  const Color.fromARGB(255, 50, 150, 113),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text('Get Started',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w600)),
                          ),
                        )
                      : Container(
                          width: mobileDeviceWidth * 0.87,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey
                                    .withOpacity(0.5), // Shadow color
                                spreadRadius: -4, // Spread radius
                                blurRadius: 8, // Blur radius
                                offset: const Offset(0, 1), // Offset
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              _pageController.nextPage(
                                  duration: const Duration(microseconds: 400),
                                  curve: Curves.easeInOut);
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              backgroundColor:
                                  const Color.fromARGB(255, 50, 150, 113),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text('Next',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w600)),
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }
}

class GetStartedBtn extends StatelessWidget {
  const GetStartedBtn({
    super.key,
    required this.buttonName,
    required this.onPressed,
    required this.bgColor,
  });
  final String buttonName;
  final VoidCallback onPressed;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0, left: 20.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
              backgroundColor: bgColor,
              textStyle:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          child: Text(buttonName),
        ),
      ),
    );
  }
}

class OnBoardNavBtn extends StatelessWidget {
  const OnBoardNavBtn({
    super.key,
    required this.name,
    required this.onPressed,
  });
  final String name;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(6),
      splashColor: buttonColor,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text(
          name,
          style: const TextStyle(fontSize: 12),
        ),
      ),
    );
  }
}
