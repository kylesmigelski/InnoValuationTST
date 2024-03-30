const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

// This function will run every 15 minutes and check all users
exports.scheduledCheckForFollowUpPhoto = functions.pubsub.schedule('every 15 minutes').onRun(async (context) => {
  const usersRef = admin.firestore().collection('users');
  const now = admin.firestore.Timestamp.now().toDate();

  const usersSnapshot = await usersRef.get();

  for (const userDoc of usersSnapshot.docs) {
    const userData = userDoc.data();
    const initialPhotoTimestamp = userData.initialPhotoTimestamp ? userData.initialPhotoTimestamp.toDate() : null;
    const followUpPhotoTaken = userData.followUpPhotoTaken;

    if (initialPhotoTimestamp && !followUpPhotoTaken) {
      const elapsedTimeMs = now.getTime() - initialPhotoTimestamp.getTime();
      const elapsedTimeHours = elapsedTimeMs / (1000 * 60 * 60);
      const canTakeFollowUpPhoto = elapsedTimeHours >= 48 && elapsedTimeHours <= 72;

      // If the user is now eligible to take a follow-up photo, but the status hasn't been updated yet
      if (canTakeFollowUpPhoto && !userData.canTakeFollowUpPhoto) {
        await usersRef.doc(userDoc.id).update({ 
          canTakeFollowUpPhoto: true,
          notification20HoursSent: false, 
          notification23HoursSent: false
      });
        // Send a notification immediately
        await sendPushNotification(userData.token, 'Follow-Up Photo', 'You can now take your follow-up photo!');
      }

      // Check for 20 hours after eligibility (68 hours since initial photo)
      if (elapsedTimeHours >= 68 && elapsedTimeHours < 68.25 && !userData.notification20HoursSent) {
        await sendPushNotification(userData.token, 'Reminder', 'You have 4 hours left to take your follow-up photo!');
        await usersRef.doc(userDoc.id).update({ notification20HoursSent: true });
      }

      // Check for 23 hours after eligibility (71 hours since initial photo)
      if (elapsedTimeHours >= 71 && elapsedTimeHours < 71.25 && !userData.notification23HoursSent) {
        await sendPushNotification(userData.token, 'Last Chance', 'You have 1 hour left to take your follow-up photo!');
        await usersRef.doc(userDoc.id).update({ notification23HoursSent: true });
      }

    }
  }
});

async function sendPushNotification(token, title, body) {
  if (!token) return;

  const message = {
    notification: {
      title: title,
      body: body
    },
    token: token
  };

  try {
    const response = await admin.messaging().send(message);
    console.log('Successfully sent message:', response);
  } catch (error) {
    console.log('Error sending message:', error);
  }
}
