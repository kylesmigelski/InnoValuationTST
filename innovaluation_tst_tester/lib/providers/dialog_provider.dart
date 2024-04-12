import 'package:flutter/material.dart';
import '../utils/user_state.dart';
import 'package:provider/provider.dart';
import 'camera_state_provider.dart';
import 'button_state_provider.dart';

class DialogManager with ChangeNotifier {
  BuildContext context;
  String lastDialogShownForState = "";
  bool isDialogShown = false;
  UserState? userStateLocal;

  DialogManager(this.context);

  void showDialogIfNeeded(UserState userState, BuildContext context) {
    String currentState = _getStateSignature(userState);
    userStateLocal = userState;

    if (_shouldShowDialog(userState) && lastDialogShownForState != currentState && !isDialogShown) {
      isDialogShown = true;
      lastDialogShownForState = currentState;
      showCustomDialog(context).then((_) {
        isDialogShown = false; // Reset dialog state after it's dismissed
      });
    }
  }

  Future<void> showCustomDialog(BuildContext context) async {
    Map<String, String> dialogContent = _dialogContent(userStateLocal!);
    String title = dialogContent['title'] ?? 'Update';
    String message = dialogContent['message'] ?? 'There\'s an update for you.';
    _updateProvider(userStateLocal!);

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(title, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          content: Text(message, style: TextStyle(color: Colors.black)),
          actions: <Widget>[
            TextButton(
              child: Text('Got it'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  String _getStateSignature(UserState userState) {
    return "${userState.questionnaireCompleted}_${userState.faceVerified}_${userState.initialPhotoTaken}_${userState.canTakeFollowUpPhoto()}_${userState.followUpPhotoTaken}_${isUserStateComplete(userState)}";
  }

  bool _shouldShowDialog(UserState userState) {
    // Based on userState, return true if dialog should be shown
    return true;
  }

    // Check if the follow-up photo is locked
  bool _isPhotoLocked(UserState userState) {
    return userState.initialPhotoTaken &&
        !userState.canTakeFollowUpPhoto() &&
        !userState.followUpPhotoTaken;
  }

Map<String, String> _dialogContent(UserState userState) {
    Duration? timeRemaining = userState.getLockedCountdownDuration();

    if (!userState.questionnaireCompleted) {
      return {
        'title': 'Haven\'t completed your questionnaire?',
        'message':
            'Completing your health questionnaire is essential for TST analysis. Click here to complete it and ensure accurate interpretation. Your health is our priority.'
      };
    } else if (!userState.faceVerified) {
      return {
        'title': 'Face Verification Required',
        'message':
            'Please verify your face to proceed. This is a necessary step to ensure the security of your data.'
      };
    } else if (!userState.initialPhotoTaken && !userState.followUpPhotoTaken) {
      return {
        'title': 'Capture your test site photo',
        'message':
            'Let\'s take an initial photo of your test site. This step is crucial for monitoring the site\'s reaction accurately over time.'
      };
    } else if (_isPhotoLocked(userState) &&
        !userState.hasFollowUpPhotoDeadlinePassed()) {
      String message =
          'The next photo can be taken 48 hours from the initial capture. Check back in [time remaining] to take your follow-up photo. Thank you for your patience!';
      if (timeRemaining != null) {
        String formattedTimeRemaining =
            '${timeRemaining.inHours} hours and ${timeRemaining.inMinutes.remainder(60)} minutes';
        message =
            message.replaceAll('[time remaining]', formattedTimeRemaining);
      }
      return {'title': 'Please Wait for the Next Photo', 'message': message};
    } else if (userState.canTakeFollowUpPhoto()) {
      return {
        'title': 'Final Follow-Up Photo',
        'message':
            'This is the time for your final follow-up photo. Your submission will be reviewed by our medical experts to ensure the most accurate assessment. Click here to take and upload your photo.'
      };
    } else if (userState.hasFollowUpPhotoDeadlinePassed()) {
      return {
        'title': 'Missed Window',
        'message':
            'You have missed the window to take your follow-up photo. Please contact your healthcare provider for further instructions.'
      };
    } else {
      return {
        'title': 'All Tasks Completed',
        'message': 'Please await your diagnosis. Thank you for your cooperation.'
      };
    }
  }

  bool isUserStateComplete(UserState userState) {
    return userState.questionnaireCompleted &&
        userState.faceVerified &&
        userState.initialPhotoTaken &&
        userState.followUpPhotoTaken;
  }

    // Update the providers based on the user state
Future<void> _updateProvider(UserState userState) async {
  // Retrieve the providers only once to avoid multiple look-ups
  var cameraProvider = Provider.of<CameraStateProvider>(context, listen: false);
  var buttonProvider = Provider.of<ButtonStateProvider>(context, listen: false);

  // Update the camera active state 
  if (!userState.questionnaireCompleted || _isPhotoLocked(userState) || userState.hasFollowUpPhotoDeadlinePassed() || isUserStateComplete(userState)) {
    cameraProvider.isCameraActive = false;
  } else if (!userState.initialPhotoTaken || userState.canTakeFollowUpPhoto()) {
    cameraProvider.isCameraActive = true;
  }

  // Update the button states based on questionnaire and face verification states
  buttonProvider.isQuestionnaireActive = !userState.questionnaireCompleted;
  buttonProvider.isFaceActive = !userState.faceVerified;
}
}
