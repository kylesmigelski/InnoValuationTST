import 'package:flutter/material.dart';
import 'package:innovaluation_tst_tester/theme_data.dart';
import 'package:innovaluation_tst_tester/camera_service.dart'; // Import the camera_service.dart file
import 'package:camera/camera.dart'; // Import the camera package


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
                child: const Text("Log TST appointment")
            ),
            SizedBox(height: 25,),
            ElevatedButton(
                onPressed: () => _navigateToCamera(context),
                style: bigButtonStyle1(context),
                child: const Text("Take photo of TST site")
            )
          ],
        ),
      ),
    );
  }


Future<void> _navigateToCamera(BuildContext context) async {
  try {
    // Get the list of available cameras.
    final cameras = await availableCameras();

    // Get a specific camera from the list of available cameras.
    final firstCamera = cameras.first;

    // Navigate to the InstructionsScreen widget, passing the first camera.
    // InstructionsScreen will then handle navigating to TakePictureScreen.
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => InstructionsScreen(camera: firstCamera),
      ),
    );
  } catch (e) {
    // Handle any errors here
    print(e); // Consider showing an alert or a toast to the user
  }
}
}

