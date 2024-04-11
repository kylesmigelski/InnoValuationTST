import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:innovaluation_tst_tester/screens/main_menu_screen.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:innovaluation_tst_tester/theme_data.dart';
import 'package:geolocator/geolocator.dart';
import '../utils/user_state.dart';
import 'package:provider/provider.dart';
import '../providers/camera_state_provider.dart';

final _currentUser = FirebaseAuth.instance.currentUser!;

class InstructionsScreen extends StatelessWidget {
  const InstructionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Photo Instructions')),
      body: GradientContainer(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              const Padding(
                padding: EdgeInsets.all(25.0),
                child: Text(
                  'To take a photo, press the camera button. Make sure the subject is well-lit and in focus.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const TakePictureScreen(),
                  ));
                },
                child: const Text('Open Camera'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({Key? key}) : super(key: key);

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // Initialize camera in provider if not already done
    final cameraProvider = Provider.of<CameraStateProvider>(context, listen: false);
    if (cameraProvider.controller == null) {
      _initializeControllerFuture = cameraProvider.initializeCamera();
    } else {
      _initializeControllerFuture = Future.value();
    }
  }

  @override
  Widget build(BuildContext context) {
    final cameraProvider = Provider.of<CameraStateProvider>(context, listen: true);

    return Scaffold(
      appBar: AppBar(title: const Text('Take a picture')),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done && cameraProvider.controller != null) {
            return CameraPreview(cameraProvider.controller!);
          } else {
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
            final image = await cameraProvider.controller!.takePicture();

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

class DisplayPictureScreen extends StatelessWidget {

  DisplayPictureScreen({Key? key, required this.imagePath}) : super(key: key);

  final String imagePath;
  final _cloudFirestoreImageFolderLocation = FirebaseFirestore.instance
      .collection('images');
  final _currentUserDocRef = FirebaseFirestore.instance.collection("users").
  doc(_currentUser.uid);

  Future<void> _uploadImageToFirestore(Position position) async {
  File file = File(imagePath);
  DateTime currentDateTime = DateTime.now();
  final imagePath4Firestore = '${_currentUser.uid} - $currentDateTime';

  firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
      .ref()
      .child('images')
      .child(imagePath4Firestore);

  await ref.putFile(file);
  String downloadURL = await ref.getDownloadURL();

  _cloudFirestoreImageFolderLocation.doc(imagePath4Firestore).set({
    'url': downloadURL,
    'createdAt': FieldValue.serverTimestamp(),
    'latitude': position.latitude,
    'longitude': position.longitude,
  });

  DocumentSnapshot userDocSnapshot = await _currentUserDocRef.get();
  UserState currentUserState = UserState.fromFirestore(userDocSnapshot);

  bool isInitialPhoto = currentUserState.initialPhotoTaken == false;
  
  Timestamp photoTimestamp = Timestamp.fromDate(currentDateTime);

  currentUserState = currentUserState.copyWith(
    initialPhotoTaken: isInitialPhoto ? true : currentUserState.initialPhotoTaken,
    initialPhotoTimestamp: isInitialPhoto ? photoTimestamp : currentUserState.initialPhotoTimestamp,
    followUpPhotoTaken: !isInitialPhoto ? true : currentUserState.followUpPhotoTaken,
    followUpPhotoTimestamp: !isInitialPhoto ? photoTimestamp : currentUserState.followUpPhotoTimestamp,
  );

  // Updating the user document with the new state
  await _currentUserDocRef.update(currentUserState.toJson());

    List<String> snapshotPathList;

    final data = userDocSnapshot.data() as Map<String, dynamic>?;

    if (data != null && data.containsKey('photosList')) {
      snapshotPathList = List<String>.from(data['photosList']);
    } else {
      snapshotPathList = [];
    }


  snapshotPathList.add(downloadURL);
  
  await _currentUserDocRef.update({'photosList': snapshotPathList});
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

