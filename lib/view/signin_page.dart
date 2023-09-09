import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:simple_flutter_app/constants/constants.dart';
import 'package:url_launcher/url_launcher.dart';

import 'pages/home_page.dart';
import 'phone_page.dart';
import 'signup_page.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool checked = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FlutterAppAuth _appAuth = const FlutterAppAuth();
  bool _isMicrosoftSignInInProgress = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  Future<void> _signInWithMicrosoft(BuildContext context) async {
    final authorizationEndpoint = Uri.parse(
        "https://login.microsoftonline.com/common/oauth2/v2.0/authorize"
        "?client_id=de5f72a7-d8de-4d44-84ec-ce0f2be4d9f2"
        "&response_type=code"
        "&redirect_uri=msauth.nreachnsbm://auth"
        "&scope=openid%20profile%20email");

    if (await canLaunch(authorizationEndpoint.toString())) {
      await launch(authorizationEndpoint.toString());

      // After user logs in and approves the app, handle the OAuth2 response in your handler page.
      // You'll need to extract the authorization code from the URL query parameters.
    } else {
      // Handle launch failure
    }
  }

  Future<void> _signInWithAzureAD(BuildContext context) async {
    if (_isMicrosoftSignInInProgress) {
      return; // Return early if a sign-in attempt is already in progress
    }

    setState(() {
      _isMicrosoftSignInInProgress = true;
    });
    try {
      final AuthorizationTokenResponse? result =
          await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          'de5f72a7-d8de-4d44-84ec-ce0f2be4d9f2',
          'msauth.nreachnsbm://auth',
          issuer:
              'https://login.microsoftonline.com/9486ac65-39d3-4d25-977c-76d9c31c0046',
          scopes: ['openid', 'profile', 'User.Read'],
        ),
      );
      print('After calling _appAuth.authorizeAndExchangeCode');
      // Handle the sign-in result and call the callback function.
      if (result != null) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        Navigator.pushReplacementNamed(context, '/signin');
      }
    } on Exception catch (e) {
      print('Authentication Exception: $e');
      // Handle the authentication exception, e.g., show an error message.
    } finally {
      setState(() {
        _isMicrosoftSignInInProgress = false;
      });
    }
  }

  Future<void> delayedNavigation(
      context, String routeName, Duration delay) async {
    await Future.delayed(delay);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const HomePage()));
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

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _signin() async {
    try {
      // Implement your sign-in logic here
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Replace the above example with your actual authentication logic

      _showSuccessSnackbar('Sign in successful!');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } catch (e) {
      _showErrorSnackbar('Sign in failed: $e');
    }
  }

  Future<void> _forgotPassword() async {
    try {
      // Implement your forgot password logic here
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text,
      );

      _showSuccessSnackbar('Password reset email sent.');
    } catch (e) {
      _showErrorSnackbar('Password reset failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 243, 243),
      body: Stack(children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: mobileDeviceWidth * 0.43,
              width: mobileDeviceWidth,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/circle3.png'), fit: BoxFit.fill),
              ),
            ),
            const SizedBox(height: 15),
            Container(
              height: mobileDeviceWidth * 0.25,
              decoration: const BoxDecoration(
                image:
                    DecorationImage(image: AssetImage('assets/nsbmlogo.png')),
              ),
            ),
            const SizedBox(height: 30),
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
            GestureDetector(
              onTap: _forgotPassword,
              child: Container(
                width: mobileDeviceWidth,
                padding:
                    EdgeInsets.only(top: 10, right: mobileDeviceWidth * 0.066),
                child: const Text(
                  'Forgot Password?',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      fontSize: 12,
                      fontFamily: 'DM Sans',
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(255, 50, 150, 113)),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Sign in button
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
                onPressed: _signin,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: const Color.fromARGB(255, 50, 150, 113),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Sign in',
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
              ),
            ),

            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PhoneNumberInputScreen()),
                  );
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Guest user? ',
                        style: TextStyle(fontSize: 13, color: grey)),
                    Text(
                      'Click here',
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
            const SizedBox(height: 5),
            const Padding(
              padding: EdgeInsets.only(left: 60.0, right: 60),
              child: Divider(
                color: Color.fromARGB(255, 57, 57, 57),
              ),
            ),

            const Center(
                child: Text('or', style: TextStyle(fontSize: 13, color: grey))),
            const SizedBox(height: 10),
            SizedBox(
              width: mobileDeviceWidth * 0.87,
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    final UserCredential userCredential =
                        await FirebaseAuth.instance.signInWithProvider(
                            // Replace with the actual MicrosoftAuthProvider() setup if you have one
                            MicrosoftAuthProvider()
                            // Example: MicrosoftAuthProvider.scopes(['openid', 'profile', 'email'])
                            );

                    // Successful sign-in
                    final User? user = userCredential.user;
                    print('done');
                    print(user); // User object if sign-in is successful
                  } catch (error) {
                    // Handle sign-in error
                    print('error');
                    print(error);
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: const Color.fromARGB(255, 223, 223, 223),
                  shadowColor: const Color.fromARGB(187, 206, 206, 206),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Transform.scale(
                      scale: 2, // Adjust the scale factor as needed
                      child: Image.asset(
                        'assets/microsoft.png',
                        height: 25, // Original image height
                      ),
                    ),
                    const Text(
                      'Continue with Microsoft',
                      style: TextStyle(
                        fontSize: 15,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignupPage()),
                  );
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Do not have an account? ',
                        style: TextStyle(fontSize: 13, color: grey)),
                    Text(
                      'Register',
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
