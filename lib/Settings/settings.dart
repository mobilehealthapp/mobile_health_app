import 'package:flutter/material.dart';
import 'package:mobile_health_app/Constants.dart';
import 'package:mobile_health_app/Drawers/drawers.dart';
import 'delete_data_or_account.dart';
import 'settings_classes.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawers(),
      backgroundColor: kSecondaryColour,
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: <Widget>[
          SettingsButton(
            route: '/profile',
            label: 'My Profile',
          ),
          SettingsButton(
            route: '/myDoctors',
            label: 'My Doctors',
          ),
          SettingsButton(
            route: '/privacyPolicy',
            label: 'Privacy Policy',
          ),
          SettingsButton(
            route: '/termsAndConditions',
            label: 'Terms and Conditions',
          ),
          SettingsButton(
            route: '/medicalDisclaimer',
            label: 'Medical Disclaimer',
          ),
          RedSettingsButton(
            label: 'Delete My Data',
            alertBody:
                'This will erase all of your data except for your email address and your account type.',
            widget: AlertPatientData(),
          ),
          RedSettingsButton(
            label: 'Delete My Account',
            alertBody: 'This will completely delete your account.',
            widget: AlertPatientAccount(),
          ),
        ],
      ),
    );
  }
}
