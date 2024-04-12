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
      ],
      child: MyApp(),
    ),
  );
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  MyApp({super.key});

  var _hasAuthToken = false;

  // So this widget serves as basically the root of our application.
  // and that ends up being super convinient as we can do things that should
  // remain relatively consistent over the course of the application as a whole
  // (theme data, for example). The other nice thing is that if we make our component
  // parts of the application into their own classes/widgets, then we can simply call them from here
  //
  // This will allow us to work on things outside of the order that we might otherwise have to
  // For example, I don't feel like doing login stuff right now and would rather
  // focus on the menu that a user would see after they logged in. So I'm going to
  // create a main menu widget in a separate file (remember to import) and then call
  // that in the home parameter of our MaterialApp object (though it might still say
  // test widge at the time that you're reading this... in which case all I've done
  // so far is set up consistent theming for the application)
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



