import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:innovaluation_tst_tester/login_screen.dart';
import '../main.dart';

  class AuthenticationProvider extends ChangeNotifier {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

    AuthenticationProvider() {
      _firebaseAuth.authStateChanges().listen((user) {
        // Notify listeners about auth state changes
        notifyListeners();
      });
    }

    User? get currentUser => _firebaseAuth.currentUser;

Future<void> signOut() async {
  await FirebaseAuth.instance.signOut();
  // Use the navigatorKey to navigate
  navigatorKey.currentState?.pushAndRemoveUntil(
    MaterialPageRoute(builder: (context) => LoginScreen()),
    (_) => false,
  );
}}
