import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraStateProvider extends ChangeNotifier {
  bool _isCameraActive = false;

  bool get isCameraActive => _isCameraActive;

  set isCameraActive(bool value) {
    _isCameraActive = value;
    notifyListeners();
  }

  ///////////////////////////////////////
  ///
  /// Initialize and dispose camera
  ///

  CameraController? _controller;
  Future<void>? _initializeControllerFuture;

  CameraController? get controller => _controller;
  Future<void>? get initializeControllerFuture => _initializeControllerFuture;

  Future<void> initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      _controller = CameraController(cameras.first, ResolutionPreset.high);
      _initializeControllerFuture = _controller!.initialize().then((_) {
        notifyListeners();
      }).catchError((error) {
        print("Camera initialization error: $error");
      });
    } else {
      print("No cameras available");
    }
  }

  Future<void> disposeCamera() async {
    await _controller?.dispose();
    _controller = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}