import 'package:flutter/material.dart';
import 'package:innovaluation_tst_tester/theme_data.dart';
import 'package:provider/provider.dart';
import 'package:innovaluation_tst_tester/auth_provider.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GradientContainer(
      child: Center(
        child: Column(
          children: [
            SizedBox(height: 100),
            // In your Settings widget
            ElevatedButton(
              onPressed: () {
                // Use Provider to sign out
                Provider.of<AuthenticationProvider>(context, listen: false)
                    .signOut();
              },
              child: Text('Sign Out'),
            ),
          ],
        ),
      ),
    );
  }
}
