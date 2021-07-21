import 'package:flutter/material.dart';
import 'settings_constants.dart';

class PrivacyPolicy extends StatefulWidget {
  @override
  _PrivacyPolicyState createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Privacy Policy',
          style: kAppBarLabelStyle,
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF00BCD4),
      ),
    );
  }
}
