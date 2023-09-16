import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkOnboardingStatus();
    /*Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/home'); // Navigate to HomePage
    });*/
  }

  Future<void> checkOnboardingStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool seenOnboard = prefs.getBool('seenOnboard') ?? false;
    if (seenOnboard == true) {
      Future.delayed(const Duration(seconds: 3)).then((value) {
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/signin');
        }
      });
    } else {
      Future.delayed(const Duration(seconds: 4)).then((value) {
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/onboarding');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Image.asset(
              'assets/nreach.png',
              height: 80,
            ),
            const SizedBox(height: 50),
            const CupertinoActivityIndicator(),
            const Spacer(),
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Powered by ', style: TextStyle(color: Colors.grey)),
                  Text(
                    'Dart Squad',
                    style: TextStyle(
                      color: grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
