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

//parameters are a little weird here. But basically we've got a default for size,
//but if you want size to be something different when calling this function,
// you would have to write "size: x" where x is an int
ButtonStyle bigButtonStyle1(BuildContext context, {int size = 22}) {
  return ElevatedButton.styleFrom(
    side: BorderSide(width: 1),
    minimumSize: const Size(250, 40),
    //backgroundColor
  );
} //we might axe this function here since it isn't really acheiving its job now
//although the specs are somewhat close to what we'll probably want to use for the login
// buttons, it might be worth leaving in for the time being.

//Since there's not really a good way to incorporate gradient backgrounds into
//the theme data of Material App, I just made a class that extends container
// for ease-of-use in setting up that gradient background. Probably won't have to
// use this more than 2 or 3 times but it will make for ease-of-use in the places
// that we do use it. So yeah, just call this as the first child in the appbar
// and then call our actual components as the child of GradientContainer
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

  BigMenuButton({
    Key? key,
    this.onPressed,
    required this.label,
    required this.svg,
  }) : super(key: key);

  Widget _buildSVGFromString(BuildContext context, double minWidth) {
    // SVG size is now more responsive to the button width
    double svgSize = minWidth * 0.2; // Adjust this value as needed
    return SvgPicture.asset(
      svg,
      semanticsLabel: svg.substring("assets/images/".length),
      height: svgSize,
      width: svgSize,
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
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Color(0x16000000),
                blurRadius: 8,
                offset: Offset(0, 2),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Make the column's height fit its children
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 16, // Adjust font size as needed
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(height: 8), // Space between text and SVG
              Align(
                alignment: Alignment.bottomRight,
                child: _buildSVGFromString(context, buttonWidth),
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
