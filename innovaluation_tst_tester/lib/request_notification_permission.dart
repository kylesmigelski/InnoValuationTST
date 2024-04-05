import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:app_settings/app_settings.dart';

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

    // Handle permission status
    handlePermissionStatus(settings.authorizationStatus);
  }

  void handlePermissionStatus(AuthorizationStatus status) {
    switch (status) {
      case AuthorizationStatus.authorized:
        print("User granted permission");
        // User granted permission
        break;
      case AuthorizationStatus.provisional:
        print("User granted provisional permission");
        // User granted provisional permission
        break;
      default:
        // Permission was denied or not determined
        showPermissionDialog();
        break;
    }
  }

  void showPermissionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text("Notifications Permission", style: TextStyle(color: Colors.black)),
        content: const Text("This app needs notification permissions to function correctly. Would you like to open app settings to modify app permissions?", style: TextStyle(color: Colors.black)),
        actions: <Widget>[
          TextButton(
            child: const Text("Open Settings", style: TextStyle(color: Colors.black)),
            onPressed: () {
              Navigator.of(context).pop();
              AppSettings.openAppSettings(type: AppSettingsType.notification);
            },
          ),
          TextButton(
            child: const Text("Cancel", style: TextStyle(color: Colors.black)),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Future<void> toggleNotification() async {
    // Since directly turning off notifications is not possible, show a dialog instead.
  showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text("Disable Notifications", style: TextStyle(color: Colors.black)),
        content: const Text("If you want to disable notifications, you need to do it manually in the app settings.", style: TextStyle(color: Colors.black)),
        actions: <Widget>[
          TextButton(
            child: const Text("Open Settings", style: TextStyle(color: Colors.black)),
            onPressed: () {
              Navigator.of(context).pop();
              AppSettings.openAppSettings(type: AppSettingsType.notification);
            },
          ),
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
