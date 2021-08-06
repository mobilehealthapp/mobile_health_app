import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'package:mobile_health_app/Constants.dart';
import 'package:mobile_health_app/Graph/ExtractData.dart';

import 'package:mobile_health_app/drawers.dart';

var loggedInUser;
var uid;

class HealthAnalysis extends StatefulWidget {
  const HealthAnalysis({Key? key}) : super(key: key);

  @override
  _HealthAnalysisState createState() => _HealthAnalysisState();
}

class _HealthAnalysisState extends State<HealthAnalysis> {
  final _auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    getCurrentUser();
    ExtractDataCard();
  }

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
        uid = user.uid.toString(); //convert to string in this method
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawers(),
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: kPrimaryColour,
        title: Text(
          'Health Analysis',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        children: [
          ExtractDataV2(),
          ExtractData3V2(),
          ExtractData2V2(),
          ExtractDataCard()
          // ExtractData2(),
          // ExtractData3(),
        ],
      ),
    );
    // DoctorList()
  }
}
