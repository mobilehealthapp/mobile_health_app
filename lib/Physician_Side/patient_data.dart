import 'package:calc/calc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:mobile_health_app/constants.dart';
import 'package:mobile_health_app/Graphs/graph_data.dart';

import '/Graphs/graph_info.dart';

//This file is identical to the health analysis file on the patient side of the app, except several variables must be declared multiple times in various functions
//The purpose of this file is for doctors to view each patient's data
List<FlSpot> heartRateList = [];
List<FlSpot> diastolicList = [];
List<FlSpot> systolicList = [];
List<FlSpot> glucoseList = [];
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

class PatientData extends StatefulWidget {
  final patientUID;
  final patientName;
  PatientData({this.patientUID, this.patientName});
  @override
  _PatientDataState createState() => _PatientDataState();
}

class _PatientDataState extends State<PatientData> {
  bool isBGFilled = true;
  bool isBPFilled = true;
  bool isHRFilled = true;
  var patientData;

  var bloodGlucose;
  var bloodPressure;
  var heartRate;

  bgGet() async {
    bg = [];
    var patientData = FirebaseFirestore.instance
        .collection('patientData')
        .doc(widget.patientUID);
    var bloodGlucose = patientData.collection('bloodGlucose');
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
    var patientData = FirebaseFirestore.instance
        .collection('patientData')
        .doc(widget.patientUID);
    var heartRate = patientData.collection('heartRate');
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
    var patientData = FirebaseFirestore.instance
        .collection('patientData')
        .doc(widget.patientUID);
    var bloodPressure = patientData.collection('bloodPressure');
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
    var patientData = FirebaseFirestore.instance
        .collection('patientData')
        .doc(widget.patientUID);
    var bloodPressure = patientData.collection('bloodPressure');
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
    var patientData = FirebaseFirestore.instance
        .collection('patientData')
        .doc(widget.patientUID);
    var bloodGlucose = patientData.collection('bloodGlucose');
    QuerySnapshot<Map<String, dynamic>> getBG = await bloodGlucose.get();
    numberOfBGPoints = getBG.docs.length;
    return numberOfBGPoints;
  }

  getNumberOfBPPoints() async {
    // gets length of list of BP points uploaded for user
    var patientData = FirebaseFirestore.instance
        .collection('patientData')
        .doc(widget.patientUID);
    var bloodPressure = patientData.collection('bloodPressure');
    QuerySnapshot<Map<String, dynamic>> getBP = await bloodPressure.get();
    numberOfBPPoints = getBP.docs.length;
    return numberOfBPPoints;
  }

  getNumberOfHRPoints() async {
    // gets length of list of HR points uploaded for user
    var patientData = FirebaseFirestore.instance
        .collection('patientData')
        .doc(widget.patientUID);
    var heartRate = patientData.collection('heartRate');
    QuerySnapshot<Map<String, dynamic>> getHR = await heartRate.get();
    numberOfHRPoints = getHR.docs.length;
    return numberOfHRPoints;
  }

  getUploadedData() async {
    // gets averages of each data type for user
    var patientData = FirebaseFirestore.instance
        .collection('patientData')
        .doc(widget.patientUID);
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
    // gets list of HR points to use in Graphs
    heartRateList = [];
    var patientData = FirebaseFirestore.instance
        .collection('patientData')
        .doc(widget.patientUID);
    final hrData =
        await patientData.collection('heartRate').orderBy('uploaded').get();
    final value = hrData.docs;
    double index = 1.0;
    for (var val in value) {
      int heartrate = val.get('heart rate');
      setState(() {
        heartRateList.add(FlSpot(index++, heartrate.toDouble()));
      });
    }
    return heartRateList;
  }

  hrFilledYN() {
    if (heartRateList == []) {
      isHRFilled = false;
    }
  }

  Future<List<FlSpot>> getDiasData() async {
    // gets list of BP (diastolic) points to use in Graphs
    diastolicList = [];
    var patientData = FirebaseFirestore.instance
        .collection('patientData')
        .doc(widget.patientUID);
    final bpData =
        await patientData.collection('bloodPressure').orderBy('uploaded').get();
    final value = bpData.docs;
    double index = 1.0;
    for (var val in value) {
      double dias = val.get('diastolic');
      setState(() {
        diastolicList.add(FlSpot(index++, dias.toDouble()));
      });
    }
    return diastolicList;
  }

  Future<List<FlSpot>> getSysData() async {
    // gets list of BP (systolic) points to use in Graphs
    systolicList = [];
    var patientData = FirebaseFirestore.instance
        .collection('patientData')
        .doc(widget.patientUID);
    final bpData =
        await patientData.collection('bloodPressure').orderBy('uploaded').get();
    final value = bpData.docs;
    double index2 = 1.0;
    for (var val in value) {
      double sys = val.get('systolic');
      setState(() {
        systolicList.add(FlSpot(index2++, sys.toDouble()));
      });
    }
    return systolicList;
  }

  Future<List<FlSpot>> getBGData() async {
    // gets list of BG points to use in Graphs
    glucoseList = [];
    var patientData = FirebaseFirestore.instance
        .collection('patientData')
        .doc(widget.patientUID);
    final bgData =
        await patientData.collection('bloodGlucose').orderBy('uploaded').get();
    final value = bgData.docs;
    double index = 1.0;
    for (var val in value) {
      double glucose = val.get('blood glucose (mmol|L)');
      setState(() {
        glucoseList.add(FlSpot(index++, glucose.toDouble()));
      });
    }
    return glucoseList;
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
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          widget.patientName,
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          SizedBox(
            height: 30.0,
          ),
          Container(
            child: diastolicList.isNotEmpty
                ? extractBP()
                : NoDataCard(
                    textBody:
                        'The patient hasnt uploaded any data for Blood pressure'),
          ),
          SizedBox(
            height: 25.0,
          ),
          Container(
            child: glucoseList.isNotEmpty
                ? extractBG()
                : NoDataCard(
                    textBody:
                        'The patient hasnt uploaded any data for Blood pressure'),
          ),
          SizedBox(
            height: 25.0,
          ),
          Container(
            child: heartRateList.isNotEmpty
                ? extractHR()
                : NoDataCard(
                    textBody:
                        'The patient hasnt uploaded any data for Blood pressure'),
          ),
        ],
      ),
    );
  }

  Widget extractHR() {
    // graph of HR data
    return Column(
      children: [
        Text(
          'Heart Rate',
          style: kGraphTitleTextStyle,
          textAlign: TextAlign.center,
        ),
        HealthCharts(
          graphType: HealthCharts.HR,
          unitOfMeasurement: 'BPM',
          yStart: 30,
          showDots: false,
          yLength: 200,
          xLength: numberOfHRPoints.toDouble(),
          primaryDataList: heartRateList,
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

  Widget extractBP() {
    // graph of BP data
    return Column(
      children: [
        Text(
          'Blood Pressure',
          style: kGraphTitleTextStyle,
          textAlign: TextAlign.center,
        ),
        HealthCharts(
          graphType: HealthCharts.BP,
          unitOfMeasurement: 'mmHg',
          yStart: 10,
          showDots: false,
          yLength: 180,
          xLength: numberOfBPPoints.toDouble(),
          primaryDataList: diastolicList,
          secondaryDataList: systolicList,
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
      ],
    );
  }

  Widget extractBG() {
    // graph of BG data
    return Column(children: [
      Text(
        'Blood Glucose',
        style: kGraphTitleTextStyle,
        textAlign: TextAlign.center,
      ),
      HealthCharts(
        graphType: HealthCharts.BG,
        unitOfMeasurement: 'mmol/L',
        yStart: 0,
        showDots: false,
        yLength: 10,
        xLength: numberOfBGPoints.toDouble(),
        primaryDataList: glucoseList,
      ),
      FullSummaryCard(
        avgValue: '$avgGlucose mmol/L',
        varValue: '$varianceBG mmol/L',
        sdValue: '$standardDeviationBG mmol/L',
        range: 'range',
        // range: '${bg[0]} - ${bg[numberOfBGPoints - 1]}',
        //range: '${bg.first} - ${bg.last}',
      ),
    ]);
    // DoctorList()
  }
}

class NoDataCard extends StatelessWidget {
  // card to display when user has no data of certain (or all) type(s)
  final String textBody;

  NoDataCard({required this.textBody});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Center(
        child: Container(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                textBody,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          margin: EdgeInsets.all(15.0),
          decoration: BoxDecoration(
            color: Color(0xFF607D8B),
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }
}
