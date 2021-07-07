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
      body: Column(
        children: <Widget>[
          Expanded(
            child: GestureDetector(
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
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {});
              },
              child: SettingsCard(
                settingsTab: TabContent(label: 'Country/Region'),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
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
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {});
              },
              child: SettingsCard(
                settingsTab: TabContent(label: 'Terms and Conditions'),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {});
              },
              child: SettingsCard(
                settingsTab: TabContent(label: 'Medical Disclaimer'),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
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
              child: RedCard(
                deleteTab: TabContent2(label: 'Delete My Account'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Alert extends StatelessWidget {
  Alert({required this.alertBody});

  final String alertBody;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Are you sure?',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20.0,
        ),
      ),
      content: Text(
        alertBody,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 18.0,
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: const Text(
            'Cancel',
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Alert2(),
            ),
          ),
          child: const Text(
            'Confirm',
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
        ),
      ],
    );
  }
}

class Alert2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Please enter your password to complete this action.',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20.0,
        ),
      ),
      content: TextField(
        decoration: InputDecoration(
          hintText: 'Password',
          hintStyle: TextStyle(
            fontSize: 20.0,
            color: Colors.black,
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context)..pop()..pop(),
          child: const Text(
            'Cancel',
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context)..pop()..pop(),
          child: const Text(
            'Enter Password and Confirm',
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
        ),
      ],
    );
  }
}
