import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/user_state.dart'; 

class DynamicProgressButton extends StatefulWidget {
  final String userId;

  DynamicProgressButton({Key? key, required this.userId}) : super(key: key);

  @override
  _DynamicProgressButtonState createState() => _DynamicProgressButtonState();
}

class _DynamicProgressButtonState extends State<DynamicProgressButton> {
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
        return ElevatedButton(
          onPressed: () {}, 
          child: Text(_displayUserState(userState), style: TextStyle(fontSize: 10)),
        );
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
}

String _displayUserState(UserState userState) {
  List<String> stateParts = [];
  stateParts.add('Questionnaire: ${userState.questionnaireCompleted ? "Completed" : "Incomplete"}');
  stateParts.add('Initial Photo: ${userState.initialPhotoTaken ? "Taken" : "Not Taken"}');
  
  // If initial photo is taken, optionally show timestamp
  if (userState.initialPhotoTaken) {
    stateParts.add('Initial Photo Timestamp: ${userState.initialPhotoTimestamp?.toDate().toString() ?? "N/A"}');
  }

  if (userState.followUpPhotoTaken) {
    stateParts.add('Follow Up Photo: Taken');
    // Optionally show timestamp
  } else {
    // display countdown message if not yet eligible
    String? countdownMessage = userState.getFollowUpPhotoCountdown();
    if (countdownMessage != null) {
      stateParts.add(countdownMessage);
    } else {
      stateParts.add('Follow Up Photo: Not Yet Eligible');
    }
  }

  return stateParts.join('\n');
}

