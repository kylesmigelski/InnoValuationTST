import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationPermissionRequester {
  final BuildContext context;

  NotificationPermissionRequester(this.context);

  Future<void> requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("User granted permission");
      // You can now use FCM
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print("User granted provisional permission");
      // You can use FCM but with some limitations
    } else {
      // Permission was denied. direct users to the settings
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text("Notifications Permission"),
          content: Text("This app needs notification permissions to function correctly."),
          actions: <Widget>[
            TextButton(
              child: Text("Settings"),
              onPressed: () {
                Navigator.of(context).pop();
                // Direct user to app settings
              },
            ),
            TextButton(
              child: Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    }
  }
}
