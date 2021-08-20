import 'package:flutter/material.dart';
import 'package:mobile_health_app/Settings/settings_card.dart';

import '../Constants.dart';

//This file collects information from the doctor cards and firebase data to show the patient a more detailed display of their doctor's information
class MyDoctorProfile extends StatelessWidget {
  final drFirst;
  final drLast;
  final quali;
  final drTele;
  final fax;
  final clinicAdr;
  final label;
  final email;

  MyDoctorProfile(
      {this.drFirst,
      this.drLast,
      this.clinicAdr,
      this.quali,
      this.drTele,
      this.fax,
      this.label,
      this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'My Doctors',
            style: kAppBarLabelStyle,
          ),
          centerTitle: true,
          backgroundColor: kPrimaryColour,
        ),
        body: ListView(children: <Widget>[
          ProfileTab(editAnswer: 'Name: $drFirst $drLast'),
          ProfileTab(editAnswer: 'Label: $label'),
          ProfileTab(editAnswer: 'Qualifications: $quali'),
          ProfileTab(editAnswer: 'Telephone Number: $drTele'),
          ProfileTab(editAnswer: 'Email: $email'),
          ProfileTab(editAnswer: 'Fax: $fax'),
          ProfileTab(editAnswer: 'Clinic Address: $clinicAdr'),
        ]));
  }
}
