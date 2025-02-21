import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Push Notifications"),
      ),
      body: Center(
        child: Text(
          "Waiting for notifications...",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
