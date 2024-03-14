import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:camera/camera.dart';
import 'questionnaire_screen.dart';
import 'settings_screen.dart'; // Make sure this file exists with a SettingsScreen widget
import 'theme_data.dart';
import 'login_screen.dart';
import 'photo_button.dart';
import 'camera_service.dart'; // Assuming this provides InstructionsScreen

class MainMenuView extends StatefulWidget {
  @override
  _MainMenuViewState createState() => _MainMenuViewState();
}

class _MainMenuViewState extends State<MainMenuView> {
  int currentIndex = 0; 
  late PersistentTabController _controller;
  CameraDescription? _firstCamera;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
    _getCameraStuff().then((value) {
      setState(() {
        _firstCamera = value;
      });
    });
  }

  Future<CameraDescription> _getCameraStuff() async {
    final cameras = await availableCameras();
    return cameras.first;
  }

  void _logoutPressed() {
    FirebaseAuth.instance.signOut();
  }

  void _questionnairePressed() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => QuestionnaireScreen()));
  }

  Future<void> _navigateToCamera() async {
  if (_firstCamera == null) {
    print("Camera not initialized yet.");
    return;
  }
  try {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => InstructionsScreen(camera: firstCamera),
      ),
    );
  } catch (e) {
    print(e); // Consider showing an alert or a toast to the user
  }
}

  void _go2SettingsScreen() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => SettingsScreen()));
  }
  

List<Widget> _buildScreens() {
  return [
    buildMainMenuContent(context), // Your main menu content
    Container(), // Dummy placeholder for the Camera action
    SettingsScreen(), // Your settings screen
  ];
}

List<PersistentBottomNavBarItem> _navBarsItems() {
  return [
    PersistentBottomNavBarItem(
      icon: CustomNavBarIcon(asset: 'assets/images/home.svg', isActive: currentIndex == 0),
      //title: ("Home"),
      activeColorPrimary: Colors.transparent,
      inactiveColorPrimary: Colors.transparent,
    ),
    PersistentBottomNavBarItem(
      icon: SvgPicture.asset('assets/images/camera.svg', height: 25, color: Colors.white),
      //title: ("Camera"),
      activeColorPrimary: Color.fromARGB(255, 43, 25, 83),
      inactiveColorPrimary: Colors.grey,
    ),
    PersistentBottomNavBarItem(
      icon: CustomNavBarIcon(asset: 'assets/images/person.svg', isActive: currentIndex == 2),
      //title: ("Settings"),
      activeColorPrimary: Colors.transparent,
      inactiveColorPrimary: Colors.transparent,
    ),
  ];
}


  Widget buildMainMenuContent(BuildContext context) {
    // Your Main Menu content logic here
    return GradientContainer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildHeader(context),
          Expanded(child: _buildMenu(context)),
        ],
      ),
    );
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: Colors.white,
      navBarStyle: NavBarStyle.style15, // Choose the nav bar style with this property.
      decoration: NavBarDecoration(
    borderRadius: BorderRadius.vertical(top: Radius.circular(20)), // Ensure this is not null
    colorBehindNavBar: Colors.white,
  ),
      onItemSelected: (int index) {
        setState(() {
          currentIndex = index; // Update your current index on tab change
        });
        // Intercept selection of Camera tab to perform action
        if (index == 1) { // Assuming Camera is the second item
          _controller.jumpToTab(0); // Optional: Resets to the first tab, or handle as needed
          _navigateToCamera();
        }
      },
    ),
  );
}

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.25,
          child: Column(
            children: [
              SizedBox(height: 30),
              _buildLogoAndNotifRow(context),
              _buildWelcomeLabel(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLogoAndNotifRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          height: 100,
          child: logoSVG,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0, right: 8.0),
          child: IconButton(
            onPressed: () {},
            icon: SvgPicture.asset(
              'assets/images/notif.svg',
              height: 25,
            ),
            padding: const EdgeInsets.all(0),
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeLabel(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          SizedBox(width: MediaQuery.of(context).size.width * 0.06),
          const Text(
            "Welcome, user",
            style: TextStyle(
                fontSize: 40, fontWeight: FontWeight.w700, letterSpacing: -0.2),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildMenu(BuildContext context) {
    return ListView(
      physics:
          AlwaysScrollableScrollPhysics(), // Adjust the scroll physics as needed
      children: [
        _buildMenuButtons(context),
      ],
    );
  }

  Widget _buildMenuButtons(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(top: 1),
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const ShapeDecoration(
        color: Color(0xF9F9F9F9),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      ),
      padding: EdgeInsets.only(left: 18, right: 18, top: 45, bottom: 18),
      child: Column(
        children: [
          Row(
            children: [
              BigMenuButton(
                onPressed: () {}, // Implement your logic
                label: "Log Visit",
                svg: "assets/images/pencil1.svg",
              ),
              SizedBox(width: 24),
              BigMenuButton(
                onPressed: () => _navigateToCamera(),
                label: "1st Picture",
                svg: "assets/images/camera.svg",
              ),
            ],
          ),
          SizedBox(height: 24),
          Row(
            children: [
              BigMenuButton(
                onPressed: _questionnairePressed,
                label: "Questionnaire",
                svg: "assets/images/clipboard2.svg",
              ),
              SizedBox(width: 24),
              BigMenuButton(
                onPressed: () => _navigateToCamera(),
                label: "Follow-up Photos",
                svg: "assets/images/calandar.svg",
              ),
            ],
          ),
          SizedBox(height: 24),
          Row(
            children: [
              BigMenuButton(
                onPressed: () {},
                label: "Help",
                svg: "assets/images/clipboard1.svg",
              ),
              // If there's another button, add here
            ],
          ),
          // add more Rows of buttons as needed
        ],
      ),
    );
  }
}

class CustomNavBarIcon extends StatelessWidget {
  final String asset;
  final bool isActive;

  const CustomNavBarIcon({Key? key, required this.asset, required this.isActive}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      asset,
      color: isActive ? Colors.red : Colors.grey, // Active color : Inactive color
    );
  }
}

