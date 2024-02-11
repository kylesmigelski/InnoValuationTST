import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:innovaluation_tst_tester/theme_data.dart';
import 'login_screen.dart';
import 'photo_button.dart';

class MainMenuView extends StatelessWidget {
  @override
  Widget build(context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("Innovaluation TST"),
      //   backgroundColor: Colors.green,
      // ),
      body: GradientContainer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            //This will be the container that handles the label, logo, maybe a
            //push notifs thing.
            SizedBox(height: 20),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.2,
              child: Column(
                children: [
                  //This row here will be where we put the Logo and notifs thing if we include those
                  SafeArea(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: GestureDetector(
                            // placeholder for testing purposes
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()),
                              );
                            },
                            child: logoSVG,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0,
                              right: 16.0), // Add right padding here
                          child: IconButton(
                            onPressed: () {
                              // Handle logo button pressed
                            },
                            icon: SvgPicture.asset(
                              'assets/images/notif.svg',
                              height: 30,
                            ),
                            padding: const EdgeInsets.all(0),
                            constraints: const BoxConstraints(),
                          ),
                        )
                      ],
                    ),
                  ),
                  //This one will be for the label because not putting it in a row seems to autocenter it
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
                  )
                ],
              ),
            ),
            SizedBox(height: 30),

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
                          margin: const EdgeInsets.only(top: 70),
                          height: MediaQuery.of(context).size.height * 0.7,
                          decoration: const ShapeDecoration(
                            color: Color(0xFFF8F8F8),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20))),
                          ),
                          //not sure if we're going to leave that bottom padding in...
                          padding: EdgeInsets.only(
                              left: 18, right: 18, top: 90, bottom: 18),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  BigMenuButton(
                                    onPressed: () {
                                      print("Sign up button pressed");
                                    },
                                    label: const Text("Sign Up for Visit"),
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
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top:
                              0, // Adjust this value to position the button correctly (half inside, half outside)
                          child: CustomPhotoButton(
                            onPressed: () {
                              print("Photo button pressed");
                            },
                            remainingTime: const Duration(minutes: 15),
                          ),
                        ),
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
