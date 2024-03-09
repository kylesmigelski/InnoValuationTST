import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:innovaluation_tst_tester/theme_data.dart';
import 'package:innovaluation_tst_tester/main_menu_screen.dart';

final _firebaseAuth = FirebaseAuth.instance;

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>(); //might not use this

  var _descriptionString = '';
  var _signInPressed = false;

  final _logoSVG = logoSVG;
  final _innoLogoSVG = innoLogoSVG;

  //variables pertaining to the login process
  var _isAuthenticating = false, _inputStringValid = false;
  var _passwordString = "", _usernameString = "";

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

  void _loginPressed() async {


    //This will be good for putting a little load icon-type thing in the login button
    setState(() {
      _isAuthenticating = true;
    });

    //Catch for if the input isn't valid
    if (_passwordString.length < 6) {
      //Probably should throw an error message here
      setState(() {
        _isAuthenticating = false;
      });
      return; //there's nothing left for us to do if this catchment is triggerd so we'll return
    }

    print("poop");

    try {
      final userCreds = await _firebaseAuth.signInWithEmailAndPassword(email: "$_usernameString@test.com", password: _passwordString);
      print(userCreds.toString());
    } on FirebaseAuthException catch (error) {
      print(error);
    }
    print("Butthole");
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
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
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
                  AutoSizeText(
                    "InnoValuation TST",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                      height: 0,
                    ),
                    maxLines: 1,
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
                  //I guess let's also include a container/Input field for a username as well
                  Container(
                    width: MediaQuery.of(context).size.width * 0.78,
                    child: TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.white,
                                width: 5
                            ),
                            borderRadius: BorderRadius.circular(25)
                        ),
                        hintText: 'Input User Name',
                        hintStyle: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFFEDEDED),
                            fontWeight: FontWeight.w300
                        ),
                      ),
                      validator: (value) {
                        if (value != null && value.length > 6) {
                          return null;
                        }
                        return "Invalid username";
                      },
                      onChanged: (value) {
                        _usernameString = value;
                      },
                    ),
                  ),
                  SizedBox(height: 15,),
                  //This will be the button that does the Log In/Sign up stuff
                  //Actually, let's make this one the sign in with google button
                  // and then the one below it can be sign in/sign up
                  Container(
                    width: MediaQuery.of(context).size.width * 0.78,
                    child: TextFormField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.white,
                                width: 5,
                              ),
                              borderRadius: BorderRadius.circular(25)),
                          hintText: 'Password',
                          hintStyle: const TextStyle(
                              fontSize: 16,
                              color: Color(0xFFEDEDED),
                              fontWeight: FontWeight.w300)),
                      validator: (value) {
                        if (value != null && value.length > 6) {
                          return null;
                        }
                        return "Invalid input detected";
                      },
                      onChanged: (value) {
                        _passwordString = value;
                        print(_passwordString);
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  LoginMenuButton(
                      onPressed: _loginPressed, //This will have to be changed
                      child: const Text(
                        "Check for TST number",
                        style: TextStyle(fontSize: 16),
                      )),
                  SizedBox(height: 100,),
                  // LoginMenuButton(
                  //     onPressed: _go2MainMenu, //This will have to be changed
                  //     child: const Text(
                  //       "Sign Up",
                  //       style: TextStyle(fontSize: 16),
                  //     )),

                ],
              ),
              Positioned(
                  child: ClipRect(
                    child: _innoLogoSVG,
                  ),
                bottom: 3,

              )
            ],
          )
        ),
      ),
    );
  }
}
