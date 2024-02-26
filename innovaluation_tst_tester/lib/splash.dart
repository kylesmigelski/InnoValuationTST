import 'package:flutter/material.dart';

//Basic splash screen for if the app needs to wait to check
// if the person can autologin or not
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(context) {
    return Scaffold(

      body: const Center(
        child: Text('Loading...'),
      ),
    );
  }

}