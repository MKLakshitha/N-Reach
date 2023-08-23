import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 3)).then((value) {
      Navigator.pushReplacementNamed(context, ('/onboarding'));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Expanded(
            flex: 7,
            child: SizedBox(
              width: double.infinity,
              child: SizedBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                      image: AssetImage('assets/nreach.png'),
                      width: 200,
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    SpinKitWave(
                      color: Color.fromARGB(255, 6, 145, 77),
                      size: 30.0,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  Text('Powered By',
                      style: GoogleFonts.dmSans(
                        textStyle: Theme.of(context).textTheme.displayLarge,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      )),
                  Text('Team Dart Squad',
                      style: GoogleFonts.dmSans(
                        textStyle: Theme.of(context).textTheme.displayLarge,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      )),
                  Text('Copyright © 2023 All right reserved.',
                      style: GoogleFonts.dmSans(
                        textStyle: Theme.of(context).textTheme.displayLarge,
                        fontSize: 7,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.italic,
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
