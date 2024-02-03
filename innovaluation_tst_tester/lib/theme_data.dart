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