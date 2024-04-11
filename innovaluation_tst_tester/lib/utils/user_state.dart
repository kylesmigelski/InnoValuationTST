import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserState {
  final bool questionnaireCompleted;
  final bool initialPhotoTaken;
  final Timestamp? initialPhotoTimestamp;
  final bool followUpPhotoTaken;
  final Timestamp? followUpPhotoTimestamp;
  final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
  final bool faceVerified;

  UserState({
    required this.questionnaireCompleted,
    required this.initialPhotoTaken,
    this.initialPhotoTimestamp,
    required this.followUpPhotoTaken,
    this.followUpPhotoTimestamp,
    required this.faceVerified,
  });

  factory UserState.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>? ?? {};

    return UserState(
      questionnaireCompleted: data['questionnaireCompleted'] ?? false,
      initialPhotoTaken: data['initialPhotoTaken'] ?? false,
      initialPhotoTimestamp: data['initialPhotoTimestamp'],
      followUpPhotoTaken: data['followUpPhotoTaken'] ?? false,
      followUpPhotoTimestamp: data['followUpPhotoTimestamp'],
      faceVerified: data['faceVerified'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'questionnaireCompleted': questionnaireCompleted,
      'initialPhotoTaken': initialPhotoTaken,
      'initialPhotoTimestamp': initialPhotoTimestamp,
      'followUpPhotoTaken': followUpPhotoTaken,
      'followUpPhotoTimestamp': followUpPhotoTimestamp,
      'faceVerified': faceVerified,
    };
  }

  UserState copyWith({
    bool? questionnaireCompleted,
    bool? initialPhotoTaken,
    Timestamp? initialPhotoTimestamp,
    bool? followUpPhotoTaken,
    Timestamp? followUpPhotoTimestamp,
    bool? faceVerified,
  }) {
    return UserState(
      questionnaireCompleted: questionnaireCompleted ?? this.questionnaireCompleted,
      initialPhotoTaken: initialPhotoTaken ?? this.initialPhotoTaken,
      initialPhotoTimestamp: initialPhotoTimestamp ?? this.initialPhotoTimestamp,
      followUpPhotoTaken: followUpPhotoTaken ?? this.followUpPhotoTaken,
      followUpPhotoTimestamp: followUpPhotoTimestamp ?? this.followUpPhotoTimestamp,
      faceVerified: faceVerified ?? this.faceVerified,
    );
  }

bool canTakeFollowUpPhoto() {
  if (!initialPhotoTaken || initialPhotoTimestamp == null) return false;
  final now = DateTime.now();
  final initialPhotoTime = initialPhotoTimestamp!.toDate();
  final elapsedSeconds = now.difference(initialPhotoTime).inSeconds;

  // Convert hours to seconds for comparison
  const minSecondsForFollowUp = 48 * 3600;
  const maxSecondsForFollowUp = 72 * 3600;

  return elapsedSeconds >= minSecondsForFollowUp && elapsedSeconds <= maxSecondsForFollowUp;
}


  Future<void> updateCanTakeFollowUpPhoto() async {
    final bool isEligible = canTakeFollowUpPhoto();
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .update({'canTakeFollowUpPhoto': isEligible});
  }

  Duration? getLockedCountdownDuration() {
    if (!initialPhotoTaken || initialPhotoTimestamp == null) return null;
    final initialPhotoTime = initialPhotoTimestamp!.toDate();
    final deadline = initialPhotoTime.add(Duration(hours: 48));
    return deadline.difference(DateTime.now());
  }

  // 24 hours after the initial photo was taken
  int getFollowUpTimeStamp() {
    if (!initialPhotoTaken || initialPhotoTimestamp == null) return 0;
    final initialPhotoTime = initialPhotoTimestamp!.toDate();
    final followUpDeadline = initialPhotoTime.add(Duration(hours: 24));
    return followUpDeadline.millisecondsSinceEpoch;
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

  bool hasFollowUpPhotoDeadlinePassed() {
    if (!initialPhotoTaken || initialPhotoTimestamp == null) return false;
    final initialPhotoTime = initialPhotoTimestamp!.toDate();
    final followUpDeadline = initialPhotoTime.add(Duration(hours: 72));
    return DateTime.now().isAfter(followUpDeadline);
  }

}
