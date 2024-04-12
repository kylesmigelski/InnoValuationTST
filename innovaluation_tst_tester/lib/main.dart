import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'utils/firebase_options.dart';
import 'package:innovaluation_tst_tester/widgets/splash.dart';
import 'screens/main_menu_screen.dart';
import 'screens/login_screen.dart';
import 'providers/auth_provider.dart';
import 'providers/camera_state_provider.dart';
import 'providers/button_state_provider.dart';
import 'providers/dialog_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    // Wrap the MyApp widget with ChangeNotifierProvider
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthenticationProvider()),
        ChangeNotifierProvider(create: (_) => CameraStateProvider()..initializeCamera()),
        ChangeNotifierProvider(create: (context) => ButtonStateProvider()),
        ChangeNotifierProvider(create: (context) => DialogManager(context)),
      ],
      child: MyApp(),
    ),
  );
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  MyApp({super.key});

  var _hasAuthToken = false;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Innovaluation TST App',
      navigatorKey: navigatorKey,
      theme: ThemeData(
        primaryColor: Colors.white,
        brightness: Brightness.light,
        textTheme: Theme.of(context).textTheme.apply(
          bodyColor: Colors.white,
          fontFamily: 'SF-Pro'
        ),
        buttonTheme: const ButtonThemeData(
          buttonColor: Colors.green,
        ),
          //this will make it so that the colors are consistent across each of our
          //Figure we will be sticking with black text on a white background for
          // most of the buttons we end up using so setting it here will keep us
          // from having to manually write it every time
          elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            textStyle: const TextStyle(
              fontSize: 12
            )
          )
        )
      ),
      //home: _hasAuthToken ? MainMenuView() : LoginScreen(),
      home: Scaffold(
        body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return const SplashScreen();
            }

            return (dataSnapshot.hasData) ? MainMenuView() : LoginScreen();
          },
        ),
      ),
    );
  }
}



