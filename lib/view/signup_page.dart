import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:n_reach_nsbm/view/signin_page.dart';

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
            'photo_url': '',
            'uid': user.uid,
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
                    image: AssetImage('assets/circle.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
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
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirm Password',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _signup,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: const Color.fromARGB(255, 50, 150, 113),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Sign Up',
                      style: TextStyle(fontSize: 18, fontFamily: 'DM Sans')),
                ),
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
                child: const Text('Already have an account? Login',
                    style: TextStyle(fontSize: 14, fontFamily: 'DM Sans')),
              ),
            ),
            const SizedBox(height: 50),
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
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
