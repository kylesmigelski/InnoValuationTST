import 'package:flutter/material.dart';

class ButtonStateProvider with ChangeNotifier {
  bool _isQuestionnaireActive = true;
  bool _isFaceActive = true;

  bool get isFaceActive => _isFaceActive;
  bool get isQuestionnaireActive => _isQuestionnaireActive;

  Function(BuildContext)? showDialogFunc;

  void registerShowDialogFunc(Function(BuildContext) func) {
    showDialogFunc = func;
  }

  void callShowDialog(BuildContext context) {
    if (showDialogFunc != null) {
      showDialogFunc!(context);
    }
  }

  set isQuestionnaireActive(bool value) {
    _isQuestionnaireActive = value;
    notifyListeners();
  }

  set isFaceActive(bool value) {
    _isFaceActive = value;
    notifyListeners();
  }

  Color getButtonColorFace() {
    return _isFaceActive ? Color.fromARGB(255, 255, 255, 255) : Color(0xFFEAEAEA);
  }

  Color getButtonTextColorFace() {
    return _isFaceActive ? Color(0xFF2B1953) : Color(0xFF858080);
  }

  Color getButtonColorQuestionnaire() {
    return _isQuestionnaireActive ? Color.fromARGB(255, 255, 255, 255) : Color(0xFFEAEAEA);
  }

  Color getButtonTextColorQuestionnaire() {
    return _isQuestionnaireActive ? Color(0xFF2B1953) : Color(0xFF858080);
  }
}