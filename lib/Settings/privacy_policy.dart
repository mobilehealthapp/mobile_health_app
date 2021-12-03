import 'package:flutter/material.dart';
import 'package:mobile_health_app/constants.dart';

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
        title: Text('Privacy Policy'),
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: [
          Center(child: Text('Healthcare Systems R&A Inc. is committed to protecting the confidentiality of your personal information and respects your privacy. This Privacy Policy will describe')),
        ],
      ),
    );
  }

}
