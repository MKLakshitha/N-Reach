import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hi, '),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Implement notification button action.
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Implement settings button action.
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Flippable Container with Picture
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  color: Colors.grey, // Placeholder color
                  child: const Center(
                    child: Text('Flippable Container Picture'),
                  ),
                ),
              ),
            ),

            // Several Containers
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Column(
                children: [
                  Container(
                    height: 100,
                    width: double.infinity,
                    color: Colors.blue,
                    child: const Center(
                      child: Text('Container 1'),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Container(
                    height: 100,
                    width: double.infinity,
                    color: Colors.green,
                    child: const Center(
                      child: Text('Container 2'),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Container(
                    height: 100,
                    width: double.infinity,
                    color: Colors.orange,
                    child: const Center(
                      child: Text('Container 3'),
                    ),
                  ),
                  // Add more containers as needed
                ],
              ),
            ),

            // Stylish Navbar
            Container(
              height: 60.0,
              color: Colors.blueGrey,
              child: const Center(
                child: Text('Stylish Navbar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
