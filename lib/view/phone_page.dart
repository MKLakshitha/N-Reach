import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'constants/constants.dart';
import 'otp_page.dart';
import 'signinpage.dart';

class PhoneNumberInputScreen extends StatelessWidget {
  final TextEditingController _phoneNumberController = TextEditingController();

  PhoneNumberInputScreen({Key? key}) : super(key: key);

  void _navigateToOtpScreen(BuildContext context, String verificationId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OtpScreen(
          phoneNumber: _phoneNumberController.text,
          verificationId: verificationId,
        ),
      ),
    );
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

  Future<void> _sendOtp(BuildContext context) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    final String phoneNumber =
        '+94${_phoneNumberController.text}'; // Modify as per your country code

    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
        print('Phone verification failed: ${e.message}');
      },
      codeSent: (String verificationId, int? resendToken) {
        _navigateToOtpScreen(context, verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    //width: mobileDeviceWidth * 0.5,
                    height: mobileDeviceHeight * 0.09,
                    child: Image.asset('assets/nsbmlogo.png'),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  SizedBox(
                    //width: mobileDeviceWidth * 0.5,
                    height: mobileDeviceHeight * 0.08,
                    child: Image.asset('assets/nreach.png'),
                  ),
                ],
              ),
              SizedBox(height: mobileDeviceHeight * 0.036),
              const Text(
                'Welcome to NReach, NSBM’s first mobile application.\nExplore our app as a guest user and enjoy access to some of our exciting features.',
                style: TextStyle(fontFamily: 'DM Sans', fontSize: 12),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: mobileDeviceHeight * 0.1),
              const Text(
                'To get started, enter your mobile number',
                style: TextStyle(fontFamily: 'DM Sans', fontSize: 12),
              ),
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
                  controller: _phoneNumberController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(8),
                      labelStyle: const TextStyle(fontSize: 14),
                      labelText: 'ex:- 0771234567',
                      prefixIcon: const Icon(Icons.phone),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none),
                      filled: true,
                      fillColor: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
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
                child: ElevatedButton(
                  onPressed: () => _sendOtp(context),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: const Color.fromARGB(255, 50, 150, 113),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Recieve an OTP',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
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
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Already a registered user? ',
                        style: TextStyle(fontSize: 13, color: grey)),
                    Text(
                      'Login',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                          color: grey),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: GestureDetector(
              onTap: () {
                _showEmailSnackbar('Email: nreach@gmail.com', context);
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Trouble signing in? ',
                      style: TextStyle(fontSize: 13, color: Colors.grey)),
                  Text(
                    'Contact us',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                        color: Colors.black),
                  )
                ],
              ),
            ),
          ),
        )
      ]),
    );
  }
}
