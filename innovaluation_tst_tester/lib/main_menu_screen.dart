import 'package:flutter/material.dart';
import 'package:innovaluation_tst_tester/theme_data.dart';

class MainMenuView extends StatelessWidget {
  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Innovaluation TST"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 100, left: 24, right: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(
              child: Text(
                "What would you like to do?",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            SizedBox(height: 55,),
            ElevatedButton(
                onPressed: () {
                  print("Button 1 pressed");
                },
                style: bigButtonStyle1(context),
                //this text will obviously change but I'm leaving this in for
                // testing purposes right now
                child: const Text("Log TST appointment")
            ),
            SizedBox(height: 25,),
            ElevatedButton(
                onPressed: () {
                  print("Button 2 pressed");
                },
                style: bigButtonStyle1(context),
                child: const Text("Take photo of TST site")
            )
          ],
        ),
      ),
    );
  }

}