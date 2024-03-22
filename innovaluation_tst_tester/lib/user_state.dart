import 'package:cloud_firestore/cloud_firestore.dart';

class UserState {
  final bool questionnaireCompleted;
  final bool initialPhotoTaken;
  final Timestamp? initialPhotoTimestamp;
  final bool followUpPhotoTaken;
  final Timestamp? followUpPhotoTimestamp;

  UserState({
    required this.questionnaireCompleted,
    required this.initialPhotoTaken,
    this.initialPhotoTimestamp,
    required this.followUpPhotoTaken,
    this.followUpPhotoTimestamp,
  });

  factory UserState.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>? ?? {};

    return UserState(
      questionnaireCompleted: data['questionnaireCompleted'] ?? false,
      initialPhotoTaken: data['initialPhotoTaken'] ?? false,
      initialPhotoTimestamp: data['initialPhotoTimestamp'],
      followUpPhotoTaken: data['followUpPhotoTaken'] ?? false,
      followUpPhotoTimestamp: data['followUpPhotoTimestamp'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'questionnaireCompleted': questionnaireCompleted,
      'initialPhotoTaken': initialPhotoTaken,
      'initialPhotoTimestamp': initialPhotoTimestamp,
      'followUpPhotoTaken': followUpPhotoTaken,
      'followUpPhotoTimestamp': followUpPhotoTimestamp,
    };
  }

  UserState copyWith({
    bool? questionnaireCompleted,
    bool? initialPhotoTaken,
    Timestamp? initialPhotoTimestamp,
    bool? followUpPhotoTaken,
    Timestamp? followUpPhotoTimestamp,
  }) {
    return UserState(
      questionnaireCompleted: questionnaireCompleted ?? this.questionnaireCompleted,
      initialPhotoTaken: initialPhotoTaken ?? this.initialPhotoTaken,
      initialPhotoTimestamp: initialPhotoTimestamp ?? this.initialPhotoTimestamp,
      followUpPhotoTaken: followUpPhotoTaken ?? this.followUpPhotoTaken,
      followUpPhotoTimestamp: followUpPhotoTimestamp ?? this.followUpPhotoTimestamp,
    );
  }

bool canTakeFollowUpPhoto() {
  if (!initialPhotoTaken || initialPhotoTimestamp == null) return false;
  final now = DateTime.now();
  final initialPhotoTime = initialPhotoTimestamp!.toDate();
  final elapsedHours = now.difference(initialPhotoTime).inHours;
  // Eligible to take a follow-up photo starting 48 hours after the initial photo
  return elapsedHours >= 48 && elapsedHours <= 72;
}

String? getFollowUpPhotoCountdown() {
  if (!initialPhotoTaken || initialPhotoTimestamp == null) return null;
  final now = DateTime.now();
  final initialPhotoTime = initialPhotoTimestamp!.toDate();
  final elapsedHours = now.difference(initialPhotoTime).inHours;

  if (elapsedHours < 48) {
    // Not yet eligible for follow-up photo, show countdown to 48-hour mark
    final hoursRemaining = 48 - elapsedHours;
    return "$hoursRemaining hours until follow-up photo can be taken";
  } else if (elapsedHours <= 72) {
    // Within the 24-hour window for taking a follow-up photo
    final hoursRemaining = 72 - elapsedHours;
    return "Eligible for follow-up photo. $hoursRemaining hours remaining";
  }

  // Window has passed
  return "Follow-up photo window has closed";
}

}
