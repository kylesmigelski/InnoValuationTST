import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '/user_state.dart';
import 'questionnaire_screen.dart';
import 'package:camera/camera.dart';
import 'camera_service.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'providers/camera_state_provider.dart';

class DynamicProgressButton extends StatefulWidget {
  final String userId;

  DynamicProgressButton({Key? key, required this.userId}) : super(key: key);

  @override
  _DynamicProgressButtonState createState() => _DynamicProgressButtonState();
}

class _DynamicProgressButtonState extends State<DynamicProgressButton> {
  CameraDescription? _firstCamera;
  bool _isDialogShown = false;
  String _lastDialogShownForState = "";

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<CameraDescription?> _getCamera() async {
    final cameras = await availableCameras();
    return cameras.isNotEmpty ? cameras.first : null;
  }

  void _initializeCamera() {
    _getCamera().then((camera) {
      setState(() {
        _firstCamera = camera;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserState>(
      stream: userStateStream(widget.userId),
      builder: (context, snapshot) {
        // Deferred showDialog to postFrameCallback to avoid setState errors during build.
        if (snapshot.hasData) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showDialogIfNeeded(snapshot.data!);
          });
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData) {
          return Text('No user state available');
        } else {
          return _displayUserState(snapshot.data!);
        }
      },
    );
  }

  Future<void> _showDialogIfNeeded(UserState userState) async {
    Map<String, String> dialogContent = _dialogContent(userState);
    String dialogTitle = dialogContent['title'] ?? 'Update';
    String dialogMessage = dialogContent['message'] ?? 'There\'s an update for you.';

    // Define a string that represents the current significant state
    String currentState =
        "${userState.questionnaireCompleted}_${userState.initialPhotoTaken}_${userState.followUpPhotoTaken}_${userState.canTakeFollowUpPhoto()}";

    // Check if the current state is different from the last one we showed the dialog for
    if (_shouldShowDialog(userState) &&
        !_isDialogShown &&
        _lastDialogShownForState != currentState) {
      _isDialogShown = true;
      _lastDialogShownForState = currentState; // Update the last known state
      _updateProvider(userState); // Update the camera provider

      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text(dialogTitle,
            style: TextStyle(color: Colors.black,
            fontWeight: FontWeight.bold,)
            ),
            content: Text(dialogMessage,
            style: TextStyle(color: Colors.black)),
            actions: <Widget>[
              TextButton(
                child: Text('Got it'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        },
      );

      if (mounted) {
        setState(() {
          _isDialogShown = false;
        });
      }
    }
  }

  bool _shouldShowDialog(UserState userState) {
    return !userState.questionnaireCompleted ||
        (!userState.initialPhotoTaken && !userState.followUpPhotoTaken) ||
        userState.canTakeFollowUpPhoto() || _isPhotoLocked(userState);
  }

  bool _isPhotoLocked(UserState userState) {
    return userState.initialPhotoTaken &&
        !userState.canTakeFollowUpPhoto() &&
        !userState.followUpPhotoTaken;
  }

  Future<void> _updateProvider(UserState userState) async {
    if (!userState.questionnaireCompleted) {
      Provider.of<CameraStateProvider>(context, listen: false).isCameraActive = false;
    } else if (!userState.initialPhotoTaken) {
      Provider.of<CameraStateProvider>(context, listen: false).isCameraActive = true;
    } else if (_isPhotoLocked(userState) && !userState.hasFollowUpPhotoDeadlinePassed()) {
      Provider.of<CameraStateProvider>(context, listen: false).isCameraActive = false;
    } else if (userState.canTakeFollowUpPhoto()) {
      Provider.of<CameraStateProvider>(context, listen: false).isCameraActive = true;
    } else if (userState.hasFollowUpPhotoDeadlinePassed()) {
      Provider.of<CameraStateProvider>(context, listen: false).isCameraActive = false;
    } else {
      Provider.of<CameraStateProvider>(context, listen: false).isCameraActive = false;
    }
  }

Map<String, String> _dialogContent(UserState userState) {
  Duration? timeRemaining = userState.getLockedCountdownDuration();

  if (!userState.questionnaireCompleted) {
    return {
      'title': 'Haven\'t completed your questionnaire?',
      'message': 'Completing your health questionnaire is essential for TST analysis. Click here to complete it and ensure accurate interpretation. Your health is our priority.'
    };
  } else if (!userState.initialPhotoTaken && !userState.followUpPhotoTaken) {
    return {
      'title': 'Capture your test site photo',
      'message': 'Let\'s take an initial photo of your test site. This step is crucial for monitoring the site\'s reaction accurately over time.'
    };
  } else if (_isPhotoLocked(userState) && !userState.hasFollowUpPhotoDeadlinePassed()) {
    String message = 'The next photo can be taken 48 hours from the initial capture. Check back in [time remaining] to take your follow-up photo. Thank you for your patience!';
    if (timeRemaining != null) {
      String formattedTimeRemaining = '${timeRemaining.inHours} hours and ${timeRemaining.inMinutes.remainder(60)} minutes';
      message = message.replaceAll('[time remaining]', formattedTimeRemaining);
    }
    return {
      'title': 'Please Wait for the Next Photo',
      'message': message
    };
  } else if (userState.canTakeFollowUpPhoto()) {
    return {
      'title': 'Final Follow-Up Photo',
      'message': 'This is the time for your final follow-up photo. Your submission will be reviewed by our medical experts to ensure the most accurate assessment. Click here to take and upload your photo.'
    };
  } else if (userState.hasFollowUpPhotoDeadlinePassed()) {
    return {
      'title': 'Missed Window',
      'message': 'You have missed the window to take your follow-up photo. Please contact your healthcare provider for further instructions.'
    };
  } else {
    return {
      'title': 'All Done',
      'message': 'All tasks are completed. Good job!'
    };
  }
}

  void _completeQuestionnaire() {
    // navigate to the questionnaire screen
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => QuestionnaireScreen()));
  }

  void _takePhoto() async {
    if (_firstCamera == null) {
      print("Camera not initialized yet.");
      return;
    }

    // Navigate to the camera screen with the first camera
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => InstructionsScreen(camera: _firstCamera!),
      ),
    );
  }

  Stream<UserState> userStateStream(String userId) {
    // listen to the  document for the given userId and map changes to UserState
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((snapshot) => UserState.fromFirestore(snapshot));
  }

  Widget _displayUserState(UserState userState) {
    // Check if the dialog should be shown and display it
    _shouldShowDialog(userState);

    if (!userState.questionnaireCompleted) {
      return buildStateButton(
          context: context,
          text: 'Complete Questionnaire',
          iconPath: "assets/images/clipboard2.svg",
          color: const Color.fromARGB(255, 188, 188, 188),
          hasProgressBar: false,
          userState: userState,
          onPressed: _completeQuestionnaire,
          tooltipMessage: "Complete the questionnaire to proceed.");
    } else if (!userState.initialPhotoTaken) {
      return buildStateButton(
          context: context,
          text: 'Take Initial Photo',
          iconPath: "assets/images/camera.svg",
          color: Color(0xFF2E1C56),
          hasProgressBar: false,
          userState: userState,
          onPressed: _takePhoto);
    } else if (_isPhotoLocked(userState) && !userState.hasFollowUpPhotoDeadlinePassed()) {
      return buildStateButton(
          context: context,
          text: 'Photo Locked',
          iconPath: "assets/images/camera.svg",
          color: Color(0xFF949494),
          hasProgressBar: true,
          userState: userState,
          onPressed: null);
    } else if (userState.canTakeFollowUpPhoto()) {
      return buildStateButton(
          context: context,
          text: 'Take Follow-up Photo',
          iconPath: "assets/images/camera.svg",
          color: Color(0xFF2E1C56),
          hasProgressBar: true,
          userState: userState,
          onPressed: _takePhoto);
    } else if (userState.initialPhotoTaken && userState.followUpPhotoTaken) {
      return buildStateButton(
          context: context,
          text: 'All tasks completed',
          iconPath: "assets/images/clipboard2.svg",
          color: const Color.fromARGB(255, 188, 188, 188),
          hasProgressBar: false,
          userState: userState,
          onPressed: null);
    // user misses window
    } else if (userState.hasFollowUpPhotoDeadlinePassed()) {
      return buildStateButton(
          context: context,
          text: 'Missed Window',
          iconPath: "assets/images/camera.svg",
          color: const Color.fromARGB(255, 188, 188, 188),
          hasProgressBar: false,
          userState: userState,
          onPressed: null);
    } else {
      return Text('Unknown state');
    }
  }
}

Widget buildStateButton({
  required BuildContext context,
  required String text,
  required String iconPath,
  required Color color,
  VoidCallback? onPressed,
  required bool hasProgressBar,
  required UserState userState,
  String? tooltipMessage,
}) {
  // Define button style with custom disabled and enabled background colors
  final buttonStyle = ElevatedButton.styleFrom(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    padding: EdgeInsets.all(0),
  ).copyWith(
    backgroundColor:
        MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
      if (states.contains(MaterialState.disabled)) {
        return color; // Use the specified color for disabled state
      }
      return color; // Use the specified color for enabled state
    }),
    overlayColor: MaterialStateProperty.all(Colors.transparent),
  );

  return Container(
    height: 120,
    width: 400,
    margin: EdgeInsets.symmetric(horizontal: 20),
    child: Tooltip(
      message: tooltipMessage ?? "Unknown",
      child: ElevatedButton(
        onPressed: onPressed,
        style: buttonStyle,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(iconPath, height: 24, width: 24),
            SizedBox(width: 8),
            Text(text, style: TextStyle(fontSize: 20, color: Colors.white)),
            if (hasProgressBar) SizedBox(height: 8),
            if (hasProgressBar)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: CountdownProgressBar(userState: userState),
              ),
          ],
        ),
      ),
    ),
  );
}

String formatDuration(Duration d) =>
    d.toString().split('.').first.padLeft(8, "0");

class CountdownProgressBar extends StatefulWidget {
  final UserState userState;

  const CountdownProgressBar({Key? key, required this.userState})
      : super(key: key);

  @override
  _CountdownProgressBarState createState() => _CountdownProgressBarState();
}

class _CountdownProgressBarState extends State<CountdownProgressBar> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 10), (timer) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildProgressBar(widget.userState);
  }

  Widget _buildProgressBar(UserState userState) {
    Duration? remainingDuration;
    final int totalDurationSeconds;
    bool hasProgressBar = false;
    // Determine the countdown type and set the remaining duration
    if (userState.initialPhotoTaken && !userState.canTakeFollowUpPhoto()) {
      remainingDuration = userState.getLockedCountdownDuration();
      totalDurationSeconds = 48 * 3600; // Total duration for locked countdown
      hasProgressBar = true;
    } else {
      remainingDuration = userState.getFollowUpPhotoCountdownDuration();
      totalDurationSeconds =
          24 * 3600; // Total duration for follow-up countdown
    }

    if (remainingDuration != null && remainingDuration.inSeconds > 0) {
      final remainingSeconds = remainingDuration.inSeconds;
      double progress;
      if (hasProgressBar) {
        // For locked countdown, progress increases as time passes
        progress = 1 - remainingSeconds / totalDurationSeconds;
      } else {
        // For follow-up countdown, progress decreases as time passes
        progress = remainingSeconds / totalDurationSeconds;
      }

      return ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        child: SizedBox(
          height: 18, // height of the progress bar
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(hasProgressBar
                ? Colors.purple
                : Colors
                    .green), // Optional: Different color for follow-up countdown
          ),
        ),
      );
    }
    return Container(); // Return an empty container if there's no progress to show
  }
}



// TODO
// ios notification
// dynamic button design
// settings screen
// nav bar camera button 
// home screen buttons/pages 
// log in screen design tweaks (resize, hidden password, login button text)
// notification button functionality
// more push notifications. Questionnaire reminder, photo reminder, missed window
// user flow of dynamic button. register face -> questionnaire -> take photo -> follow up photo -> results. Missed window?