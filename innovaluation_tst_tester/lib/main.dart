import 'package:flutter/material.dart';
import 'main_menu_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
      theme: ThemeData(
        primaryColor: Colors.white60,
        brightness: Brightness.light,
        textTheme: Theme.of(context).textTheme.apply(
          bodyColor: Colors.white
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
      home: MainMenuView(),
    );
  }
}

class _TestWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Innovaluation TST"),
        backgroundColor: Colors.green,
      ),
      body: const Center(
        child: Text("This is a test widget"),
      ),
    );
  }

}
