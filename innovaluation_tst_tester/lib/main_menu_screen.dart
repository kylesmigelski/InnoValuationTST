import 'package:flutter/material.dart';
import 'package:innovaluation_tst_tester/theme_data.dart';

class MainMenuView extends StatelessWidget {
  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Innovaluation TST"),
        backgroundColor: Colors.green,
      ),
      body: GradientContainer(
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.only(top: 66),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [

              //This will be the container that handles the label, logo, maybe a
              //push notifs thing.
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.15,
                child: Column(
                  children: [
                    //This row here will be where we put the Logo and notifs thing if we include those
                    Row(
                      children: [

                      ],
                    ),
                    const SizedBox(height: 24,),
                    //This one will be for the label because not putting it in a row seems to autocenter it
                    Row(
                      children: [
                        SizedBox(width: MediaQuery.of(context).size.width * 0.06),
                        const Text(
                          "Welcome, user",
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'SF Pro',
                            letterSpacing: -0.2
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),

              //This one will have that white background thing that all of the buttons
              // sit on in the prototype.
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.75,
                decoration: const ShapeDecoration(
                  color: Color(0xFFF8F8F8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)
                    )
                  ),
                ),
                //not sure if we're going to leave that bottom padding in...
                padding: EdgeInsets.only(left: 18, right: 18, top: 72, bottom: 60),
                child: Column(
                  children: [
                    Row(
                      children: [
                        BigMenuButton(
                          onPressed: () {
                            print("Sign up button pressed");
                          },
                          label: Text("Sign Up for Visit")
                        ),
                        const SizedBox(width: 24,),
                        BigMenuButton(
                          onPressed: () {
                            print("Records button pressed");
                          },
                          label: Text("Records")
                        )
                      ],
                    ),
                    const SizedBox(height: 24,),
                    Row(
                      children: [
                        BigMenuButton(
                          onPressed: () {

                          },
                          label: const Text("Analysis")
                        ),
                        const SizedBox(width: 24,),
                        BigMenuButton(
                          onPressed: () {

                          },
                          label:  const Text("Visits")
                        )
                      ],
                    ),
                    SizedBox(height: 24,),
                    Row(
                      children: [
                        BigMenuButton(
                          onPressed: () {

                          },
                          label: Text("Help")
                        )
                      ],
                    )
                  ],
                ),
              )

            ],
          ),
        ),
      )
    );
  }

}