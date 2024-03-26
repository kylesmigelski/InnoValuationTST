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

  Duration? getInitialPhotoCountdownDuration() {
    if (!initialPhotoTaken || initialPhotoTimestamp == null) return null;
    final initialPhotoTime = initialPhotoTimestamp!.toDate();
    final deadline = initialPhotoTime.add(Duration(hours: 48));
    return deadline.difference(DateTime.now());
  }

  Duration? getFollowUpPhotoCountdownDuration() {
    if (!initialPhotoTaken || initialPhotoTimestamp == null) return null;
    final initialPhotoTime = initialPhotoTimestamp!.toDate();
    final followUpDeadline = initialPhotoTime.add(Duration(hours: 72));
    if (DateTime.now().isBefore(followUpDeadline)) {
      return followUpDeadline.difference(DateTime.now());
    }
    return null; // Follow-up photo window has closed
  }

}
