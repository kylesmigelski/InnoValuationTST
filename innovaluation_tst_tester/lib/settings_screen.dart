import 'package:flutter/material.dart';
import 'package:innovaluation_tst_tester/theme_data.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GradientContainer(
        child: Center(
          child: Column(
            
            children: [
              SizedBox(height: 100),
              ElevatedButton(
                onPressed: () {
                  // log out
                  FirebaseAuth.instance.signOut();
                },
                child: Text('Log out'),
              ),
            ],
          ),
        ),
      );
}
}
