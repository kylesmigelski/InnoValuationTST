import 'package:flutter/material.dart';

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

  GradientContainer({super.key, super.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF4195E3), Color(0xFF1B1A5A)],
          begin: Alignment(0.26, -0.96),
          end: Alignment(-0.26, 0.96)
        )
      ),
      child: child,
    );
  }
}

//This will be the class for those buttons on the main menu
// Since we've got 6 of them at least, I think it will be somewhat easier to create
// these here and then just use that instead of button/container
class BigMenuButton extends Container {
  BigMenuButton({super.key, required this.onPressed, required this.label}) : super();

  //final Widget? child;
  //Will also need a variable to add an image here but I'm forgetting how to do that right now
  void Function()? onPressed;
  final Text label;



  @override
  Widget build(BuildContext context) {

    //So this math works. Will need to come back and do the math for height once we've got
    //more of the main menu going
    final minButtonWidth = 0.5 * (MediaQuery.of(context).size.width - 60);

    // TODO: implement build
    return ElevatedButton(
      //This button style setup is extremely obnoxious. But now I guess I get why
      //figma made these things containers.
      style: ElevatedButton.styleFrom(
        shadowColor: Colors.grey,
        minimumSize: Size(minButtonWidth, 100),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
        ),
        padding: EdgeInsets.all(9),
        alignment: Alignment.topLeft,
        textStyle: TextStyle(
          fontSize: minButtonWidth * 0.08,
          color: Color(0xFF1A1A1A),
          fontWeight: FontWeight.w600,
          letterSpacing: -0.3
        )
      ),
      onPressed: onPressed,
      child: Align(
        alignment: Alignment.topLeft,
        child: label,
      )

    );
  }
}

class LoginMenuButton extends Container {
  LoginMenuButton({super.key, required this.onPressed, required super.child}) : super();

  void Function()? onPressed;
  //Text label;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: child,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(MediaQuery.of(context).size.width * 0.5, 45),
        maximumSize: Size(MediaQuery.of(context).size.width * 0.75, 45)
      ),

    );
  }

}