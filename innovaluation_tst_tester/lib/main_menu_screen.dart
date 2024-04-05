import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:camera/camera.dart';
import 'questionnaire_screen.dart';
import 'settings_screen.dart'; 
import 'theme_data.dart';
import 'camera_service.dart';
import 'dynamic_button.dart';
import 'user_state.dart';
import 'package:provider/provider.dart';
import 'providers/camera_state_provider.dart';

class MainMenuView extends StatefulWidget {
  @override
  _MainMenuViewState createState() => _MainMenuViewState();
}

class _MainMenuViewState extends State<MainMenuView> {
  int currentIndex = 0; 
  late PersistentTabController _controller;
  final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
  String username = '';
  
  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
    _fetchUsername();
  }

    Future<void> _fetchUsername() async {
    if (userId.isNotEmpty) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      setState(() {
        // Safely use the 'username' field from the document
        username = doc.data()?['username'] ?? '';
      });
    }
  }

  void _questionnairePressed() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => QuestionnaireScreen()));
  }

  void _takePhoto() async {
    if (!Provider.of<CameraStateProvider>(context, listen: false).isCameraActive) {
      return;
    } else {
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => InstructionsScreen(),
      ),
    );
    }
  }

List<Widget> _buildScreens() {
  return [
    buildMainMenuContent(context), 
    Container(),
    SettingsScreen(), 
  ];
}

List<PersistentBottomNavBarItem> _navBarsItems() {
  final isCameraActive = Provider.of<CameraStateProvider>(context).isCameraActive;
  return [
    PersistentBottomNavBarItem(
      icon: CustomNavBarIcon(asset: 'assets/images/home.svg', isActive: currentIndex == 0),
      //title: ("Home"),
      activeColorPrimary: Colors.transparent,
      inactiveColorPrimary: Colors.transparent,
    ),
    PersistentBottomNavBarItem(
      icon: SvgPicture.asset('assets/images/camera.svg', height: 25, color: Colors.white),
      activeColorPrimary: isCameraActive ? Color(0xFF2E1C56) : Colors.grey,
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
      navBarStyle: NavBarStyle.style15, 
      decoration: NavBarDecoration(
    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    colorBehindNavBar: Colors.white,
  ),
      onItemSelected: (int index) {
        setState(() {
          currentIndex = index;
        });
        if (index == 1 && Provider.of<CameraStateProvider>(context, listen: false).isCameraActive) {
          _controller.jumpToTab(0); // Resets to the first tab
          _takePhoto();
        } else {
          _controller.jumpToTab(0);
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
        Text(
          "Welcome, $username!",
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
    physics: AlwaysScrollableScrollPhysics(),
    children: [
      Stack(
        clipBehavior: Clip.none, // Allow elements to overflow the stack
        children: [
          // Main container for menu buttons - pushed down to make space for the button
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height -60,
            margin: const EdgeInsets.only(top: 60), // Create space for the button to overlap
            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 45),
            decoration: BoxDecoration(
              color: Color(0xF9F9F9F9),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                // Your menu buttons go here
                SizedBox(height: 50),
                _buildMenuButtons(context),
              ],
            ),
          ),

          // Positioned button to overlap the top of the container
          Positioned(
            top: 5, // Adjust this to control how much the button overlaps the container
            left: 0,
            right: 0,
            child: Center(
              child: DynamicProgressButton(userId: userId),
            ),
          ),
        ],
      ),
    ],
  );
}

Widget _buildMenuButtons(BuildContext context) {
        return Column(
          children: [
          Row(
            children: [
              BigMenuButton(
                onPressed: () {}, // Implement
                label: "Log Visit",
                svg: "assets/images/pencil1.svg",
              ),
              SizedBox(width: 24),
              BigMenuButton(
                //onPressed: () => _navigateToCamera(),
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
                      onPressed: () {},
                      label: "Help",
                      svg: "assets/images/clipboard1.svg",
                    ),
            ],
          ),
          SizedBox(height: 24),
          // add more Rows of buttons
          ],
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