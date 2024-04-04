import 'package:flutter/material.dart';
import 'package:innovaluation_tst_tester/theme_data.dart';
import 'package:provider/provider.dart';
import 'package:innovaluation_tst_tester/auth_provider.dart';

class SettingsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "Settings",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: GradientContainer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildHeaderSection(),
            _buildContentSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 60),
      alignment: Alignment.center,
    );
  }

  Widget _buildContentSection() {
    return Expanded(
      // White background container with rounded corners
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.only(top: 1),
        decoration: const ShapeDecoration(
          color: Color.fromARGB(255, 237, 237, 237),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        ),
        padding: EdgeInsets.symmetric(vertical: 70, horizontal: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: () {
                // Use Provider to sign out
                Provider.of<AuthenticationProvider>(context, listen: false)
                    .signOut();
              },
              child: Text('Sign Out', style: TextStyle(fontSize: 16)),
              style: ElevatedButton.styleFrom(
                  minimumSize:
                      Size(MediaQuery.of(context).size.width * 0.7, 55),
                  maximumSize:
                      Size(MediaQuery.of(context).size.width * 0.75, 55)),
            ),
          ],
        ),
      ),
    );
  }
}
