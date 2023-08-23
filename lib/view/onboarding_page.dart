import 'package:flutter/material.dart';
import 'package:n_reach_nsbm/app_styles.dart';
import 'package:n_reach_nsbm/main.dart';
import 'package:n_reach_nsbm/model/onboard_data.dart';
import 'package:n_reach_nsbm/size_config.dart';
import 'package:n_reach_nsbm/view/signup_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      height: 12,
      width: 12,
      decoration: BoxDecoration(
        color: currentPage == index ? kThemeColor : kSecondaryColor,
        shape: BoxShape.circle,
      ),
    );
  }

  Future setSeenonboard() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    seenOnboard = await prefs.setBool('seenOnboard', true);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double sizeH = SizeConfig.blockSizeH!;
    double sizeV = SizeConfig.blockSizeV!;
    return Scaffold(
      //initialize Size Config
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Column(
        children: [
          Expanded(
              flex: 9,
              child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (value) {
                    setState(() {
                      currentPage = value;
                    });
                  },
                  itemCount: OnBoardingContents.length,
                  itemBuilder: (context, index) => Column(
                        children: [
                          SizedBox(
                            height: sizeV * 7,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              OnBoardingContents[index].title,
                              style: kTitle,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(
                            height: sizeV * 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              height: sizeV * 60,
                              child: Image.asset(
                                OnBoardingContents[index].image,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: sizeV * 9,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              OnBoardingContents[index].description,
                              style: kBodyText,
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      ))),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                currentPage == OnBoardingContents.length - 1
                    ? GetStartedBtn(
                        buttonName: 'Get Started',
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignupPage()));
                        },
                        bgColor: kThemeColor,
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          OnBoardNavBtn(
                            name: 'Skip',
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const SignupPage()));
                            },
                          ),
                          Row(
                            children: List.generate(OnBoardingContents.length,
                                (index) => dotIndicator(index)),
                          ),
                          OnBoardNavBtn(
                              name: 'Next',
                              onPressed: () {
                                _pageController.nextPage(
                                    duration: const Duration(microseconds: 400),
                                    curve: Curves.easeInOut);
                              })
                        ],
                      ),
              ],
            ),
          ),
        ],
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
      splashColor: Colors.green,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text(
          name,
          style: kBodyText,
        ),
      ),
    );
  }
}
