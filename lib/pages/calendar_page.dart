import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  _launchURL() async {
    const url =
        'https://calendar.google.com/calendar/u/0?cid=MTVhNmEzNzY5NjNjNWMwM2FhMzdjZDk5Yzg2YzFlZDJhYmVmYjg3N2M3ODNmZGYzNjEwNjc1MmU3N2YzOWRmZkBncm91cC5jYWxlbmRhci5nb29nbGUuY29t';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Calendar'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _launchURL,
          child: const Text('Open Google Calendar'),
        ),
      ),
    );
  }
}
