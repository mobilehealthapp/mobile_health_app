import 'package:flutter/material.dart';
import 'package:mobile_health_app/settings_pages/dr_profile.dart';
import 'package:mobile_health_app/settings_pages/privacy_policy.dart';
import 'settings_card.dart';
import 'package:mobile_health_app/drawers.dart';
import 'settings_constants.dart';

class DrSettingsPage extends StatefulWidget {
  @override
  _DrSettingsPageState createState() => _DrSettingsPageState();
}

class _DrSettingsPageState extends State<DrSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawers(),
      backgroundColor: Color(0xFFB2EBF2),
      appBar: AppBar(
        title: Text(
          'Settings',
          style: kAppBarLabelStyle,
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF00BCD4),
      ),
      body: ListView(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              setState(
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DrProfilePage(),
                    ),
                  );
                },
              );
            },
            child: SettingsCard(
              settingsTab: TabContent(label: 'My Profile'),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {});
            },
            child: SettingsCard(
              settingsTab: TabContent(label: 'Province/Territory'),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PrivacyPolicy(),
                    ),
                  );
                },
              );
            },
            child: SettingsCard(
              settingsTab: TabContent(label: 'Privacy Policy'),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {});
            },
            child: SettingsCard(
              settingsTab: TabContent(label: 'Terms and Conditions'),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {});
            },
            child: SettingsCard(
              settingsTab: TabContent(label: 'Medical Disclaimer'),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Alert(
                        alertBody: 'This will completely delete your account.',
                      ),
                    ),
                  );
                },
              );
            },
            child: RedCard(
              deleteTab: TabContent2(label: 'Delete My Account'),
            ),
          ),
        ],
      ),
    );
  }
}
