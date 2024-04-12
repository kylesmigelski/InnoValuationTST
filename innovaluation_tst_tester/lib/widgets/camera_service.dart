import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:innovaluation_tst_tester/screens/main_menu_screen.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:innovaluation_tst_tester/theme_data.dart';
import 'package:geolocator/geolocator.dart';
import '../utils/user_state.dart';
import 'package:provider/provider.dart';
import '../providers/camera_state_provider.dart';
import 'package:innovaluation_tst_tester/widgets/instructions_modal.dart';

final _currentUser = FirebaseAuth.instance.currentUser!;

class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({Key? key}) : super(key: key);

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late Future<void> _initializeControllerFuture;
  bool showInstructions = true; // Control the visibility of the instructions

  @override
  void initState() {
    super.initState();
    _initializeControllerFuture = _initCamera();

    // Schedule the modal bottom sheet to show after the UI has been built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showModalBottomSheet(context);
    });
  }

  Future<void> _initCamera() async {
    final cameraProvider =
        Provider.of<CameraStateProvider>(context, listen: false);
    if (cameraProvider.controller == null) {
      return cameraProvider.initializeCamera();
    }
    return Future.value();
  }

  @override
  Widget build(BuildContext context) {
    final cameraProvider =
        Provider.of<CameraStateProvider>(context, listen: true);
    return Scaffold(
      appBar: AppBar(title: const Text('Take a picture')),
      body: Stack(
        children: [
          FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  cameraProvider.controller != null) {
                return CameraPreview(cameraProvider.controller!);
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.black
                  .withOpacity(0.3), // Semi-transparent black bottom bar
              padding: EdgeInsets.symmetric(horizontal: 20),
              height: MediaQuery.of(context).size.height /
                  5, // 1/5 of the screen height
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Invisible box to balance the help button
                  SizedBox(width: 48), // Match the width of the help button
                  GestureDetector(
                    onTap: takePicture,
                    child: Container(
                      width: 75, // Custom size for the camera button
                      height: 75, // Custom size for the camera button
                      decoration: BoxDecoration(
                        color: Colors.transparent, // Camera button color
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black45,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: SvgPicture.asset('assets/images/camera3.svg'),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _showModalBottomSheet(context),
                    child: Container(
                      width: 48, // Custom size for the help button
                      height: 48, // Custom size for the help button
                      decoration: BoxDecoration(
                        color: Colors.black, // Help button color
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black45,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: Icon(Icons.help_outline, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        // Rounded corners at the top
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
          initialChildSize: 0.75,
          maxChildSize: 0.9,
          minChildSize: 0.22,
          expand: false,
          builder: (context, scrollController) {
            return InstructionsModal();
          }),
    );
  }

  void takePicture() async {
    final cameraProvider =
        Provider.of<CameraStateProvider>(context, listen: false);
    try {
      await _initializeControllerFuture;
      if (cameraProvider.controller != null) {
        final image = await cameraProvider.controller!.takePicture();
        if (!mounted) return;
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => DisplayPictureScreen(imagePath: image.path),
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }
}

class InstructionsOverlay extends StatelessWidget {
  final ScrollController? scrollController;

  const InstructionsOverlay({Key? key, this.scrollController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white.withOpacity(0.95),
      padding: const EdgeInsets.all(16),
      child: ListView(
        controller: scrollController, // Pass the ScrollController to ListView
        children: [
          Text(
            'To take a photo, press the camera button. Make sure the subject is well-lit and in focus.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Got it!'),
          ),
        ],
      ),
    );
  }
}

class DisplayPictureScreen extends StatelessWidget {
  DisplayPictureScreen({Key? key, required this.imagePath}) : super(key: key);

  final String imagePath;
  final _cloudFirestoreImageFolderLocation =
      FirebaseFirestore.instance.collection('images');
  final _currentUserDocRef =
      FirebaseFirestore.instance.collection("users").doc(_currentUser.uid);

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
      initialPhotoTaken:
          isInitialPhoto ? true : currentUserState.initialPhotoTaken,
      initialPhotoTimestamp: isInitialPhoto
          ? photoTimestamp
          : currentUserState.initialPhotoTimestamp,
      followUpPhotoTaken:
          !isInitialPhoto ? true : currentUserState.followUpPhotoTaken,
      followUpPhotoTimestamp: !isInitialPhoto
          ? photoTimestamp
          : currentUserState.followUpPhotoTimestamp,
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
          Expanded(child: Image.file(File(imagePath))),
          Container(
            height: MediaQuery.of(context).size.height / 5,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            
            children: [
              ElevatedButton(
                onPressed: () async {
                  // navigator to the main menu view
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MainMenuView(),
                    ),
                  );
                  try {
                    Position position = await _determinePosition();
                    _uploadImageToFirestore(position); // Upload in the background
                  } catch (e) {
                    print("Error: $e"); // Log errors
                  }
                },
                child: const Text('Confirm'),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Navigate back without uploading
                },
                child: const Text('Retake'),
              ),
            ],
          ),
          ),
        ],
      ),
    );
  }
}