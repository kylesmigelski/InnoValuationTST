import 'package:flutter/material.dart';
import 'package:innovaluation_tst_tester/theme_data.dart';

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
                  // go to home
                  //Navigator.pop(context);
                },
                child: Text('Go back'),
              ),
            ],
          ),
        ),
      );
}
}
