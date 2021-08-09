import 'package:flutter/material.dart';
import 'package:mobile_health_app/Constants.dart';
import 'settings_pages/settings_constants.dart';
import 'drawers.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'settings_pages/graph_info.dart';

var patientData = FirebaseFirestore.instance
    .collection('patientData')
    .doc(FirebaseAuth.instance.currentUser!.uid);
var bloodGlucose = patientData.collection('bloodGlucose');
var bloodPressure = patientData.collection('bloodPressure');
var heartRate = patientData.collection('heartRate');

late int numberOfBGPoints = 0;
late int numberOfBPPoints = 0;
late int numberOfHRPoints = 0;

getNumberOfBGPoints() async {
  QuerySnapshot<Map<String, dynamic>> getBG = await bloodGlucose.get();
  numberOfBGPoints = getBG.docs.length;
  return numberOfBGPoints;
}

getNumberOfBPPoints() async {
  QuerySnapshot<Map<String, dynamic>> getBP = await bloodPressure.get();
  numberOfBPPoints = getBP.docs.length;
  return numberOfBPPoints;
}

getNumberOfHRPoints() async {
  QuerySnapshot<Map<String, dynamic>> getHR = await heartRate.get();
  numberOfHRPoints = getHR.docs.length;
  return numberOfHRPoints;
}

class HealthAnalysis extends StatefulWidget {
  @override
  _HealthAnalysisState createState() => _HealthAnalysisState();
}

class _HealthAnalysisState extends State<HealthAnalysis> {
  @override
  void initState() {
    super.initState();
    getNumberOfBPPoints();
    getNumberOfBGPoints();
    getNumberOfHRPoints();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kSecondaryColour,
        drawer: Drawers(),
        appBar: AppBar(
          title: Text(
            'Health Analysis',
            style: kAppBarLabelStyle,
          ),
          centerTitle: true,
          backgroundColor: kPrimaryColour,
        ),
        body: ListView(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          children: [
            ExtractData(),
            ExtractData2(),
            ExtractData3(),
          ],
        ));
  }
}

class ExtractData extends StatefulWidget {
  const ExtractData({Key? key}) : super(key: key);

  @override
  _ExtractDataState createState() => _ExtractDataState();
}

class _ExtractDataState extends State<ExtractData> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('patientData')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('heartRate')
          .snapshots(),
      builder: (context, snapshot) {
        final value = snapshot.data!.docs;
        final List<FlSpot> data1 = [];
        double index = 1.0;

        for (var val in value) {
          int heartrate = val.get('heart rate');
          data1.add(FlSpot(index++, heartrate.toDouble()));
        }
        return Charts(
          units: 'BPM',
          yStart: 30,
          bool1: false,
          yLength: 200,
          xLength: numberOfHRPoints.toDouble(),
          list: data1,
        );
      },
    );
  }
}

class ExtractData2 extends StatefulWidget {
  const ExtractData2({Key? key}) : super(key: key);

  @override
  _ExtractData2State createState() => _ExtractData2State();
}

class _ExtractData2State extends State<ExtractData2> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('patientData')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('bloodPressure')
          .snapshots(),
      builder: (context, snapshot) {
        final value = snapshot.data!.docs;
        final List<FlSpot> data2 = [];
        final List<FlSpot> data3 = [];
        double index = 1;
        double index2 = 1;

        for (var val in value) {
          double dias = val.get('diastolic');
          double sys = val.get('systolic');

          data2.add(FlSpot(index++, dias.toDouble()));
          data3.add(FlSpot(index2++, sys.toDouble()));
        }
        return Charts2(
          units: 'mmHg',
          yStart: 10,
          bool1: false,
          yLength: 180,
          xLength: numberOfBPPoints.toDouble(),
          list: data2,
          list2: data3,
        );
      },
    );
  }
}

class ExtractData3 extends StatefulWidget {
  const ExtractData3({Key? key}) : super(key: key);

  @override
  _ExtractData3State createState() => _ExtractData3State();
}

class _ExtractData3State extends State<ExtractData3> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('patientData')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('bloodGlucose')
          .snapshots(),
      builder: (context, snapshot) {
        final value = snapshot.data!.docs;
        final List<FlSpot> data1 = [];
        double index = 1.0;

        for (var val in value) {
          double glucose = val.get('blood glucose (mmol|L)');
          data1.add(FlSpot(index++, glucose.toDouble()));
        }
        return Charts(
          units: 'mmol/L',
          yStart: 0,
          bool1: false,
          yLength: 10,
          xLength: numberOfBGPoints.toDouble(),
          list: data1,
        );
      },
    );
  }
}
