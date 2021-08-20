import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'package:mobile_health_app/Constants.dart';
import 'package:mobile_health_app/Drawers/drawers.dart';
import 'package:mobile_health_app/graphs/graphData.dart';
import '/Drawers/drawers.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/graphs/graph_info.dart';
import 'package:calc/calc.dart';

var patientData = FirebaseFirestore.instance
    .collection('patientData')
    .doc(FirebaseAuth.instance.currentUser!.uid);
var bloodGlucose = patientData.collection('bloodGlucose');
var bloodPressure = patientData.collection('bloodPressure');
var heartRate = patientData.collection('heartRate');
List<FlSpot> data1 = []; //heart rate
List<FlSpot> data2 = []; // systolic
List<FlSpot> data2a = []; // diastolic
List<FlSpot> data3 = []; //heart rate
late int numberOfBGPoints = 0;
late int numberOfBPPoints = 0;
late int numberOfHRPoints = 0;

var varianceBG;
var standardDeviationBG;
var avgGlucose;
List bg = [];
List rangeBG = [];

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
      // fetch data from firestore - and add it in the dynamic array bg.
      double bgGet = val.get('blood glucose (mmol|L)');
      bg.add(bgGet.toDouble());
    }

    var doubles = bg
        .map((e) => e as double)
        .toList(); // converts dynamic list to double list
    bg.sort();
    final sdv = doubles.standardDeviation();
    setState(() {
      if (bg.length > 0) {
        rangeBG[0] = rangeBG[(bg.first)];
        standardDeviationBG =
            sdv.toStringAsFixed(3); // show only 3 digits after the comma.
        var sdv2 = sdv;
        varianceBG = sqrt(sdv2).toStringAsFixed(3);
      } else {
        standardDeviationBG = 0;
        varianceBG = 0;
      }
    });

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

    setState(() {
      if (hr.length > 0) {
        final sdv = doubles.standardDeviation().toDouble();
        standardDeviationHR = sdv.truncateToDouble();
        varianceHR = sqrt(standardDeviationHR).toStringAsFixed(3);
      } else {
        standardDeviationHR = 0;
        varianceHR = 0;
      }
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

    setState(() {
      if (sys.length > 0) {
        final sdv = doubles.standardDeviation().toDouble();
        standardDeviationSys = sdv.truncateToDouble();
        variancePressureSys = sqrt(standardDeviationSys).toStringAsFixed(3);
      } else {
        standardDeviationSys = 0;
        variancePressureSys = 0;
      }
    });

    sys.sort();
    return [
      standardDeviationSys,
      variancePressureSys,
      sys,
    ];
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

    setState(() {
      if (dia.length > 1) {
        final sdv = doubles.standardDeviation().toDouble();
        standardDeviationDia = sdv.truncateToDouble();
        variancePressureDia = sqrt(standardDeviationDia).toStringAsFixed(3);
      } else if (dia.isEmpty) {
        standardDeviationDia = 0;
        variancePressureDia = 0;
      }
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
        if (bg.isEmpty) {
          avgGlucose = 0;
        }
        if (hr.isEmpty) {
          avgHeartRate = 0;
        }
        if (sys.isEmpty) {
          avgPressureSys = 0;
        }
        if (dia.isEmpty) {
          avgPressureDia = 0;
        }

        // if (bg.isNotEmpty) {
        avgGlucose = uploadedData.get('Average Blood Glucose (mmol|L)');
        print(avgGlucose);
        // }
        // if (sys.isEmpty) {
        avgPressureSys = uploadedData.get('Average Blood Pressure (systolic)');
        // }
        // if (dia.isNotEmpty) {
        avgPressureDia = uploadedData.get('Average Blood Pressure (diastolic)');
        // }
        // if (hr.isNotEmpty) {
        avgHeartRate = uploadedData.get('Average Heart Rate');
        // }
      },
    );
  }

  Future<List<FlSpot>> getHRData() async {
    // gets list of HR points to use in Graphs
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
    // gets list of BP (diastolic) points to use in Graphs
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
    // gets list of BP (systolic) points to use in Graphs
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
    // gets list of BG points to use in Graphs
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
        ),
      ),
      body: ListView(
        shrinkWrap: false,
        children: [
          SizedBox(
            height: 30.0,
          ),
          Container(
            child: data2.isNotEmpty && data2a.isNotEmpty
                ? Text(
                    'Blood Pressure',
                    style: kGraphTitleTextStyle,
                    textAlign: TextAlign.center,
                  )
                : Text(''),
          ),
          Container(
            child: data2.isNotEmpty && data2a.isNotEmpty
                ? extractData2()
                : Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          'No data has been uploaded for Blood Pressure. Please use the Data Input Page if you wish to add any.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ), //blood pressure
          ),
          Container(
            child: data2.isNotEmpty && data2a.isNotEmpty
                ? FullSummaryCard(
                    avgValue: '$avgPressureSys/$avgPressureDia mmHg',
                    varValue: '$variancePressureSys/$variancePressureDia mmHg',
                    sdValue: '$standardDeviationSys/$standardDeviationDia mmHg',
                    range: ' range '
                    // range: '${sys[0]}/${dia[0]} - ${sys[numberOfBPPoints -
                    //     1]}/${dia[numberOfBPPoints - 1]}',
                    //range: '${sys.first} - ${sys.last}/' '${dia.first} - ${dia.last}',
                    )
                : Text(''),
          ),
          SizedBox(
            height: 25.0,
          ),
          Container(
            child: data3.isNotEmpty
                ? Text(
                    'Blood Glucose',
                    style: kGraphTitleTextStyle,
                    textAlign: TextAlign.center,
                  )
                : Text(''),
          ),
          Container(
            child: data3.isNotEmpty
                ? extractData3()
                : Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          'No data has been uploaded for Pulse Rate. Please use the Data Input Page if you wish to add any.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
          Container(
            child: data3.isNotEmpty
                ? FullSummaryCard(
                    avgValue: '$avgGlucose mmol/L',
                    varValue: '$varianceBG mmol/L',
                    sdValue: '$standardDeviationBG mmol/L',
                    range: 'RANGE'
                    //TODO fix the error  " RangeError (index): Invalid value: Valid value range is empty: -1" for the range
                    // range: '${bg[0]} - ${bg[numberOfBGPoints - 1]}',
                    //range: '${bg.first} - ${bg.last}',
                    )
                : Text(''),
          ),
          SizedBox(
            height: 25.0,
          ),
          Container(
            child: data1.isNotEmpty
                ? extractData()
                : Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          'No data has been uploaded for Pulse Rate. Please use the Data Input Page if you wish to add any.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
          SizedBox(
            height: 25.0,
          ),
          Text('hr is is $avgHeartRate'),
          Text('sys is $avgPressureSys'),
          Text('dia is $avgPressureDia'),
          Text('bg is $avgGlucose'),
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
        //TODO Fix the display for this graph
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
      bool1: true,
      yLength: 10,
      xLength: numberOfBGPoints.toDouble(),
      list: data3,
    );
    // DoctorList()
  }
}
