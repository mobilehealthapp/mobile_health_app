import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobile_health_app/Constants.dart';
import 'package:mobile_health_app/Drawers/PhysDrawer.dart';
import 'package:mobile_health_app/Settings/delete_data_or_account.dart';
import 'settings_classes.dart';

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
        title: Text('Settings'),
      ),
      body: ListView(
        children: <Widget>[
          SettingsButton(
            route: '/drProfile',
            label: 'My Profile',
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
            widget: AlertDoctorData(),
          ),
          RedSettingsButton(
            label: 'Delete My Account',
            alertBody: 'This will completely delete your account.',
            widget: AlertDoctorAccount(),
          ),
        ],
      ),
    );
  }
}
