# InnoValuation TST Application

## Overview

InnoValuation TST Application is a cross-platform mobile app designed to improve the follow-up rates of Tuberculosis Skin Testing (TST) by allowing patients to upload photos of their injection site instead of returning to the testing center. Developed using Flutter and Firebase, this application enables healthcare providers to monitor and manage TST results remotely, potentially reducing the spread of Tuberculosis.

## Team

- Lucas Myers
- Adam Winebarger
- Kyle Smigelski

## Sponsor

- Dr. Linda Chamberlain

## Features

- Cross-platform mobile app support for both iOS and Android.
- Integration with Firebase for authentication, database management, and push notifications.
- Secure photo uploads and geolocation tracking to monitor Tuberculosis infection trends.
- Dynamic UI elements that guide the user through the testing process.

## Requirements

- Flutter (latest version)
- Android Studio or Visual Studio Code with Flutter plugins installed
- Firebase project setup with Firestore, Authentication, and Cloud Functions enabled

## Flutter Environment Setup

1. **Install Flutter**:
   - Download the latest stable version of Flutter from the [Flutter official website](https://flutter.dev/docs/get-started/install).

2. **Verify installation**:
   - Run `flutter doctor` in your terminal or command prompt to check that everything is set up correctly. Follow any recommendations to install missing components.

## Setup Instructions

1. **Clone the repository**:
git clone [https://github.com/gvsucis/w24-innovaluation.git]

2. **Install dependencies**:
- Navigate to the project directory:
  ```
  cd path-to-your-project
  ```
- Run the following command to get all the required packages:
  ```
  flutter pub get
  ```

## Firebase Database Setup

1. **Create Firestore Database**:
- Navigate to the Firebase console.
- Go to the Firestore section and create a database in test mode or locked mode based on your security preference.
- Define your collections: `users`, `images`, and `administrators`.

2. **Set Firestore Rules**:
- For development, you can start with test mode (allows read/write for all users):
  ```
  service cloud.firestore {
    match /databases/{database}/documents {
      match /{document=**} {
        allow read, write: if true;
      }
    }
  }
  ```

## Build and Run

1. **For Android**:
```flutter run --release -d android```

2. **For iOS**:
```flutter run --release -d ios```

### Important Notes for any current/future developers on this project using the Apple chipset

Installing Flutter packages via a computer with x86 architecture tends to set them up in a weird way where the Apple M-series machines won't be able to properly build out the project. So if you're running into issues where the command line is saying that the build failed to run pod install or pod update, just run these commands from the terminal in the ios directory of this project:

```
sudo arch -x86_64 gem install ffi
arch -x86_64 pod install
```

if it's still failing to build after that, then input:

```
arch -x86_64 pod install --repo-update
```

... after that, the thing should be able to build without issues. I don't know why installing packages on a flutter project from a silicon mac doesn't cause issues on x86 machines. But, having lost a lot of time cloning Flutter projects that had updates done on x86 machines to my M1 mac, I figure this will be helpful for future reference. Enjoy.
