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
                  Navigator.of(context).pop();
                },
                child: Text('Go back'),
              ),
            ],
          ),
        ),
      );
}
}
