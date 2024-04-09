import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:innovaluation_tst_tester/theme_data.dart';
import 'package:innovaluation_tst_tester/main_menu_screen.dart';
import 'package:innovaluation_tst_tester/request_notification_permission.dart';

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
  var _isAuthenticating = false, _inputStringValid = false;
  var _passwordString = "", _usernameString = "";

  @override
  void initState() {
    super.initState();
    _getAppDescriptionFromFile().then((value) {
      setState(() {
        _descriptionString = value;
      });
    });
  }

  Future<String> _getAppDescriptionFromFile() async {
    final str = await DefaultAssetBundle.of(context).loadString('assets/text/tb_description.txt');
    return str;
  }

  

  void _loginPressed() async {
    setState(() {
      _isAuthenticating = true;
    });
    
    _usernameString = _usernameString.trim();

    try {
      final userCreds = await _firebaseAuth.signInWithEmailAndPassword(
          email: "$_usernameString@test.com", password: _passwordString);

      if (userCreds.user != null) {
        setupNotifications(); // Setup notifications only after user is logged in
        NotificationPermissionRequester(context).requestPermission();
        _go2MainMenu(); // Navigate to main menu after login
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == 'user-not-found' || error.code == 'wrong-password' || error.code == 'invalid-credential') {
        _showLoginErrorDialog();
      } else {
      print(error);
      print(error.code);
      } 
      setState(() {
        _isAuthenticating = false;
      });
    }
  }

  void _showLoginErrorDialog() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Login Failed", style: TextStyle(color: Colors.black)),
        content: Text("Wrong username/password. Please try again.", style: TextStyle(color: Colors.black)),
        actions: <Widget>[
          TextButton(
            child: Text("OK", style: TextStyle(color: Colors.black)),
            onPressed: () {
              Navigator.of(context).pop(); // Dismiss
            },
          ),
        ],
      );
    },
  );
}


  void _go2MainMenu() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => MainMenuView()));
  }

void setupNotifications() async {
    NotificationManager manager = NotificationManager();
    await manager
        .initToken(); 
  }

Widget _buildLogo(BuildContext context) {
  // Use a fraction of the screen size for the logo's size.
  double size = MediaQuery.of(context).size.width * 0.6;
  return Container(
    width: size,
    height: size,
    child: ClipRect(child: _logoSVG),
  );
}

  Widget _buildWelcomeText(BuildContext context) {
    double fontSizeTitle = MediaQuery.of(context).size.width * 0.05; // Example dynamic sizing
    double fontSizeSubtitle = MediaQuery.of(context).size.width * 0.1; // Example dynamic sizing

    return Column(
      children: [
        Text(
          "Welcome to",
            style: TextStyle(fontSize: fontSizeTitle, fontFamily: 'SF-Pro', fontWeight: FontWeight.w700, height: 0, letterSpacing: -0.3),
        ),
        const SizedBox(height: 5),
        AutoSizeText(
          "InnoValuation TST",
          style: TextStyle(fontSize: fontSizeSubtitle, fontWeight: FontWeight.w900, height: 0),
          maxLines: 1,
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildDescription() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.78,
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: _descriptionString,
          style: const TextStyle(fontSize: 14, color: Color(0xFFEDEDED), fontWeight: FontWeight.w300),
        ),
      ),
    );
  }

  Widget _buildUsernameField() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.78,
      height: 60,
      child: TextFormField(
        decoration: InputDecoration(
          border: OutlineInputBorder(borderSide: const BorderSide(color: Colors.white, width: 5), borderRadius: BorderRadius.circular(25)),
          hintText: 'Input User Name',
          hintStyle: const TextStyle(fontSize: 16, color: Color(0xFFEDEDED), fontWeight: FontWeight.w300),
        ),
        onChanged: (value) {
          _usernameString = value;
        },
      ),
    );
  }

  Widget _buildPasswordField() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.78,
      height: 60,
      child: TextFormField(
        obscureText: true,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderSide: const BorderSide(color: Colors.white, width: 5), borderRadius: BorderRadius.circular(25)),
          hintText: 'Password',
          hintStyle: const TextStyle(fontSize: 16, color: Color(0xFFEDEDED), fontWeight: FontWeight.w300),
        ),
        onChanged: (value) {
          _passwordString = value;
        },
      ),
    );
  }

  Widget _buildLoginButton() {
    return LoginMenuButton(
      onPressed: _loginPressed,
      child: const Text(
        "Log in",
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: GradientContainer(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.05,
            left: 25,
            right: 25,
            bottom: MediaQuery.of(context).viewInsets.bottom + 25,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                children: [
                  _buildLogo(context),
                  _buildWelcomeText(context),
                  _buildDescription(),
                  const SizedBox(height: 10),
                  _buildUsernameField(),
                  SizedBox(height: 15),
                  _buildPasswordField(),
                  const SizedBox(height: 25),
                  _buildLoginButton(),
                  SizedBox(height: 70),
                ],
              ),
              Positioned(
                bottom: 3,
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

class NotificationManager {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> initToken() async {
    String? token = await _firebaseMessaging.getToken();
    if (token != null) {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser?.uid)
          .set({'token': token}, SetOptions(merge: true));
    }
  }
}
