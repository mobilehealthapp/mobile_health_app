import 'package:flutter/material.dart';
import 'package:mobile_health_app/Constants.dart';
import 'package:mobile_health_app/graphData.dart';
import 'settings_pages/settings_constants.dart';
import 'drawers.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'settings_pages/graph_info.dart';
import 'package:calc/calc.dart';

var patientData = FirebaseFirestore.instance
    .collection('patientData')
    .doc(FirebaseAuth.instance.currentUser!.uid);
var bloodGlucose = patientData.collection('bloodGlucose');
var bloodPressure = patientData.collection('bloodPressure');
var heartRate = patientData.collection('heartRate');
List<FlSpot> data1 = [];
List<FlSpot> data2 = [];
List<FlSpot> data2a = [];
List<FlSpot> data3 = [];
late int numberOfBGPoints = 0;
late int numberOfBPPoints = 0;
late int numberOfHRPoints = 0;

var varianceBG;
var standardDeviationBG;
var avgGlucose;
List bg = [];

var varianceHR;
var standardDeviationHR;
var avgHeartRate;
List hr = [];

var variancePressureSys;
var standardDeviationSys;
var avgPressureSys;
List sys = [];

var variancePressureDia;
var standardDeviationDia;
var avgPressureDia;
List dia = [];

class HealthAnalysis extends StatefulWidget {
  @override
  _HealthAnalysisState createState() => _HealthAnalysisState();
}

class _HealthAnalysisState extends State<HealthAnalysis> {

  bgGet() async {
    bg = [];
    final bgData = await bloodGlucose.get();
    final value = bgData.docs;
    for (var val in value) {
      double bgGet = val.get('blood glucose (mmol|L)');
      bg.add(bgGet.toDouble());
    }
    print('blood glucose: $bg');
    return bg;
  }

  hrGet() async {
    hr = [];
    final hrData = await heartRate.get();
    final value = hrData.docs;
    for (var val in value) {
      int hrGet = val.get('heart rate');
      hr.add(hrGet.toDouble());
    }
    print('heart rate: $hr');
    return hr;
  }

  sysGet() async {
    sys = [];
    final bpData = await bloodPressure.get();
    final value = bpData.docs;
    for (var val in value) {
      double bpGet = val.get('systolic');
      sys.add(bpGet.toDouble());
    }
    print('systolic: $sys');
    return sys;
  }

  diaGet() async {
    dia = [];
    final bpData = await bloodPressure.get();
    final value = bpData.docs;
    for (var val in value) {
      double bpGet = val.get('diastolic');
      dia.add(bpGet.toDouble());
    }
    print('diastolic: $dia');
    return dia;
  }

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

  getUploadedData() async {
    final DocumentSnapshot uploadedData = await patientData
        .get();
    setState(
          () {
        avgGlucose = uploadedData.get('Average Blood Glucose (mmol|L)');
        avgPressureDia = uploadedData.get('Average Blood Pressure (diastolic)');
        avgPressureSys = uploadedData.get('Average Blood Pressure (systolic)');
        avgHeartRate = uploadedData.get('Average Heart Rate');
      },
    );
  }

  Future<List<FlSpot>> getHRData() async {
    data1 = [];
    final hrData =
        await patientData.collection('heartRate').orderBy('uploaded').get();
    final value = hrData.docs;
    double index = 1.0;
    for (var val in value) {
      int heartrate = val.get('heart rate');
      setState(() {
        data1.add(FlSpot(index++, heartrate.toDouble()));
      });
    }
    return data1;
  }

  Future<List<FlSpot>> getDiasData() async {
    data2 = [];
    final bpData =
        await patientData.collection('bloodPressure').orderBy('uploaded').get();
    final value = bpData.docs;
    double index = 1.0;
    for (var val in value) {
      double dias = val.get('diastolic');
      setState(() {
        data2.add(FlSpot(index++, dias.toDouble()));
      });
    }
    return data2;
  }

  Future<List<FlSpot>> getSysData() async {
    data2a = [];
    final bpData =
        await patientData.collection('bloodPressure').orderBy('uploaded').get();
    final value = bpData.docs;
    double index2 = 1.0;
    for (var val in value) {
      double sys = val.get('systolic');
      setState(() {
        data2a.add(FlSpot(index2++, sys.toDouble()));
      });
    }
    return data2a;
  }

  Future<List<FlSpot>> getBGData() async {
    data3 = [];
    final bgData =
        await patientData.collection('bloodGlucose').orderBy('uploaded').get();
    final value = bgData.docs;
    double index = 1.0;
    for (var val in value) {
      double glucose = val.get('blood glucose (mmol|L)');
      setState(() {
        data3.add(FlSpot(index++, glucose.toDouble()));
      });
    }
    return data3;
  }

  @override
  void initState() {
    bgGet();
    hrGet();
    diaGet();
    sysGet();
    getUploadedData();
    getHRData();
    getSysData();
    getDiasData();
    getBGData();
    getNumberOfBPPoints();
    getNumberOfBGPoints();
    getNumberOfHRPoints();
    super.initState();
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
        children: [
          SizedBox(
            height: 30.0,
          ),
          Text(
            'Blood Pressure',
            style: kGraphTitleTextStyle,
            textAlign: TextAlign.center,
          ),
          Container(
            child: extractData2(),
          ),
          FullSummaryCard(
            avgValue: '$avgPressureSys/$avgPressureDia mmHg',
            varValue: 'mmHg',
            sdValue: 'mmHg',
            sdType: 'Standard Deviation:',
            avgType: 'Average:',
            varType: 'Variance:',
          ),
          SizedBox(
            height: 25.0,
          ),
          Text(
            'Blood Glucose',
            style: kGraphTitleTextStyle,
            textAlign: TextAlign.center,
          ),
          Container(
            child: extractData3(),
          ),
          FullSummaryCard(
            avgValue: '$avgGlucose mmol/L',
            varValue: 'mmol/L',
            sdValue: 'mmol/L',
            sdType: 'Standard Deviation:',
            avgType: 'Average:',
            varType: 'Variance:',
          ),
          SizedBox(
            height: 25.0,
          ),
          Text(
            'Pulse Rate',
            style: kGraphTitleTextStyle,
            textAlign: TextAlign.center,
          ),
          Container(
            child: extractData(),
          ),
          FullSummaryCard(
            avgValue: '$avgHeartRate BPM',
            varValue: 'BPM',
            sdValue: ' BPM',
            sdType: 'Standard Deviation:',
            avgType: 'Average:',
            varType: 'Variance:',
          ),
        ],
      ),
    );
  }
  Widget extractData() {
    return Charts(
      units: 'BPM',
      yStart: 30,
      bool1: false,
      yLength: 200,
      xLength: numberOfHRPoints.toDouble(),
      list: data1,
    );
  }

  Widget extractData2() {
    return Charts2(
      units: 'mmHg',
      yStart: 10,
      bool1: false,
      yLength: 180,
      xLength: numberOfBPPoints.toDouble(),
      list: data2,
      list2: data2a,
    );
  }

  Widget extractData3() {
    return Charts3(
      units: 'mmol/L',
      yStart: 0,
      bool1: false,
      yLength: 10,
      xLength: numberOfBGPoints.toDouble(),
      list: data3,
    );
  }
}