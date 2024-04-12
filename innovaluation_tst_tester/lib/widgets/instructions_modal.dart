import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class InstructionsModal extends StatelessWidget {
  const InstructionsModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10, left: 25, right: 25, bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Decorative top pill
          Container(
            width: 60,
            height: 5,
            margin: EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[600],
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          // Camera SVG - Placeholder for SVG file
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: SvgPicture.asset('assets/images/camera2.svg',
                height: 120, width: 120),
          ),
          // Title
          Text(
            'Taking Your Test Site Photo',
            style: TextStyle(
                fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              // Instructions
              child: Text.rich(
                TextSpan(
                  style: TextStyle(fontSize: 16, color: Colors.black), // Default text style
                  children: [
                    TextSpan(
                      text: 'Hold Steady: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                        text:
                            'To ensure clarity, the camera will wait for you to hold it still. Once you\'re ready, '),
                    TextSpan(
                      text: 'hold your device steady for 3 seconds.\n\n',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: 'Frame Carefully: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                        text:
                            'Ensure the entire test site is visible in the viewfinder.\n\n'),
                    TextSpan(
                      text: 'Review Your Photo: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                        text:
                            'After the photo is taken, check it for clarity and coverage of the test site.'),
                  ],
                ),
                textAlign: TextAlign.left,
              )),
          SizedBox(height: 30),
            ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Continue', style: TextStyle(fontSize: 20, color: Colors.white)),
            style: ElevatedButton.styleFrom(
              primary: Color(0xFF2B1953),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
              ),
              minimumSize: Size(200, 0), // Increase the width here
            ),
            ),
        ],
      ),
    );
  }
}
