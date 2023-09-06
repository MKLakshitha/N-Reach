import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:n_reach_nsbm/pages/home_page.dart';
import 'package:n_reach_nsbm/pages/nroad_page.dart';
import 'package:n_reach_nsbm/pages/profile_page.dart';
import 'package:n_reach_nsbm/pages/sos.dart';
import 'package:n_reach_nsbm/pages/splash_screen.dart';
import 'package:n_reach_nsbm/view/onboarding_page.dart';
import 'package:n_reach_nsbm/view/phone_page.dart';
import 'package:n_reach_nsbm/view/signin_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/constants.dart';
import 'pages/wallet_page.dart';
import 'view/signup_page.dart';

bool? seenOnboard;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  seenOnboard = prefs.getBool('seenOnboard') ?? false;
  Stripe.publishableKey =
      'pk_test_51NkLR4LO1mW4ni4muH7miIdwvWaYhAAN8GnZhza9gJjNh2LamyPIsWojEysf7udLC2QLgGV7HsjinosD3Si1GGpZ00xflWcMFE';
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    mobileDeviceWidth = MediaQuery.of(context).size.width;
    mobileDeviceHeight = MediaQuery.of(context).size.height;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'N-Reach',
      theme: ThemeData(
        textTheme: GoogleFonts.manropeTextTheme(
          Theme.of(context).textTheme,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green, // Set the default color here
          ),
        ),
        fontFamily: 'DM Sans',
        appBarTheme: const AppBarTheme(
            titleSpacing: 1.0,
            //titleTextStyle: TextStyle(color: Colors.black),
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(
              color: Colors.black, // Change the color of the leading icon here
            ),
            elevation: 0),
      ),
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      darkTheme: ThemeData.dark(),
      initialRoute: '/',
      routes: {
        '/': (context) {
          return const SplashScreen();
        },
        '/signin': (context) => const SignInPage(),
        '/signup': (context) => const SignupPage(),
        '/home': (context) => const HomePage(),
        '/profile': (context) => const ProfilePage(),
        '/onboarding': (context) {
          // Save to SharedPreferences
          return const OnBoardingPage();
        },
        '/phone': (context) => PhoneNumberInputScreen(),
        '/map': (context) => const MapPage(),
        '/sos': (context) => const SOS(),
        '/payment': (context) => const WalletPage(),
      },
    );
  }
}
