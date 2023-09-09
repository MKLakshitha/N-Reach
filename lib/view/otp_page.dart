import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_flutter_app/pages/home_page.dart';

import 'constants/constants.dart';
import 'signinpage.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;
  final String verificationId;

  const OtpScreen(
      {Key? key, required this.phoneNumber, required this.verificationId})
      : super(key: key);

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _otpController = TextEditingController();

  void _navigateToHome(BuildContext context) {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => const HomePage()));
  }

  void _showEmailSnackbar(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.email, color: Color.fromARGB(255, 251, 251, 251)),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          Clipboard.setData(
                              const ClipboardData(text: 'nreach@gmail.com'));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Email copied to clipboard'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        child: Text(
                          'Copy Email',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary),
                        ),
                      ),
                      const SizedBox(width: 8),
                      TextButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        },
                        child: Text(
                          'Done',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: const Color.fromARGB(221, 50, 50, 50),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _verifyOtp() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    try {
      AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: _otpController.text,
      );

      await auth.signInWithCredential(credential);

      _navigateToHome(context);
    } catch (e) {
      print('Error verifying OTP: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(children: [
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            height: mobileDeviceWidth * 0.43,
            width: mobileDeviceWidth,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/circle3.png'), fit: BoxFit.fill),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: mobileDeviceHeight * 0.09,
                    child: Image.asset('assets/nsbmlogo.png'),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  SizedBox(
                    height: mobileDeviceHeight * 0.08,
                    child: Image.asset('assets/nreach.png'),
                  ),
                ],
              ),
              SizedBox(height: mobileDeviceHeight * 0.036),
              const Text(
                'Welcome to NReach, NSBM’s first mobile application. Explore our app as a guest user and enjoy access to some of our exciting features.',
                style: TextStyle(fontFamily: 'DM Sans', fontSize: 12),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 60),
              Text('Enter the OTP sent to ${widget.phoneNumber}',
                  style: const TextStyle(fontFamily: 'DM Sans', fontSize: 12)),
              const SizedBox(height: 10),
              Container(
                width: mobileDeviceWidth * 0.87,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5), // Shadow color
                      spreadRadius: -4, // Spread radius
                      blurRadius: 8, // Blur radius
                      offset: const Offset(0, 1), // Offset
                    ),
                  ],
                ),
                child: TextField(
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: 'Enter OTP Number ',
                      labelStyle: const TextStyle(fontSize: 14),
                      contentPadding: const EdgeInsets.all(8),
                      prefixIcon: const Icon(Icons.phone),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none),
                      filled: true,
                      fillColor: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _verifyOtp(),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: const Color.fromARGB(255, 50, 150, 113),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Validate OTP and Proceed',
                      style: TextStyle(fontFamily: 'DM Sans', fontSize: 14)),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignInPage()),
                  );
                },
                child: const Center(
                  child: Text('Already a registered User? Click here',
                      style: TextStyle(fontSize: 12, fontFamily: 'DM Sans')),
                ),
              ),
              GestureDetector(
                onTap: () {
                  _showEmailSnackbar('Email: nreach@gmail.com', context);
                },
                child: const Center(
                  child: Text('Having trouble? Contact us',
                      style: TextStyle(fontSize: 12, fontFamily: 'DM Sans')),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
