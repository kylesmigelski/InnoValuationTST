import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

//I guess we'll put important constants up here that need to be referenced
final Widget logoSVG = SvgPicture.asset(
  'assets/images/logoIcon.svg',
  semanticsLabel: 'logo',
);

final Widget innoLogoSVG = SvgPicture.asset(
  'assets/images/logo.svg',
  semanticsLabel: 'inno_logo',
);

final Widget cameraSVG = SvgPicture.asset(
  'assets/images/camera.svg',
  semanticsLabel: 'camera',
);

ButtonStyle bigButtonStyle1(BuildContext context, {int size = 22}) {
  return ElevatedButton.styleFrom(
    side: BorderSide(width: 1),
    minimumSize: const Size(250, 40),
    //backgroundColor
  );
} 
class GradientContainer extends Container {
  GradientContainer({super.key, super.child}) : super();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
          gradient: LinearGradient(
                  colors: [
            Color(0xFF4BABC4),
            Color(0xFF5D4493),
            Color(0xFF2B1953)
          ],
                  begin: Alignment.topLeft, // More readable and angled
                  end: Alignment.bottomRight // More readable and angled
                  )),
      child: child,
    );
  }
}

class BigMenuButton extends StatelessWidget {
  final void Function()? onPressed;
  final String label;
  final String svg;
  Color buttonColor;
  Color textColor;
  String? notifSVGPath;

  BigMenuButton({
    Key? key,
    this.onPressed,
    required this.label,
    required this.svg,
    this.buttonColor = Colors.white,
    this.textColor = Colors.black,
    this.notifSVGPath,
  }) : super(key: key);

  Widget _buildSVGFromString(BuildContext context, double minWidth) {
    // SVG size is now more responsive to the button width
    double svgSize = minWidth * 0.2; // Adjust this value as needed
    return SvgPicture.asset(
      svg,
      semanticsLabel: svg.substring("assets/images/".length),
      height: svgSize,
      width: svgSize,
      color: Colors.grey[500],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final buttonWidth = 0.5 * (screenWidth - 60); // 50% of screen width minus margins
    final buttonHeight = MediaQuery.of(context).size.height * 0.2; // Adjust based on your needs

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: buttonWidth,
          // Remove fixed height to allow content to determine the height
          padding: const EdgeInsets.all(16), // Padding inside the button
          decoration: BoxDecoration(
            color: buttonColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 10,
                offset: Offset(0, 3),
                spreadRadius: 0,
              ),
            ],
          ),
          child:Column(
  mainAxisSize: MainAxisSize.min, // Make the column's height fit its children
  mainAxisAlignment: MainAxisAlignment.start,
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space between items in the row
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16, // Adjust font size as needed
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        // Assuming _buildSVGFromString builds an SVG from assets
        if (notifSVGPath != null) SvgPicture.asset(notifSVGPath!),
      ],
    ),
    SizedBox(height: 8), // Space below the row if needed for additional components
    Align(
      alignment: Alignment.bottomRight,
      child: _buildSVGFromString(context, buttonWidth), // Additional SVG if needed at bottom right
    ),
  ],
),

        ),
      ),
    );
  }
}

class LoginMenuButton extends Container {
  LoginMenuButton({super.key, required this.onPressed, required super.child})
      : super();

  void Function()? onPressed;
  //Text label;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: child,
      style: ElevatedButton.styleFrom(
          minimumSize: Size(MediaQuery.of(context).size.width * 0.7, 55),
          maximumSize: Size(MediaQuery.of(context).size.width * 0.75, 55)),
    );
  }
}
