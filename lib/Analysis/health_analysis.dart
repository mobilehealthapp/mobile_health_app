import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_health_app/Constants.dart';
import 'package:mobile_health_app/Drawers/drawers.dart';
import 'package:mobile_health_app/Graphs/graphData.dart';
import '/Drawers/drawers.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/graphs/graph_info.dart';
import 'package:calc/calc.dart';

var patientData = FirebaseFirestore.instance.collection('patientData').doc(
    FirebaseAuth.instance.currentUser!
        .uid); // DocumentReference used to access patient's uploaded medical data on Firestore
var bloodGlucose = patientData.collection(
    'bloodGlucose'); // CollectionReference used to access patient's BG data
var bloodPressure = patientData.collection(
    'bloodPressure'); // CollectionReference used to access patient's BP data
var heartRate = patientData.collection(
    'heartRate'); // CollectionReference used to access patient's HR data

List<FlSpot> data1 = []; // used for systolic BP in fl_chart
List<FlSpot> data1a = []; // used for diastolic BP in fl_chart
List<FlSpot> data2 = []; // used for BG in fl_chart
List<FlSpot> data3 = []; // used for HR in fl_chart

late int numberOfBGPoints = 0;
late int numberOfBPPoints = 0;
late int numberOfHRPoints = 0;

var varianceBG; // BG variables
var standardDeviationBG;
var avgGlucose;
var firstBG;
var lastBG;
List bg = [];

var varianceHR; // HR variables
var standardDeviationHR;
var avgHeartRate;
var firstHR;
var lastHR;
List hr = [];

var variancePressureSys; // systolic BP variables
var standardDeviationSys;
var avgPressureSys;
var firstSys;
var lastSys;
List sys = [];

var variancePressureDia; // diastolic BP variables
var standardDeviationDia;
var avgPressureDia;
var firstDia;
var lastDia;
List dia = [];

class HealthAnalysis extends StatefulWidget {
  @override
  _HealthAnalysisState createState() => _HealthAnalysisState();
}

class _HealthAnalysisState extends State<HealthAnalysis> {
  bgGet() async {
    // calculates standard deviation, variance, and range of BG
    bg = [];

    final bgData = await bloodGlucose.get();
    final value = bgData.docs;
    for (var val in value) {
      // fetch data from firestore - and add it in the dynamic array bg.
      double bgGet = val.get('blood glucose (mmol|L)');
      bg.add(bgGet.toDouble());
    }bg.sort();

    var doubles = bg
        .map((e) => e as double)
        .toList(); // converts dynamic list to double list

    setState(() {
      if (bg.length > 1) {
        final sdv = doubles.standardDeviation();
        standardDeviationBG =
            sdv.toStringAsFixed(3); // show only 3 digits after the comma.
        var sdv2 = sdv;
        varianceBG = sqrt(sdv2).toStringAsFixed(3);
        firstBG = bg.first;
        lastBG = bg.last;
      } else {
        standardDeviationBG = 0;
        varianceBG = 0;
        firstBG = 0;
        lastBG = 0;
      }
    });
    bg.sort();
    return [standardDeviationBG, varianceBG, bg];
  }

  hrGet() async {
    // calculates standard deviation, variance, and range of HR
    hr = [];
    final hrData = await heartRate.get();
    final value = hrData.docs;
    for (var val in value) {
      int hrGet = val.get('heart rate');
      hr.add(hrGet.toDouble());
    }
    hr.sort();

    var doubles = hr.map((e) => e as double).toList();

    setState(() {
      if (hr.length > 1) {
        final sdv = doubles.standardDeviation().toDouble();
        standardDeviationHR = sdv.truncateToDouble();
        varianceHR = sqrt(standardDeviationHR).toStringAsFixed(3);
        firstHR = hr.first;
        lastHR = hr.last;
      } else {
        standardDeviationHR = 0;
        varianceHR = 0;
        firstHR = 0;
        lastHR = 0;
      }
    });
    hr.sort();
    return [standardDeviationHR, varianceHR, hr];
  }

  sysGet() async {
    // calculates standard deviation, variance, and range of systolic BP
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
      if (sys.length > 1) {
        final sdv = doubles.standardDeviation().toDouble();
        standardDeviationSys = sdv.truncateToDouble();
        variancePressureSys = sqrt(standardDeviationSys).toStringAsFixed(3);
        firstSys = sys.first;
        lastSys = sys.last;
      } else {
        standardDeviationSys = 0;
        variancePressureSys = 0;
        firstSys = 0;
        lastSys = 0;
      }
    });

    sys.sort();
    return [
      standardDeviationSys,
      variancePressureSys,
      sys,
      firstSys,
      lastSys,
    ];
  }

  diaGet() async {
    // calculates standard deviation, variance, and range of diastolic BP
    dia = [];
    final bpData = await bloodPressure.get();
    final value = bpData.docs;
    for (var val in value) {
      double bpGet = val.get('diastolic');
      dia.add(bpGet.toDouble());
    }
    dia.sort();

    var doubles = dia.map((e) => e as double).toList();

    setState(() {
      if (dia.length > 1) {
        final sdv = doubles.standardDeviation().toDouble();
        standardDeviationDia = sdv.truncateToDouble();
        variancePressureDia = sqrt(standardDeviationDia).toStringAsFixed(3);
        firstDia = dia.first;
        lastDia = dia.last;
      } else {
        standardDeviationDia = 0;
        variancePressureDia = 0;
        firstDia = 0;
        lastDia = 0;
      }
    });
    dia.sort();

    return [
      standardDeviationDia,
      variancePressureDia,
      dia,
      firstDia,
      lastDia,
    ];
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

  Future<List<FlSpot>> getSysData() async {
    // gets list of BP (systolic) points to use in Graphs
    data1 = [];
    final bpData =
        await patientData.collection('bloodPressure').orderBy('uploaded').get();
    final value = bpData.docs;
    double index2 = 1.0;
    for (var val in value) {
      double sys = val.get('systolic');
      setState(() {
        data1.add(FlSpot(index2++, sys.toDouble()));
      });
    }
    return data1;
  }

  Future<List<FlSpot>> getDiasData() async {
    // gets list of BP (diastolic) points to use in Graphs
    data1a = [];
    final bpData = await bloodPressure.orderBy('uploaded').get();
    final value = bpData.docs;
    double index = 1.0;
    for (var val in value) {
      double dias = val.get('diastolic');
      setState(() {
        data1a.add(FlSpot(index++, dias.toDouble()));
      });
    }
    return data1a;
  }

  Future<List<FlSpot>> getBGData() async {
    // gets list of BG points to use in Graphs
    data2 = [];
    final bgData = await bloodGlucose.orderBy('uploaded').get();
    final value = bgData.docs;
    double index = 1.0;
    for (var val in value) {
      double glucose = val.get('blood glucose (mmol|L)');
      setState(() {
        data2.add(FlSpot(index++, glucose.toDouble()));
      });
    }
    return data2;
  }

  Future<List<FlSpot>> getHRData() async {
    // gets list of HR points to use in Graphs
    data3 = [];
    final hrData = await heartRate.orderBy('uploaded').get();
    final value = hrData.docs;
    double index = 1.0;
    for (var val in value) {
      int heartrate = val.get('heart rate');
      setState(() {
        data3.add(FlSpot(index++, heartrate.toDouble()));
      });
    }
    return data3;
  }

  getUploadedData() async {
    // gets averages of each data type for user
    final bpData = await bloodPressure
        .orderBy(
        'uploaded') // orders by the field 'uploaded' which is same as ordering from oldest to newest
        .get();
    final bpData1 = bpData.docs;
    final bgData = await bloodGlucose
        .orderBy(
        'uploaded') // orders by the field 'uploaded' which is same as ordering from oldest to newest
        .get();
    final bgData1 = bgData.docs;
    final hrData = await heartRate
        .orderBy(
        'uploaded') // orders by the field 'uploaded' which is same as ordering from oldest to newest
        .get();
    final hrData1 = hrData.docs;
    final DocumentSnapshot uploadedData = await patientData.get();
    setState(
          () {
        if (bpData1.isNotEmpty) {
          avgPressureSys =
              uploadedData.get('Average Blood Pressure (systolic)');
        } else {
          avgPressureSys = 0;
        }
        if (bpData1.isNotEmpty) {
          avgPressureDia =
              uploadedData.get('Average Blood Pressure (diastolic)');
        } else {
          avgPressureDia = 0;
        }
        if (bgData1.isNotEmpty) {
          avgGlucose = uploadedData.get('Average Blood Glucose (mmol|L)');
        } else {
          avgGlucose = 0;
        }
        if (hrData1.isNotEmpty) {
          avgHeartRate = uploadedData.get('Average Heart Rate');
        } else {
          avgHeartRate = 0;
        }
      },
    );
  }

  @override
  void initState() {
    // initialize functions
    bgGet();
    hrGet();
    diaGet();
    sysGet();
    getHRData();
    getSysData();
    getDiasData();
    getBGData();
    getUploadedData();
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey[600],
        onPressed: () {
          Navigator.of(context).pushNamed('/dataInput');
        },
        child: Icon(
          Icons.camera_alt_rounded,
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          SizedBox(
            height: 20.0,
          ),
          Container(
            child: data1.isNotEmpty
                // if list is not empty, display the graph and summary card; if empty, display text telling user to input data
                ? extractData()
                : NoDataCard(
                    textBody:
                        'No data has been uploaded for Blood Pressure. Please use the Data Input Page if you wish to add any.',
                  ),
          ),
          Container(
            child: data2.isNotEmpty
                // if list is not empty, display the graph and summary card; if empty, display text telling user to input data
                ? extractData2()
                : NoDataCard(
                    textBody:
                        'No data has been uploaded for Blood Glucose. Please use the Data Input Page if you wish to add any.',
                  ),
          ),
          Container(
            child: data3.isNotEmpty
                // if list is not empty, display the graph and summary card; if empty, display text telling user to input data
                ? extractData3()
                : NoDataCard(
                    textBody:
                        'No data has been uploaded for Heart Rate. Please use the Data Input Page if you wish to add any.',
                  ),
          ),
          SizedBox(
            height: 70.0,
          ),
        ],
      ),
    );
  }

  Widget extractData() {
    // graph of BP data
    return Column(
      children: [
        Text(
          'Blood Pressure',
          style: kGraphTitleTextStyle,
          textAlign: TextAlign.center,
        ),
        Charts2(
          units: 'mmHg',
          yStart: 10,
          bool1: false,
          yLength: 180,
          xLength: numberOfBPPoints.toDouble(),
          list: data1,
          list2: data1a,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            NewLegend(name: 'Systolic', color: Colors.black),
            NewLegend(name: 'Diastolic', color: Colors.red),
          ],
        ),
        FullSummaryCard(
          avgValue: '$avgPressureSys/$avgPressureDia mmHg',
          varValue: '$variancePressureSys/$variancePressureDia mmHg',
          sdValue: '$standardDeviationSys/$standardDeviationDia mmHg',
          range: '$firstSys/$firstDia - $lastSys/$lastDia',
        ),
        SizedBox(
          height: 20.0,
        ),
      ],
    );
  }

  Widget extractData2() {
    // graph of BG data
    return Column(
      children: [
        Text(
          'Blood Glucose',
          style: kGraphTitleTextStyle,
          textAlign: TextAlign.center,
        ),
        Charts3(
          units: 'mmol/L',
          yStart: 0,
          bool1: false,
          yLength: 10,
          xLength: numberOfBGPoints.toDouble(),
          list: data2,
        ),
        FullSummaryCard(
          avgValue: '$avgGlucose mmol/L',
          varValue: '$varianceBG mmol/L',
          sdValue: '$standardDeviationBG mmol/L',
          range: '$firstBG - $lastBG',
        ),
        SizedBox(
          height: 20.0,
        ),
      ],
    );
  }

  Widget extractData3() {
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
          list: data3,
        ),
        FullSummaryCard(
          avgValue: '$avgHeartRate BPM',
          varValue: '$varianceHR BPM',
          sdValue: '  $standardDeviationHR BPM',
          range: '$firstHR - $lastHR',
        ),
      ],
    );
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
