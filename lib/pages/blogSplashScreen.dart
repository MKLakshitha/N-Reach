import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simple_flutter_app/constants/constants.dart';
import 'package:simple_flutter_app/pages/blog.dart';

class BlogSplash extends StatelessWidget {
  const BlogSplash({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const BlogPage())); // Navigate to target page
    });
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/blogged.jpg',
              height: mobileDeviceHeight * 0.23,
            ),
            const CupertinoActivityIndicator(),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
