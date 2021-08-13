import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'package:mobile_health_app/Constants.dart';
import 'package:mobile_health_app/graphs/graphData.dart';
import 'settings_pages/settings_constants.dart';
import 'drawers.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'graphs/graph_info.dart';
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
  bool isBGFilled = true;
  bool isBPFilled = true;
  bool isHRFilled = true;

  bgGet() async {
    bg = [];
    final bgData = await bloodGlucose.get();
    final value = bgData.docs;
    for (var val in value) {
      double bgGet = val.get('blood glucose (mmol|L)');
      bg.add(bgGet.toDouble());
    }

    var doubles = bg.map((e) => e as double).toList();

    final sdv = doubles.standardDeviation();
    print('sdv for bg is $sdv');
    setState(() {
      standardDeviationBG = sdv.toStringAsFixed(3);
      var sdv2 = sdv;
      varianceBG = sqrt(sdv2).toStringAsFixed(3);
    });
    bg.sort();
    return [standardDeviationBG, varianceBG, bg];
  }

  hrGet() async {
    hr = [];
    final hrData = await heartRate.get();
    final value = hrData.docs;
    for (var val in value) {
      int hrGet = val.get('heart rate');
      hr.add(hrGet.toDouble());
    }

    var doubles = hr.map((e) => e as double).toList();

    final sdv = doubles.standardDeviation().toDouble();

    setState(() {
      standardDeviationHR = sdv.truncateToDouble();
      varianceHR = sqrt(standardDeviationHR).toStringAsFixed(3);
    });
    hr.sort();
    return [standardDeviationHR, varianceHR, hr];
  }

  sysGet() async {
    sys = [];
    final bpData = await bloodPressure.get();
    final value = bpData.docs;
    for (var val in value) {
      double bpGet = val.get('systolic');
      sys.add(bpGet.toDouble());
    }
    sys.sort();

    var doubles = sys.map((e) => e as double).toList();

    final sdv = doubles.standardDeviation().toDouble();

    setState(() {
      standardDeviationSys = sdv.truncateToDouble();
      variancePressureSys = sqrt(standardDeviationSys).toStringAsFixed(3);
    });
    sys.sort();
    return [standardDeviationSys, variancePressureSys, sys];
  }

  diaGet() async {
    dia = [];
    final bpData = await bloodPressure.get();
    final value = bpData.docs;
    for (var val in value) {
      double bpGet = val.get('diastolic');
      dia.add(bpGet.toDouble());
    }
    var doubles = dia.map((e) => e as double).toList();

    final sdv = doubles.standardDeviation().toDouble();

    setState(() {
      standardDeviationDia = sdv.truncateToDouble();
      variancePressureDia = sqrt(standardDeviationDia).toStringAsFixed(3);
    });
    dia.sort();
    return [standardDeviationDia, variancePressureDia, dia];
  }

  getNumberOfBGPoints() async {
    // gets length of list of BG points uploaded for user
    QuerySnapshot<Map<String, dynamic>> getBG = await bloodGlucose.get();
    numberOfBGPoints = getBG.docs.length;
    return numberOfBGPoints;
  }

  getNumberOfBPPoints() async {
    // gets length of list of BP points uploaded for user
    QuerySnapshot<Map<String, dynamic>> getBP = await bloodPressure.get();
    numberOfBPPoints = getBP.docs.length;
    return numberOfBPPoints;
  }

  getNumberOfHRPoints() async {
    // gets length of list of HR points uploaded for user
    QuerySnapshot<Map<String, dynamic>> getHR = await heartRate.get();
    numberOfHRPoints = getHR.docs.length;
    return numberOfHRPoints;
  }

  getUploadedData() async {
    // gets averages of each data type for user
    final DocumentSnapshot uploadedData = await patientData.get();
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
    // gets list of HR points to use in graphs
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

  hrFilledYN() {
    if (data1 == []) {
      isHRFilled = false;
    }
  }

  Future<List<FlSpot>> getDiasData() async {
    // gets list of BP (diastolic) points to use in graphs
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
    // gets list of BP (systolic) points to use in graphs
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
    // gets list of BG points to use in graphs
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
            varValue: '$variancePressureSys/$variancePressureDia mmHg',
            sdValue: '$standardDeviationSys/$standardDeviationDia mmHg',
            range: 'range',
            // range: '${sys[0]}/${dia[0]} - ${sys[numberOfBPPoints -
            //     1]}/${dia[numberOfBPPoints - 1]}',
            //range: '${sys.first} - ${sys.last}/' '${dia.first} - ${dia.last}',
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
            varValue: '$varianceBG mmol/L',
            sdValue: '$standardDeviationBG mmol/L',
            range: 'range',
            // range: '${bg[0]} - ${bg[numberOfBGPoints - 1]}',
            //range: '${bg.first} - ${bg.last}',
          ),
          SizedBox(
            height: 25.0,
          ),
          Container(
              child: isHRFilled
                  ? extractData()
                  : Text(
                      'No data has been uploaded for Heart Rate. Please use the Data Input Page if you wish to add any.')),
        ],
      ),
    );
  }

  Widget extractData() {
    // graph of HR data
    return Column(
      children: [
        Text(
          'Pulse Rate',
          style: kGraphTitleTextStyle,
          textAlign: TextAlign.center,
        ),
        Charts(
          units: 'BPM',
          yStart: 30,
          bool1: false,
          yLength: 200,
          xLength: numberOfHRPoints.toDouble(),
          list: data1,
        ),
        FullSummaryCard(
          avgValue: '$avgHeartRate BPM',
          varValue: '$varianceHR BPM',
          sdValue: '  $standardDeviationHR BPM',
          range: 'range',
          // range: '${hr[0]} - ${hr[numberOfHRPoints - 1]}',
        ),
      ],
    );
  }

  Widget extractData2() {
    // graph of BP data
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
    // graph of BG data
    return Charts3(
      units: 'mmol/L',
      yStart: 0,
      bool1: false,
      yLength: 10,
      xLength: numberOfBGPoints.toDouble(),
      list: data3,
    );
    // DoctorList()
  }
}
