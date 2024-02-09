import 'dart:math';
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
  var _descriptionString = '';
  var _signInPressed = false;

  final _logoSVG = logoSVG;
  final _innoLogoSVG = innoLogoSVG;

  Future<String> _getAppDescriptionFromFile(BuildContext context) async {
    final str = await DefaultAssetBundle.of(context)
        .loadString('assets/text/tb_description.txt');
    return str;
  }

  //This is where we'll handle our functionality for going to the main menu screen
  //but for now, it'll just have a nice little placeholder that will take us to the
  //main menu screen
  void _go2MainMenu() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MainMenuView()));
  }

  @override
  void initState() {
    super.initState();
    _getAppDescriptionFromFile(context).then((value) {
      setState(() {
        _descriptionString = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var signUpButtonLabel = _signInPressed ? "Sign In" : "Sign Up";

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: GradientContainer(
        child: SingleChildScrollView(
          //physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.only(
            top: 75,
            left: 25,
            right: 25,
            bottom: MediaQuery.of(context).viewInsets.bottom + 25,
          ),
          child: Column(
            children: [
              Container(
                  width: 250,
                  height: 250,
                  child: ClipRect(
                    child: _logoSVG,
                  )),
              //SizedBox(height: 100,),
              //We'll come back and put the image in here in a minute. But let's just throw the text in there first
              const Text(
                "Welcome to",
                style: TextStyle(
                    fontSize: 25,
                    fontFamily: 'SF-Pro',
                    fontWeight: FontWeight.w700,
                    height: 0,
                    letterSpacing: -0.3),
              ),
              const SizedBox(
                height: 5,
              ),
              const Text(
                "InnoValuation TST",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w900,
                  height: 0,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.78,
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: _descriptionString,
                    style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFFEDEDED),
                        fontWeight: FontWeight.w300),
                  ),
                ),
              ),

              const SizedBox(
                height: 10,
              ),
              //This will be the button that does the Log In/Sign up stuff
              //Actually, let's make this one the sign in with google button
              // and then the one below it can be sign in/sign up
              Container(
                width: MediaQuery.of(context).size.width * 0.78,
                child: TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.white,
                            width: 5,
                          ),
                          borderRadius: BorderRadius.circular(25)),
                      hintText: 'Input TST Number',
                      hintStyle: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFFEDEDED),
                          fontWeight: FontWeight.w300)),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              LoginMenuButton(
                  onPressed: _go2MainMenu, //This will have to be changed
                  child: const Text(
                    "Check for TST number",
                    style: TextStyle(fontSize: 16),
                  )),
              const SizedBox(
                height: 50,
              ),
              Container(
                width: 120,
                height: 120,
                child: ClipRect(
                  child: _innoLogoSVG,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
