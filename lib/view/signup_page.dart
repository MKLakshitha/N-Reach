import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'constants/constants.dart';
import 'signinpage.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  Future<void> _signup() async {
    try {
      if (_passwordController.text == _confirmPasswordController.text) {
        final result = await _auth.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        // ignore: unnecessary_null_comparison
        if (result != null) {
          final user = result.user!;

          // Use Firestore to create the user document with auto-generated ID
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set({
            'Degree': '',
            'Faculty': '',
            'Intake': '',
            'NIC': '',
            'UMIS_ID': '',
            'Username': '',
            'created_time': FieldValue.serverTimestamp(),
            'display_name': '',
            'email': user.email,
            'offered_by': '',
            'personal_email': '',
            'phone_number': '',
            'photo_url':
                'https://firebasestorage.googleapis.com/v0/b/nreach-b8dee.appspot.com/o/images%2Fdefault-user.png?alt=media&token=5f3c17ce-78e4-403d-b2c3-d92829876316',
            'uid': user.uid,
            'github_link': '',
            'linkedin_link': '',
          });

          _showSuccessSnackbar();
          Future.delayed(const Duration(seconds: 2), () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const SignInPage()),
            );
          });
        } else {
          _showErrorSnackbar('An error occurred during registration.');
        }
      } else {
        _showErrorSnackbar('Please make sure passwords match.');
      }
    } catch (e) {
      _showErrorSnackbar(e.toString());
    }
  }

  void _showEmailSnackbar(String message) {
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
                              content: Text(
                                'Email copied to clipboard',
                                style: TextStyle(
                                    fontSize: 16, fontFamily: 'DM Sans'),
                              ),
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

  void _showSuccessSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Color.fromARGB(255, 255, 255, 255)),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Registration successful!',
                style: TextStyle(fontSize: 16, fontFamily: 'DM Sans'),
              ),
            ),
          ],
        ),
        backgroundColor: Color.fromARGB(221, 55, 103, 15),
        duration: Duration(seconds: 2),
      ),
    );

    // Delayed navigation after the SnackBar is shown
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignInPage()),
      );
    });
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Color.fromARGB(255, 255, 255, 255)),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
        backgroundColor: const Color.fromARGB(221, 238, 106, 106),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.white,
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
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: mobileDeviceHeight * 0.15),
            Container(
              height: mobileDeviceWidth * 0.25,
              decoration: const BoxDecoration(
                image:
                    DecorationImage(image: AssetImage('assets/nsbmlogo.png')),
              ),
            ),
            SizedBox(height: mobileDeviceHeight * 0.03),
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
              child: TextFormField(
                style: const TextStyle(fontSize: 14),
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(8),
                    labelText: 'Enter email',
                    labelStyle: const TextStyle(fontSize: 14),
                    prefixIcon: const Icon(Icons.email),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none),
                    filled: true,
                    fillColor: Colors.white),
              ),
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
              child: TextFormField(
                style: const TextStyle(fontSize: 14),
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                    labelText: 'Password',
                    contentPadding: const EdgeInsets.all(8),
                    labelStyle: const TextStyle(fontSize: 14),
                    prefixIcon: const Icon(Icons.lock),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none),
                    filled: true,
                    fillColor: Colors.white),
              ),
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
              child: TextFormField(
                style: const TextStyle(fontSize: 14),
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                    labelText: 'Confirm password',
                    contentPadding: const EdgeInsets.all(8),
                    labelStyle: const TextStyle(fontSize: 14),
                    prefixIcon: const Icon(Icons.lock),
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
                onPressed: _signup,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: const Color.fromARGB(255, 50, 150, 113),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Sign up',
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignInPage()),
                  );
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Already have an account? ',
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
            ),
            const SizedBox(height: 50),
          ],
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: GestureDetector(
              onTap: () {
                _showEmailSnackbar('Email: nreach@gmail.com');
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Trouble signing in? ',
                      style: TextStyle(fontSize: 13, color: grey)),
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
