import 'package:flutter/material.dart';
import 'package:mobile_health_app/Constants.dart';

class MedicalDisclaimer extends StatefulWidget {
  const MedicalDisclaimer({Key? key}) : super(key: key);

  @override
  _MedicalDisclaimerState createState() => _MedicalDisclaimerState();
}

class _MedicalDisclaimerState extends State<MedicalDisclaimer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSecondaryColour,
      appBar: AppBar(
        title: Text('Medical Disclaimer'),
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: [],
      ),
    );
  }
}
