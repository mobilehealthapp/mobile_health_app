import 'package:flutter/material.dart';
import 'package:mobile_health_app/constants.dart';

class MedicalDisclaimer extends StatefulWidget {
  const MedicalDisclaimer({Key? key}) : super(key: key);

  @override
  _MedicalDisclaimerState createState() => _MedicalDisclaimerState();
}

class _MedicalDisclaimerState extends State<MedicalDisclaimer> {
   // TODO: Write Medical Disclaimer and display it here

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
