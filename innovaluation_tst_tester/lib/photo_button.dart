import 'package:flutter/material.dart';

class CustomPhotoButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;
  final Duration remainingTime;

  const CustomPhotoButton({
    Key? key,
    required this.onPressed,
    this.buttonText = 'Take A Photo',
    required this.remainingTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate remaining time width based on the total time
    // This is just a placeholder calculation
    const double totalWidth = 217.30;
    final double remainingWidth =
        (remainingTime.inSeconds / (15 * 60)) * totalWidth;

    return ElevatedButton(
      onPressed: () {
        // Your button press action
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white, backgroundColor: const Color(0xFF2C1954), // Text and icon color
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(17), // Rounded corners
        ),
        padding: const EdgeInsets.all(0), // Reset default padding
      ),
      child: Ink(
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
              color: Color(0x3F000000),
              blurRadius: 4,
              offset: Offset(0, 4),
            ),
          ],
          borderRadius: BorderRadius.circular(17),
        ),
        child: Container(
          width: 318,
          height: 113,
          padding: const EdgeInsets.symmetric(
              horizontal: 20), // Inner padding for the button
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              const Positioned(
                left: 0,
                child: Text(
                  'Take A Photo',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'SF Pro',
                  ),
                ),
              ),
              const Positioned(
                right: 0,
                child: Icon(
                  Icons
                      .arrow_forward_ios, // This is a placeholder for the right arrow icon
                  size: 24,
                ),
              ),
              const Positioned(
                right: 40, // Adjust the position as needed
                child: Icon(
                  Icons.camera_alt, // Placeholder for the camera icon
                  size: 24,
                ),
              ),
              const Positioned(
                bottom: 20,
                child: Text(
                  '12:59:29 remaining',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontFamily: 'SF Pro',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Positioned(
                bottom: 10,
                left: 0,
                child: Stack(
                  children: [
                    Container(
                      width: 217.30,
                      height: 8.06,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD9D9D9),
                        borderRadius: BorderRadius.circular(11.23),
                      ),
                    ),
                    Container(
                      width:
                          132.85, // This width should be dynamic based on the timer
                      height: 8.06,
                      decoration: BoxDecoration(
                        color: const Color(0xFF27C31A),
                        borderRadius: BorderRadius.circular(11.23),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
