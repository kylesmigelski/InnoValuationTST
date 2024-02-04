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
              Text(
                "Welcome to",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                  height: 0,
                  letterSpacing: -0.3
                ),
              ),
              SizedBox(height: 12,),
              Text(
                "InnoValuation TST",
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                  height: 0,
                  letterSpacing: -0.3
                ),
              ),
              SizedBox(height: 20,),
              SizedBox(
                width: MediaQuery.of(context).size.width - 100,
                child: Text(
                  _descriptionString,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 10,),
              //This will be the button that does the Log In/Sign up stuff
              LoginMenuButton(
                  onPressed: () {
                    //This is just going to be a placeholder for now. Probably
                    //going to make an actual function up top to handle the logic
                    //for whether this thing attempts to log in or go to the sign up menu
                    //But for now...
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MainMenuView())
                    );
                  },
                  child: Text(
                    signUpButtonLabel,
                    style: const TextStyle(
                      fontSize: 16
                    ),
                  )
              )
            ],
          ),
        ),
      ),
    );
  }

}