import 'package:flutter/material.dart';
import 'package:mobile_health_app/Constants.dart';
import 'package:mobile_health_app/Settings/settings_constants.dart';
import 'settings_card.dart';
import 'package:mobile_health_app/Drawers/drawers.dart';

import 'delete_data_or_account.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSecondaryColour,
      appBar: AppBar(
        title: Text('Settings'),
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
                    Navigator.of(context)
                        .pushNamed('/profile'); // navigate to profile page
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
              onPressed: () async {
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
                    Navigator.of(context)
                        .pushNamed('/myDoctors'); // navigate to doctors page
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
                    Navigator.of(context).pushNamed(
                        '/privacyPolicy'); // navigate to privacy policy page
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
                    Navigator.of(context).pushNamed(
                        '/termsAndConditions'); // navigate to terms and conditions page
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
                setState(
                  () {
                    Navigator.of(context).pushNamed(
                        '/medicalDisclaimer'); // navigate to medical disclaimer page
                  },
                );
              },
              child: TabContent(label: 'Medical Disclaimer'),
              style: kSettingsCardStyle,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: ElevatedButton(
              onPressed: () async {
                return showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return new Alert(
                      widget:
                          AlertPatientData(), // navigates to alert where user can input credentials and delete data
                      alertBody:
                          'This will erase all of your data except for your email address and your account type.',
                    );
                  },
                );
              },
              child: TabContent2(label: 'Delete My Data'),
              style: kRedButtonStyle,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: ElevatedButton(
              onPressed: () async {
                return showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return new Alert(
                      widget:
                          AlertPatientAccount(), // navigates to alert where user can input credentials and delete account
                      alertBody: 'This will completely delete your account.',
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
