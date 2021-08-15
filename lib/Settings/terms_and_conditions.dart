import 'package:flutter/material.dart';
import 'package:mobile_health_app/Constants.dart';

class TermsAndConditions extends StatefulWidget {
  const TermsAndConditions({Key? key}) : super(key: key);

  @override
  _TermsAndConditionsState createState() => _TermsAndConditionsState();
}

class _TermsAndConditionsState extends State<TermsAndConditions> {
  // this page is where terms and conditions will be displayed; need to be written by future students

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSecondaryColour,
      appBar: AppBar(
        title: Text('Terms and Conditions'),
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: [],
      ),
    );
  }
}
