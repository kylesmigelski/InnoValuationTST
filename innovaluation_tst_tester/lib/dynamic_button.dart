import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '/user_state.dart';
import 'questionnaire_screen.dart';
import 'package:camera/camera.dart';
import 'auth_provider.dart';
import 'package:provider/provider.dart';
import 'camera_service.dart';
import 'dart:async';
class DynamicProgressButton extends StatefulWidget {
  final String userId;

  DynamicProgressButton({Key? key, required this.userId}) : super(key: key);

  @override
  _DynamicProgressButtonState createState() => _DynamicProgressButtonState();
}

class _DynamicProgressButtonState extends State<DynamicProgressButton> {
  CameraDescription? _firstCamera;
  StreamSubscription? _userStateSubscription;

  @override
  void initState() {
    super.initState();
    _getCamera().then((value) {
      setState(() {
        _firstCamera = value;
      });
    });
    // Subscribe to the stream.
    _subscribeToUserState();
    // Listen to authentication state changes.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<AuthenticationProvider>(context, listen: false);
      // React to user sign-outs.
      provider.addListener(() {
        if (provider.currentUser == null) {
          _unsubscribeFromUserState(); // Cleanup on sign-out.
        } else {
          _subscribeToUserState(); // Resubscribe if needed.
        }
      });
    });
  }

  void _subscribeToUserState() {
    // Ensure we're not creating a new subscription if one already exists.
    _unsubscribeFromUserState();
    _userStateSubscription = userStateStream(widget.userId).listen((userState) {
    });
  }

  void _unsubscribeFromUserState() {
    _userStateSubscription?.cancel();
    _userStateSubscription = null; // Reset the subscription.
  }

   @override
  void dispose() {
    _unsubscribeFromUserState(); 
    super.dispose();
  }

  void _completeQuestionnaire() {
    // navigate to the questionnaire screen
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => QuestionnaireScreen()));
  }

Future<CameraDescription?> _getCamera() async {
  final cameras = await availableCameras();
  // Check if the cameras list is empty, which may be the case in simulators
  if (cameras.isEmpty) {
    print("No cameras available.");
    return null; // Return null or handle as necessary for your app's logic
  }
  return cameras.first;
}

  void _takePhoto() async {
    if (_firstCamera == null) {
      print("Camera not initialized yet.");
      return;
    }

    // Navigate to the camera screen with the first camera
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => InstructionsScreen(camera: _firstCamera!),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserState>(
      stream: userStateStream(widget.userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        if (!snapshot.hasData || snapshot.hasError) {
          return Text('Unable to fetch user state');
        }

        final userState = snapshot.data!;
        return _displayUserState(userState);
      },
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
    if (!userState.questionnaireCompleted) {
      return buildStateButton(
          context: context,
          text: 'Complete Questionnaire',
          iconPath: "assets/images/clipboard2.svg",
          color: const Color.fromARGB(255, 188, 188, 188),
          isLocked: false,
          userState: userState,
          onPressed: _completeQuestionnaire);
    } else if (!userState.initialPhotoTaken) {
      return buildStateButton(
          context: context,
          text: 'Take Initial Photo',
          iconPath: "assets/images/camera.svg",
          color: Color(0xFF2E1C56),
          isLocked: false,
          userState: userState,
          onPressed: _takePhoto);
    } else if (userState.initialPhotoTaken &&
        !userState.canTakeFollowUpPhoto() &&
        !userState.followUpPhotoTaken) {
      return buildStateButton(
          context: context,
          text: 'Photo Locked',
          iconPath: "assets/images/camera.svg",
          color: Color(0xFF949494),
          isLocked: true,
          userState: userState,
          onPressed: null);
    } else if (userState.initialPhotoTaken &&
        userState.canTakeFollowUpPhoto() &&
        !userState.followUpPhotoTaken) {
          //userState.updateCanTakeFollowUpPhoto();
      return buildStateButton(
          context: context,
          text: 'Take Follow-up Photo',
          iconPath: "assets/images/camera.svg",
          color: Color(0xFF2E1C56),
          isLocked: true,
          userState: userState,
          onPressed: _takePhoto);
    } else {
      return buildStateButton(
          context: context,
          text: 'All tasks completed',
          iconPath: "assets/images/clipboard2.svg",
          color: const Color.fromARGB(255, 188, 188, 188),
          isLocked: false,
          userState: userState,
          onPressed: null);
    }
  }
}

Widget buildStateButton({
  required BuildContext context,
  required String text,
  required String iconPath,
  required Color color, // enabled state.
  VoidCallback? onPressed,
  required bool isLocked,
  required UserState userState,
}) {
  // Define button style with custom disabled and enabled background colors
  final buttonStyle = ElevatedButton.styleFrom(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    padding: EdgeInsets.all(0), // Adjust padding as needed
  ).copyWith(
    backgroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
      if (states.contains(MaterialState.disabled)) {
        return color; // Use the same color for disabled state to avoid transparency
      }
      return color; // Use the specified color for enabled state
    }),
    overlayColor: MaterialStateProperty.all(Colors.transparent), 
  );

  return Container(
    height: 120, 
    width: 400,
    margin: EdgeInsets.symmetric(horizontal: 20), 
    child: ElevatedButton(
      onPressed: onPressed,
      style: buttonStyle,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(iconPath, height: 24, width: 24),
          SizedBox(width: 8),
          Text(text, style: TextStyle(fontSize: 20, color: Colors.white)),
          if (isLocked) SizedBox(height: 8),
          if (isLocked)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20), 
              child: CountdownProgressBar(userState: userState),
            ),
        ],
      ),
    ),
  );
}

String formatDuration(Duration d) => d.toString().split('.').first.padLeft(8, "0");

class CountdownProgressBar extends StatefulWidget {
  final UserState userState;

  const CountdownProgressBar({Key? key, required this.userState}) : super(key: key);

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
  bool isLocked = false;
  // Determine the countdown type and set the remaining duration
  if (userState.initialPhotoTaken && !userState.canTakeFollowUpPhoto()) {
    remainingDuration = userState.getLockedCountdownDuration();
    totalDurationSeconds = 48 * 3600; // Total duration for locked countdown
    isLocked = true;
  } else {
    remainingDuration = userState.getFollowUpPhotoCountdownDuration();
    totalDurationSeconds = 24 * 3600; // Total duration for follow-up countdown
  }

  if (remainingDuration != null && remainingDuration.inSeconds > 0) {
    final remainingSeconds = remainingDuration.inSeconds;
    double progress;
    if (isLocked) {
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
          valueColor: AlwaysStoppedAnimation<Color>(isLocked ? Colors.purple : Colors.green), // Optional: Different color for follow-up countdown
        ),
      ),
    );
  }
  return Container(); // Return an empty container if there's no progress to show
}


}