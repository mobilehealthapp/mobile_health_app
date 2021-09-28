import 'package:flutter/material.dart';
import 'package:mobile_health_app/constants.dart';

class PrivacyPolicy extends StatefulWidget {
  @override
  _PrivacyPolicyState createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  // TODO: Write Privacy Policy and display it here

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSecondaryColour,
      appBar: AppBar(
        title: Text('Privacy Policy'),
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: [],
      ),
    );
  }
}
