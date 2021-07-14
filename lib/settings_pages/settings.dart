import 'package:flutter/material.dart';
import 'package:mobile_health_app/settings_pages/my_doctors.dart';
import 'package:mobile_health_app/settings_pages/privacy_policy.dart';
import 'package:mobile_health_app/settings_pages/settings_constants.dart';
import 'settings_card.dart';
import 'profile_tab.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      builder: (context) => ProfilePage(),
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
                      builder: (context) => MyDoctors(),
                    ),
                  );
                },
              );
            },
            child: SettingsCard(
              settingsTab: TabContent(label: 'My Doctors'),
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
                        alertBody: 'This will erase ALL of your data.',
                      ),
                    ),
                  );
                },
              );
            },
            child: Container(
              child: RedCard(
                deleteTab: TabContent2(label: 'Delete My Data'),
              ),
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
