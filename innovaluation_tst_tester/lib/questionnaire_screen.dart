import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:innovaluation_tst_tester/theme_data.dart';

final _authenticatedUser = FirebaseAuth.instance.currentUser!;

class QuestionnaireScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QuestionnaireScreenState();
}

class _QuestionnaireScreenState extends State<QuestionnaireScreen> {
  final _questionList = [
    "Have you been out of the country in the past 30 days?",
    "Have you been in contact with someone who was confirmed positive for Tuberculosis in the past 3 days?",
    "Are you immunocompromised?"
  ];
  final List<bool> _answers = [];
  final Map<String, bool> _answerMap = {};

  var _counter = 0;
  bool? _selectedAnswer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text("Health Questionnaire",
        style: TextStyle(color: Colors.white),),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: GradientContainer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildHeaderSection(),
            _buildContentSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    // Placeholder for any header content or simply adjust the flex of content section
    return Container(
      padding: EdgeInsets.symmetric(vertical: 60),
      alignment: Alignment.center,
      // Add any header content if needed
    );
  }

  Widget _buildContentSection() {
    return Expanded(
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.only(top: 1),
        decoration: const ShapeDecoration(
          color: Color(0xFFE8E8E8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), 
              topRight: Radius.circular(20)
            )
          ),
        ),
        padding: EdgeInsets.symmetric(vertical: 40, horizontal: 25),
        child: _buildQuestionsAndAnswers(),
      ),
    );
  }

  Widget _buildQuestionsAndAnswers() {
    return Column(
      children: [
        if (_counter < _questionList.length)
          Text(
            _questionList[_counter],
            style: TextStyle(fontSize: 20
            , color: Colors.black),
            textAlign: TextAlign.center,
          ),
        SizedBox(height: 40),
        ..._setUpRadioButtons(),
        SizedBox(height: 25),
        _buildNavigationButtons(),
      ],
    );
  }

  List<Widget> _setUpRadioButtons() {
    return ["yes", "no"].map((answer) {
      return ListTile(
        title: Text(
          answer,
          style: TextStyle(fontSize: 22, color: Colors.black),
        ),
        leading: Radio<bool>(
          fillColor: MaterialStateProperty.resolveWith((states) => Colors.white),
          activeColor: Colors.white,
          value: answer == "yes",
          groupValue: _selectedAnswer,
          onChanged: (bool? value) {
            setState(() {
              _selectedAnswer = value;
            });
          },
        ),
      );
    }).toList();
  }

  Widget _buildNavigationButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        if (_counter < _questionList.length)
          ElevatedButton(
            onPressed: () => _handleNext(),
            child: Text("Next"),
          ),
        if (_counter > 0) // Adjust logic as needed
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ElevatedButton(
              onPressed: () => _handleBack(),
              child: Text("Back"),
            ),
          ),
        if (_counter == _questionList.length)
          ElevatedButton(
            onPressed: _submitButtonPressed,
            child: Text("Submit"),
          ),
      ],
    );
  }

  void _handleNext() {
    if (_selectedAnswer != null) {
      setState(() {
        _answers.add(_selectedAnswer!);
        _selectedAnswer = null;
        _counter++;
      });
    }
  }

  void _handleBack() {
    setState(() {
      --_counter;
      _selectedAnswer = _answers.isNotEmpty ? _answers.last : null;
      if (_answers.isNotEmpty) {
        _answers.removeLast();
      }
    });
  }

  void _submitButtonPressed() async {
    for (int i = 0; i < _questionList.length; i++) {
      _answerMap[_questionList[i]] = _answers[i];
    }

    final answersDocumentPath = "${_authenticatedUser.uid}";
    final username = _authenticatedUser.email!.substring(0, _authenticatedUser.email!.indexOf('@'));

    await FirebaseFirestore.instance.collection('users').doc(answersDocumentPath).set({
      'username': username, 
      'Answers': _answerMap
    });

    Navigator.of(context).pop();
  }
}
