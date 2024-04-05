import 'package:flutter/material.dart';

class CameraStateProvider extends ChangeNotifier {
  bool _isCameraActive = false;

  bool get isCameraActive => _isCameraActive;

  set isCameraActive(bool value) {
    _isCameraActive = value;
    notifyListeners();
  }
}
