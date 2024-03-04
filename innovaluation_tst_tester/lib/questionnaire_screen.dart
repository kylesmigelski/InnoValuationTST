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
    "Have you been in contact with someone who was confirmed positive for TB in the past 3 days",
    "Are you immunocompromised?"
  ];
  final List<bool> _answers = []; //might not user this
  final Map<String, bool> _answerMap = {};

  var _counter = 0;
  //var _currentQuestion = "";

  bool? _selectedAnswer;

  List<Widget> _setUpRadioButtons() {
    List<Widget> widgetList = [];

    for (final answer in ["yes", "no"]) {
      widgetList.add(
        ListTile(
          title: Text(
              answer,
            style: TextStyle(
              fontSize: 22,
              color: Colors.white
            ),
          ),

          leading: Radio<bool>(
            fillColor: MaterialStateProperty.resolveWith((states) => Colors.white),
            activeColor: Colors.white,

            value: (answer == "yes") ? true : false,
            onChanged: (bool? value) {
              setState(() {
                _selectedAnswer = value;
              });
            }, groupValue: _selectedAnswer,
          ),
        )
      );
    }

    return widgetList;
  }

  void _submitButtonPressed() async {

    for (int i = 0; i < _questionList.length; i++) {
      _answerMap[_questionList[i]] = _answers[i];
    }
    
    final answersDocumentPath = "${_authenticatedUser.uid}";
    final username = _authenticatedUser.email!.substring(0,
      _authenticatedUser.email!.indexOf('@')
    );
    
    await FirebaseFirestore.instance.collection('users').doc(answersDocumentPath)
      .set({
      'username' : username,
      'Answers' : _answerMap
    });

    setState(() {
      Navigator.of(context).pop();
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Questionnaire"),
      ),
      body: GradientContainer(
        child: Container(
          padding: EdgeInsets.only(top: 100, left: 25, right: 25, bottom: 200),
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            //crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      _counter < _questionList.length ? _questionList[_counter] : "You're finished!",
                      style: TextStyle(
                          fontSize: 22
                      ),
                    )
                ),
              ),
              SizedBox(height: 25,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_counter < _questionList.length)
                    for (final item in _setUpRadioButtons())
                      Container(
                        width: 150,
                        child: item,
                      )
                ],
              ),
              SizedBox(height: 25,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //Next Button
                  if (_counter < _questionList.length)
                    ElevatedButton(
                      onPressed: () {
                        if (_selectedAnswer != null) {
                          setState(() {
                            _answers.add(_selectedAnswer!);
                            _selectedAnswer = null;
                            _counter++;
                          });
                        }
                      },
                      child: Text("Next")
                    ),
                  SizedBox(width: 25,),
                  //Back Button
                  ElevatedButton(
                    onPressed: () {
                      if (_counter == 0) {
                        Navigator.of(context).pop();
                      }

                      setState(() {
                        --_counter;
                        _selectedAnswer = _answers[_counter];
                        _answers.removeAt(_answers.length - 1);
                      });
                    },
                    child: Text("Back")
                  ),
                  SizedBox(width: 25,),
                  //Finished Button
                  if (_counter == _questionList.length)
                    ElevatedButton(
                      onPressed: _submitButtonPressed,
                      child: Text("Submit")
                    )
                ],
              )
            ],
          ),
        )
      ),
    );
  }

}