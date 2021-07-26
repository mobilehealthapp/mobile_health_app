import 'package:flutter/material.dart';
import 'package:mobile_health_app/PhysDrawer.dart';
import 'package:mobile_health_app/settings_pages/dr_profile.dart';
import 'package:mobile_health_app/settings_pages/privacy_policy.dart';
import 'settings_card.dart';
import 'settings_constants.dart';
import 'terms_and_conditions.dart';

class DrSettingsPage extends StatefulWidget {
  @override
  _DrSettingsPageState createState() => _DrSettingsPageState();
}

class _DrSettingsPageState extends State<DrSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: PhysDrawers(),
      backgroundColor: kSecondaryColour,
      appBar: AppBar(
        title: Text(
          'Settings',
          style: kAppBarLabelStyle,
        ),
        centerTitle: true,
        backgroundColor: kPrimaryColour,
      ),
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
                        builder: (context) => DrProfilePage(),
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
                setState(
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TermsAndConditions(),
                      ),
                    );
                  },
                );
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
