import 'package:flutter/material.dart';
import 'package:mobile_health_app/settings_pages/my_doctors.dart';
import 'package:mobile_health_app/settings_pages/privacy_policy.dart';
import 'package:mobile_health_app/settings_pages/settings_constants.dart';
import 'settings_card.dart';
import 'profile_tab.dart';
import 'package:mobile_health_app/drawers.dart';
import 'terms_and_conditions.dart';

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
      drawer: Drawers(),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: ElevatedButton(
              onPressed: () {
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
              child: TabContent(label: 'My Profile'),
              style: kSettingsCardStyle,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: ElevatedButton(
              onPressed: () {
                setState(() {});
              },
              child: TabContent(label: 'Province/Territory'),
              style: kSettingsCardStyle,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: ElevatedButton(
              onPressed: () {
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
              child: TabContent(label: 'My Doctors'),
              style: kSettingsCardStyle,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: ElevatedButton(
              onPressed: () {
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
              child: TabContent(label: 'Privacy Policy'),
              style: kSettingsCardStyle,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TermsAndConditions(),
                    ),
                  );
                });
              },
              child: TabContent(label: 'Terms and Conditions'),
              style: kSettingsCardStyle,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: ElevatedButton(
              onPressed: () {
                setState(() {});
              },
              child: TabContent(label: 'Medical Disclaimer'),
              style: kSettingsCardStyle,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Alert(
                        alertBody: 'This will erase ALL of your data.',
                      ),
                    ),
                  );
                });
              },
              child: TabContent2(label: 'Delete My Data'),
              style: kRedButtonStyle,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: ElevatedButton(
              onPressed: () {
                setState(
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Alert(
                          alertBody:
                              'This will completely delete your account.',
                        ),
                      ),
                    );
                  },
                );
              },
              child: TabContent2(label: 'Delete My Account'),
              style: kRedButtonStyle,
            ),
          ),
        ],
      ),
    );
  }
}
