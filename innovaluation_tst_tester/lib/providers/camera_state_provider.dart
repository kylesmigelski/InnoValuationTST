import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraStateProvider extends ChangeNotifier {
  bool _isCameraActive = false;
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;

  bool get isCameraActive => _isCameraActive;

  set isCameraActive(bool value) {
    _isCameraActive = value;
    notifyListeners();
  }

  CameraController? get controller => _controller;

  Future<void>? get initializeControllerFuture => _initializeControllerFuture;

  // Initializes the camera
  Future<void> initializeCamera() async {
    // Obtain a list of the available cameras on the device.
    final cameras = await availableCameras();

    if (cameras.isNotEmpty) {
      // For simplicity, we're using the first camera found.
      final firstCamera = cameras.first;

      _controller = CameraController(
        firstCamera,
        ResolutionPreset.high,
      );

      _initializeControllerFuture = _controller!.initialize().then((_) {
        // Notify listeners that the controller is initialized and ready
        notifyListeners();
      }).catchError((error) {
        print("Camera initialization error: $error");
        // Handle or log error
      });
    } else {
      print("No cameras found on this device.");
      // Handle case where no cameras are available
    }
  }

  @override
  void dispose() {
    // Dispose of the controller when the provider is disposed.
    _controller?.dispose();
    super.dispose();
  }
}
