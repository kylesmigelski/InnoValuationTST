import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:innovaluation_tst_tester/main_menu_screen.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:innovaluation_tst_tester/theme_data.dart';
import 'package:geolocator/geolocator.dart';

final _currentUser = FirebaseAuth.instance.currentUser!;

class InstructionsScreen extends StatelessWidget {
  final CameraDescription camera;

  const InstructionsScreen({Key? key, required this.camera}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Photo Instructions')),
      body: GradientContainer(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.1,),
              const Padding(
                padding: EdgeInsets.all(25.0),
                child: Text(
                  'To take a photo, press the camera button. Make sure the subject is well-lit and in focus.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 22,
                      //color: Color(0xFF5D4493)
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.1,),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => TakePictureScreen(camera: camera),
                  ));
                },
                child: Text('Open Camera'),
              ),
            ],
          ),
        ),
      )
    );
  }
}

class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;

  const TakePictureScreen({
    Key? key,
    required this.camera,
  }) : super(key: key);

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Take a picture')),
      // You must wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner until the
      // controller has finished initializing.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return CameraPreview(_controller);
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;

            // Attempt to take a picture and get the file `image`
            // where it was saved.
            final image = await _controller.takePicture();

            if (!mounted) return;

            // If the picture was taken, display it on a new screen.
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(
                  // Pass the automatically generated path to
                  // the DisplayPictureScreen widget.
                  imagePath: image.path,
                ),
              ),
            );
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({Key? key, required this.imagePath}) : super(key: key);

  Future<void> _uploadImageToFirestore(Position position) async {
    // Get the file from the imagePath
    File file = File(imagePath);
    DateTime currentDateTime = DateTime.now();
    final imagePath4Firestore = '${_currentUser.uid} - ${currentDateTime}';

    // Create a reference to the Firebase storage location
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('images')
        .child(imagePath4Firestore);

    // Upload the file to Firebase storage
    await ref.putFile(file);

    // Get the download URL for the file
    String downloadURL = await ref.getDownloadURL();

    // Add the download URL and location to Firestore
    await FirebaseFirestore.instance.collection('images').add({
      'url': downloadURL,
      'createdAt': FieldValue.serverTimestamp(),
      'latitude': position.latitude,
      'longitude': position.longitude
    });

    List<String>? snapshotPathList = null;

    DocumentReference currentUserDocRef = await FirebaseFirestore.instance.collection("users").
      doc(_currentUser.uid);

    print("Hot to here");

    await currentUserDocRef.get().then(
        (DocumentSnapshot doc) {
          final data = doc.data() as Map<String, dynamic>;
          print(data);
          snapshotPathList = (data.containsKey('photosList')) ? (data['photosList'] as List)
              .map((e) => e as String).toList() : null;
        }
    );

    if (snapshotPathList == null) {
      print("No photosList");
      snapshotPathList = [imagePath4Firestore];
    } else {
      snapshotPathList!.add(imagePath4Firestore);
      print(snapshotPathList!);
    }

    print("This got here");

    await FirebaseFirestore.instance.collection('users').
      doc(_currentUser!.uid).update({'photosList' : snapshotPathList});


  }

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Image.file(File(imagePath)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  Position? pos;
                  // Ensuring user grants location permission
                  try {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Uploading image'),
                        )
                    );
                    pos = await _determinePosition();
                  } catch (error) {
                    print("error getting location data: $error");
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please allow location permissions to continue.'),
                        )
                    );
                    Navigator.pop(context, false);
                    return;
                  }
                  // User confirms the picture, send to database, navigate back to main menu
                  try {
                    await _uploadImageToFirestore(pos);
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Uploaded'),
                        )
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MainMenuView()),
                    );
                  } catch (error) {
                    // Handle error
                    print("Error uploading image data: $error");                   // Show an error message to the user
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                        content: Text('Failed to upload image. Please try again.'),
                        )
                    );
                    Navigator.pop(context, false);
                  }
                },
                child: const Text('Confirm'),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () {
                  // User wants to retake the picture, navigate back and remove the current picture
                  Navigator.pop(context, false);
                },
                child: const Text('Retake'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

//Pretty sure that this is a dead/unused method. So I'm stuffing it down here so
// I don't have to look at it
Future<void> main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
  final firstCamera = cameras.first;

  runApp(
    MaterialApp(
      theme: ThemeData.dark(),
      home: InstructionsScreen(
        // Pass the appropriate camera to the TakePictureScreen widget.
        camera: firstCamera,
      ),
    ),
  );
}
