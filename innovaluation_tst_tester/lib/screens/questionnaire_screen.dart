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
    "Have you been in contact with someone who was confirmed positive for Tuberculosis?",
    "Have you been in contact with someone with the flu?",
    "Do you have fits of coughing or flu-like symptoms?"
  ];
  List<bool?> _answers = List.filled(4, null);
  final Map<String, bool?> _answerMap = {};

  // Counter for the current question
  var _counter = 0;
  bool? _selectedAnswer;
  bool _hasMadeChoice = false;

  double get _progressValue {
    // Calculate the progress including the user's selection
    return (_counter + (_hasMadeChoice ? 1 : 0)) / _questionList.length;
  }

  void _handleNext() {
    if (_hasMadeChoice || _selectedAnswer != null) {
      // Move to the next question
      setState(() {
        _counter++;
        _hasMadeChoice = false; // Reset choice indicator
        _selectedAnswer = null; // Reset the selected answer for the next question
      });
    }
  }

  void _handleBack() {
    // Logic to handle the back action
    setState(() {
      if (_counter > 0) _counter--;
      _hasMadeChoice = _answers[_counter] != null; // Check if the previous question was answered
      _selectedAnswer = _answers[_counter]; // Restore the selected answer for the current question
    });
  }

  void _submitButtonPressed() async {
    for (int i = 0; i < _questionList.length; i++) {
      _answerMap[_questionList[i]] = _answers[i];
    }

    //here's another place where we use just UID
    final answersDocumentPath = "${_authenticatedUser.uid}";
    final username = _authenticatedUser.email!
        .substring(0, _authenticatedUser.email!.indexOf('@'));

    await FirebaseFirestore.instance
        .collection('users')
        .doc(answersDocumentPath)
        .set({'username': username, 'Answers': _answerMap, 'questionnaireCompleted': true}, SetOptions(merge: true));

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "Health Questionnaire",
          style: TextStyle(color: Colors.white),
        ),
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
      // White background container with rounded corners
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.only(top: 1),
        decoration: const ShapeDecoration(
          color: Color.fromARGB(255, 237, 237, 237),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        ),

        padding: EdgeInsets.symmetric(vertical: 25, horizontal: 25),
        child: Column(
          children: [
            _QuizProgressBar(currentQuestionIndex: _counter, progressValue: _progressValue),
            SizedBox(height: 40),
            _buildQuestionsAndAnswers(),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionsAndAnswers() {
    // Question
    _selectedAnswer = _answers[_counter];
    return Column(
      children: [
        if (_counter < _questionList.length)
          Text(
            _questionList[_counter],
            style: TextStyle(
                color: Colors.black,
                fontSize: 26,
                fontWeight: FontWeight.w600,
                height: 0),
            textAlign: TextAlign.left,
          ),
        // Add some space between the question and the answer buttons
        SizedBox(height: 40),
        if (_counter < _questionList.length) ..._setUpAnswerButtons(),

        // Add some space between the answer buttons and the navigation buttons
        SizedBox(height: 80),
        _buildNavigationButtons(),
      ],
    );
  }

  ButtonStyle _answerButtonStyle(bool isSelected, BuildContext context) {
    return ElevatedButton.styleFrom(
      backgroundColor: isSelected ? Color(0xFF2B1953) : Colors.white,
      foregroundColor: isSelected ? Colors.white : Colors.black,
      side: isSelected
          ? BorderSide.none
          : BorderSide(color: Theme.of(context).primaryColor),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: isSelected ? 6 : 3,
      padding: EdgeInsets.symmetric(
          horizontal: 20, vertical: 20), // Padding inside the button
      // Minimum size can be adjusted as needed
      minimumSize: Size(150, 70),
    );
  }

  List<Widget> _setUpAnswerButtons() {
    return ["Yes", "No"].map((answer) {
      bool isSelected = _selectedAnswer == (answer == "Yes");
      return Padding(
        padding: const EdgeInsets.symmetric(
            vertical: 12), // Adds padding between the buttons
        child: ElevatedButton(
          style: _answerButtonStyle(isSelected, context),
          onPressed: () {
            setState(() {
              _selectedAnswer = answer == "Yes";
              _answers[_counter] = _selectedAnswer; // Store the answer
              _hasMadeChoice = true;
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment
                .start, // Aligns content to the left side of the button
            children: [
              // The custom radio button icon
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? Theme.of(context).primaryColor
                        : Colors.grey, // Border color
                    width: 2.0,
                  ),
                  color: isSelected
                      ? Theme.of(context).primaryColor
                      : Colors.transparent, // Fill color
                ),
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: isSelected
                      ? Icon(
                          Icons.circle,
                          size: 12.0,
                          color:
                              Colors.blue, // Inner circle color when selected
                        )
                      : Icon(
                          Icons.circle,
                          size: 12.0,
                          color: Colors
                              .transparent, // Inner circle color when not selected
                        ),
                ),
              ),
              SizedBox(
                  width:
                      20), // Provide some space between the icon and the text
              Text(
                answer,
                style: TextStyle(fontSize: 22),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  Widget _buildNavigationButton(
      String label, IconData icon, VoidCallback onPressed, bool isPrimary) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon:
          Icon(icon, size: 24, color: isPrimary ? Colors.white : Colors.black),
      label: Text(label,
          style: TextStyle(color: isPrimary ? Colors.white : Colors.black)),
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary ? Colors.blue : Color(0xFFD9D9D9),
        foregroundColor: Colors.black,
        padding:
            EdgeInsets.symmetric(horizontal: isPrimary ? 50 : 20, vertical: 20),
        shape: StadiumBorder(),
        elevation: 2,
        textStyle: TextStyle(fontSize: 18),
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        if (_counter > 0)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: _buildNavigationButton(
                "Back", Icons.arrow_back, _handleBack, false),
          ),
        if (_counter < _questionList.length - 1)
          _buildNavigationButton(
              "Next", Icons.arrow_forward, _handleNext, true),
        if (_counter == _questionList.length - 1)
          _buildNavigationButton(
              "Submit", Icons.check, _submitButtonPressed, true),
      ],
    );
  }
}

class _QuizProgressBar extends StatelessWidget {
  final int currentQuestionIndex;
  final int totalQuestions = 3;
  final double progressValue;

  _QuizProgressBar({
    Key? key,
    required this.currentQuestionIndex,
    required this.progressValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 8), // Spacing between text and progress bar
        Stack(
          children: [
            Container(
              height: 8,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: AnimatedContainer(
                height: 8,
                width: MediaQuery.of(context).size.width * progressValue,
                duration: Duration(milliseconds: 100),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(1.00, 0.00),
                    end: Alignment(-1, 0),
                    colors: [Color(0xFF4B82C4), Color(0xFF7A49E3)],
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12), // Spacing between progress bar and text
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Question ${currentQuestionIndex + 1} of $totalQuestions",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF646464),
            ),
          ),
        ),
      ],
    );
  }
}
