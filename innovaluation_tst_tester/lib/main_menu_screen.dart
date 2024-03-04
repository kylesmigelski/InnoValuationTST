import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:innovaluation_tst_tester/questionnaire_screen.dart';
import 'package:innovaluation_tst_tester/theme_data.dart';
import 'login_screen.dart';
import 'photo_button.dart';
import 'package:innovaluation_tst_tester/camera_service.dart'; // Import the camera_service.dart file
import 'package:camera/camera.dart'; // Import the camera package


class MainMenuView extends StatelessWidget {

  void _logoutPressed() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("Innovaluation TST"),
      //   backgroundColor: Colors.green,
      // ),
      bottomNavigationBar: BottomAppBar(
        height: MediaQuery.of(context).size.height * 0.05,
        color: Color(0xFFFFFFFF),
        shadowColor: Colors.grey,
        child: Row(
          children: [
            SizedBox(width: 15,),
            BackButton(
              onPressed: _logoutPressed,
            )
          ],
        ),
      ),
      body: GradientContainer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            //This will be the container that handles the label, logo, maybe a
            //push notifs thing.
            SizedBox(height: 20),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.25,
              child: Column(
                children: [
                  //This row here will be where we put the Logo and notifs thing if we include those
                  SizedBox(height: 50,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: GestureDetector(
                          // placeholder for testing purposes
                          onTap: () {
                            //Navigator.of(context).pop();
                            _logoutPressed();
                          },
                          child: logoSVG,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0,
                            right: 8.0), // Add right padding here
                        child: IconButton(
                          onPressed: () {
                            // Handle logo button pressed
                          },
                          icon: SvgPicture.asset(
                            'assets/images/notif.svg',
                            height: 25,
                          ),
                          padding: const EdgeInsets.all(0),
                          //constraints: const BoxConstraints(),
                        ),
                      )
                    ],
                  ),
                  //This one will be for the label because not putting it in a row seems to autocenter it
                  //SizedBox(height: 25,),
                  Expanded(child:
                    Row(
                    children: [
                      SizedBox(width: MediaQuery.of(context).size.width * 0.06),
                      const Text(
                        "Welcome, user",
                        style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.2),
                      )
                    ],
                  ))
                ],
              ),
            ),
            //SizedBox(height: 30),

            //This one will have that white background thing that all of the buttons
            // sit on in the prototype.
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  print("Refreshed");
                },
                child: ListView(
                  physics: CustomScrollPhysics(),
                  children: [
                    Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.only(top: 1),
                          height: MediaQuery.of(context).size.height * 0.75,
                          decoration: const ShapeDecoration(
                            color: Color(0xFFE8E8E8),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20))),
                          ),
                          //not sure if we're going to leave that bottom padding in...
                          padding: EdgeInsets.only(
                              left: 18, right: 18, top: 45, bottom: 18),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  BigMenuButton(
                                    onPressed: () {
                                      print("Sign up button pressed");
                                      Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) => QuestionnaireScreen())
                                      );
                                    },
                                    label: const Text("Take Questionnaire"),
                                    svg: "assets/images/pencil1.svg",
                                  ),
                                  const SizedBox(
                                    width: 24,
                                  ),
                                  BigMenuButton(
                                    onPressed: () {
                                      print("Records button pressed");
                                    },
                                    label: Text("Records"),
                                    svg: "assets/images/recordBlock.svg",
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 24,
                              ),
                              Row(
                                children: [
                                  BigMenuButton(
                                    onPressed: () {},
                                    label: const Text("Analysis"),
                                    svg: "assets/images/clipboard2.svg",
                                  ),
                                  const SizedBox(
                                    width: 24,
                                  ),
                                  BigMenuButton(
                                    onPressed: () {},
                                    label: const Text("Visits"),
                                    svg: "assets/images/calandar.svg",
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 24,
                              ),
                              Row(
                                children: [
                                  BigMenuButton(
                                    onPressed: () {},
                                    label: Text("Help"),
                                    svg: "assets/images/clipboard1.svg",
                                  ),
                              
                              SizedBox(
                                width: 24,
                              ),
                                BigMenuButton(
                                  onPressed: () {
                                    _navigateToCamera(context);
                                  },
                                  label: Text("Take Picture"),
                                  svg: "assets/images/camera.svg",
                                )
                            ],
                              ),
                            ],
                          ),
                        ),
                        // Positioned(
                        //   top:
                        //       0, // Adjust this value to position the button correctly (half inside, half outside)
                        //   child: CustomPhotoButton(
                        //     onPressed: () {
                        //       print("Photo button pressed");
                        //     },
                        //     remainingTime: const Duration(minutes: 15),
                        //   ),
                        // ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CustomScrollPhysics extends ScrollPhysics {
  const CustomScrollPhysics({ScrollPhysics? parent}) : super(parent: parent);

  @override
  CustomScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return CustomScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    // Allow downward scrolling and overscroll for refresh (offset > 0)
    // Block upward scrolling (offset < 0)
    if (offset < 0) return 0;
    return super.applyPhysicsToUserOffset(position, offset);
  }
}



Future<void> _navigateToCamera(BuildContext context) async {
  try {
    // Get the list of available cameras.
    final cameras = await availableCameras();

    // Get a specific camera from the list of available cameras.
    final firstCamera = cameras.first;

    // Navigate to the InstructionsScreen widget, passing the first camera.
    // InstructionsScreen will then handle navigating to TakePictureScreen.
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => InstructionsScreen(camera: firstCamera),
      ),
    );
  } catch (e) {
    // Handle any errors here
    print(e); // Consider showing an alert or a toast to the user
  }
}

