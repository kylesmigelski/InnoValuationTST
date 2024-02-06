import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:innovaluation_tst_tester/main_menu_screen.dart';
import 'dart:async';

import 'package:innovaluation_tst_tester/theme_data.dart';


class LoginScreen extends StatefulWidget {

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  var _descriptionString = "";
  var _signInPressed = false;


  Future<String> _getAppDescriptionFromFile(BuildContext context) async {
    return await DefaultAssetBundle.of(context).loadString('assets/text/tb_description.txt');
  }

  //This is where we'll handle our functionality for going to the main menu screen
  //but for now, it'll just have a nice little placeholder that will take us to the
  //main menu screen
  void _go2MainMenu() {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MainMenuView())
    );
  }

  @override
  void initState() {

    super.initState();
    _getAppDescriptionFromFile(context).then((value) => _descriptionString = value);

  }

  @override
  Widget build(BuildContext context) {
    var signUpButtonLabel = _signInPressed ? "Sign In" : "Sign Up";

    return Scaffold(
      body: GradientContainer(
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.only(top: 300, left: 25, right: 25),
          child: Column(
            children: [
              //SizedBox(height: 100,),
              //We'll come back and put the image in here in a minute. But let's just throw the text in there first
              const Text(
                "Welcome to",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                  height: 0,
                  letterSpacing: -0.3
                ),
              ),
              const SizedBox(height: 12,),
              const Text(
                "InnoValuation TST",
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                  height: 0,
                  letterSpacing: -0.3
                ),
              ),
              const SizedBox(height: 20,),
              SizedBox(
                width: MediaQuery.of(context).size.width - 100,
                child: Text(
                  _descriptionString,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 10,),
              //This will be the button that does the Log In/Sign up stuff
              //Actually, let's make this one the sign in with google button
              // and then the one below it can be sign in/sign up
              LoginMenuButton(
                  onPressed: _go2MainMenu,
                  child: const Text(
                    "Sign in with Google",
                    style: TextStyle(
                      fontSize: 16
                    ),
                  )
              ),
              const SizedBox(height: 25,),
              //This next one will be sign in/sign up
              LoginMenuButton(
                onPressed: _go2MainMenu,
                child: Text(
                  _signInPressed ? "Sign In" : "Sign Up",
                  style: const TextStyle(
                    fontSize: 16
                  ),
                )
              ),
              const SizedBox(height: 20,),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: !_signInPressed ? "Already have an account? " : "Don't have an account? ",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400
                      )
                    ),
                    TextSpan(
                      text: !_signInPressed ? 'Sign In' : 'Sign Up',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700
                      ),
                      recognizer: TapGestureRecognizer()..onTap = () => setState(() {
                        _signInPressed = !_signInPressed;
                      })
                    )
                  ]
                )
              )
            ],
          ),
        ),
      ),
    );
  }

}