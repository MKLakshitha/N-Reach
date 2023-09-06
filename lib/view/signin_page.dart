import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:n_reach_nsbm/view/phone_page.dart';
import 'package:n_reach_nsbm/view/signup_page.dart';
import 'package:url_launcher/url_launcher.dart';

import '../pages/home_page.dart';

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
      BuildContext context, String routeName, Duration delay) async {
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
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              flex: 3,
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/Circle2.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Flexible(
              flex: 2,
              child: Container(
                width: 250,
                height: 170,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/nsbmlogo.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            GestureDetector(
              onTap: _forgotPassword,
              child: const Padding(
                padding: EdgeInsets.only(left: 200.0, top: 8),
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(
                      fontSize: 12,
                      fontFamily: 'DM Sans',
                      decoration: TextDecoration.underline,
                      color: Color.fromARGB(255, 50, 150, 113)),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Sign in button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _signin,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: const Color.fromARGB(255, 50, 150, 113),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Sign In',
                      style: TextStyle(fontSize: 16, fontFamily: 'DM Sans')),
                ),
              ),
            ),

            const SizedBox(height: 5),
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
                child: const Text('Guest User? Click here',
                    style: TextStyle(fontSize: 12, fontFamily: 'DM Sans')),
              ),
            ),
            const SizedBox(height: 5),
            const Padding(
              padding: EdgeInsets.only(left: 60.0, right: 60),
              child: Divider(
                color: Colors.black,
              ),
            ),

            const Center(child: Text('or', style: TextStyle(fontSize: 18))),
            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () async {
                      _signInWithMicrosoft(context);
                    }, // Implement the Microsoft login logic
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: const Color.fromARGB(255, 220, 222, 221),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Transform.scale(
                          scale: 1.5, // Adjust the scale factor as needed
                          child: Image.asset(
                            'assets/microsoft.png',
                            height: 25, // Original image height
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Continue with Microsoft',
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: 'DM Sans',
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ],
                    )),
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
                child: const Text('Not have an account? Register',
                    style: TextStyle(fontSize: 14, fontFamily: 'DM Sans')),
              ),
            ),
            const SizedBox(height: 30),
            Flexible(
              flex: 1,
              child: GestureDetector(
                onTap: () {
                  _showEmailSnackbar('Email: nreach@gmail.com');
                },
                child: const Text('Having trouble? Contact us',
                    style: TextStyle(fontSize: 12, fontFamily: 'DM Sans')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
