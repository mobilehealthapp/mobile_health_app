import 'package:flutter/material.dart';
import 'package:mobile_health_app/Constants.dart';

class PrivacyPolicy extends StatefulWidget {
  @override
  _PrivacyPolicyState createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  // this page is where privacy policy will be displayed; needs to be written by future students

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
