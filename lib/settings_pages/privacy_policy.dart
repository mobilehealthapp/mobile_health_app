import 'package:flutter/material.dart';
import 'package:mobile_health_app/Constants.dart';
import 'settings_constants.dart';

class PrivacyPolicy extends StatefulWidget {
  @override
  _PrivacyPolicyState createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSecondaryColour,
      appBar: AppBar(
        title: Text(
          'Privacy Policy',
          style: kAppBarLabelStyle,
        ),
        centerTitle: true,
        backgroundColor: kPrimaryColour,
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: [
        ],
      ),
    );
  }
}