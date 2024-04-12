import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:innovaluation_tst_tester/widgets/roc_components.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:camera/camera.dart';
import 'questionnaire_screen.dart';
import 'settings_screen.dart';
import '../theme_data.dart';
import '../widgets/camera_service.dart';
import '../widgets/dynamic_button.dart';
import '../utils/user_state.dart';
import 'package:provider/provider.dart';
import '../providers/camera_state_provider.dart';
import '../widgets/request_notification_permission.dart';
import '../providers/button_state_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/dialog_provider.dart';
import '../utils/user_state.dart';

class MainMenuView extends StatefulWidget {
  @override
  _MainMenuViewState createState() => _MainMenuViewState();
}

class _MainMenuViewState extends State<MainMenuView> {
  int currentIndex = 0;
  late PersistentTabController _controller;
  final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
  String username = '';
  final Uri _url = Uri.parse('https://www.cvs.com/minuteclinic/services/tb-testing');

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
    _fetchUsername();
  }

  Future<void> _fetchUsername() async {
    if (userId.isNotEmpty) {
      //This is where it first checks for a doc by the name of uuid
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      setState(() {
        // Safely use the 'username' field from the document
        username = doc.data()?['username'] ?? '';
      });
    }
  }

  void _questionnairePressed() {
    if (!Provider.of<ButtonStateProvider>(context, listen: false)
        .isQuestionnaireActive) {
      return;
    } else {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => QuestionnaireScreen()));
    }
  }

Future<void> _launchUrl() async {
  if (!await launchUrl(_url)) {
    throw Exception('Could not launch $_url');
  }
}

  void _takePhoto() async {
    if (!Provider.of<CameraStateProvider>(context, listen: false)
        .isCameraActive) {
      return;
    } else {
      await Navigator.of(context, rootNavigator: true).push(
        MaterialPageRoute(
          builder: (context) => TakePictureScreen(),
        ),
      );
    }
  }

  void _faceVerifyPressed() {
  if (!Provider.of<ButtonStateProvider>(context, listen: false).isFaceActive) {
    return;
  } else {
    Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => ROCEnrollWebViewer()))
      .then((_) {
        // Assume the face has been verified when the viewer is closed
        updateFaceVerificationStatus(userId, true)
          .then((_) => print("Face verification status updated"))
          .catchError((error) => print("Failed to update face verification status: $error"));
      });
  }
}


  Future<void> updateFaceVerificationStatus(String userId, bool status) async {
  FirebaseFirestore.instance.collection('users').doc(userId).update({
    'faceVerified': status,
  });
}


  void _helpPressed() {
    Provider.of<DialogManager>(context, listen: false).showCustomDialog(context);
  }

  List<Widget> _buildScreens() {
    return [
      buildMainMenuContent(context),
      Container(),
      SettingsScreen(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    final isCameraActive =
        Provider.of<CameraStateProvider>(context).isCameraActive;
    return [
      PersistentBottomNavBarItem(
        icon: CustomNavBarIcon(
            asset: 'assets/images/home.svg', isActive: currentIndex == 0),
        //title: ("Home"),
        activeColorPrimary: Colors.transparent,
        inactiveColorPrimary: Colors.transparent,
      ),
      PersistentBottomNavBarItem(
        icon: SvgPicture.asset('assets/images/camera.svg',
            height: 25, color: Colors.white),
        activeColorPrimary: isCameraActive ? Color(0xFF2E1C56) : Colors.grey,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: CustomNavBarIcon(
            asset: 'assets/images/person.svg', isActive: currentIndex == 2),
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
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 6.0)
          ],
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          colorBehindNavBar: Colors.white,
        ),
        onItemSelected: (int index) {
          setState(() {
            currentIndex = index;
          });
          if (index == 1) {
            _controller.jumpToTab(0); // Resets to the first tab
            _takePhoto();
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
            onPressed: () {
              NotificationPermissionRequester(context).showPermissionDialog();
            },
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
          Container(
            width: MediaQuery.of(context).size.width * 0.86,
            child: AutoSizeText(
              "Welcome, $username!",
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.2,
              ),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildMenu(BuildContext context) {
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      children: [
        Stack(
          clipBehavior: Clip.none, // Allow elements to overflow the stack
          children: [
            // Main container for menu buttons - pushed down to make space for the button
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.75,
              margin: const EdgeInsets.only(
                  top: 50), // Create space for the button to overlap
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
              top:
                  5, // Adjust this to control how much the button overlaps the container
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
              onPressed: _questionnairePressed,
              label: "Questionnaire",
              svg: "assets/images/clipboard2.svg",
              notifSVGPath: Provider.of<ButtonStateProvider>(context)
                      .isQuestionnaireActive
                  ? "assets/images/dot.svg"
                  : null,
              buttonColor: Provider.of<ButtonStateProvider>(context)
                  .getButtonColorQuestionnaire(),
              textColor: Provider.of<ButtonStateProvider>(context)
                  .getButtonTextColorQuestionnaire(),
            ),
            SizedBox(width: 24),
            BigMenuButton(
              onPressed: _faceVerifyPressed,
              label: "Verify Face",
              svg: "assets/images/face.svg",
              notifSVGPath:
                  Provider.of<ButtonStateProvider>(context).isFaceActive
                      ? "assets/images/dot.svg"
                      : null,
              buttonColor: Provider.of<ButtonStateProvider>(context)
                  .getButtonColorFace(),
              textColor: Provider.of<ButtonStateProvider>(context)
                  .getButtonTextColorFace(),
            )
          ],
        ),
        SizedBox(height: 24),
        Row(
          children: [
            BigMenuButton(
              onPressed: _launchUrl,
              label: "Schedule Visit",
              svg: "assets/images/pencil1.svg",
            ),
            SizedBox(width: 24),
            BigMenuButton(
              onPressed: _helpPressed,
              label: "Help",
              svg: "assets/images/help.svg",
            ),
          ],
        ),
      ],
    );
  }
}

class CustomNavBarIcon extends StatelessWidget {
  final String asset;
  final bool isActive;

  const CustomNavBarIcon(
      {Key? key, required this.asset, required this.isActive})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      asset,
      color:
          isActive ? Colors.red : Colors.grey, // Active color : Inactive color
    );
  }
}
