import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_health_app/Data/patient_data_functions.dart';
import 'package:mobile_health_app/constants.dart';
import 'package:mobile_health_app/Drawers/drawers.dart';
import 'package:mobile_health_app/Graphs/graph_data.dart';
import '/Drawers/drawers.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/Graphs/graph_info.dart';
import 'package:calc/calc.dart';

List<FlSpot> sysChart = []; // used for systolic BP in fl_chart
List<FlSpot> diaChart = []; // used for diastolic BP in fl_chart
List<FlSpot> bgChart = []; // used for BG in fl_chart
List<FlSpot> hrChart = []; // used for HR in fl_chart

// used for lengths
int bgpoints = 0;
int bppoints = 0;
int hrpoints = 0;

// systolic BP variables
var variancePressureSys; // variance of systolic BP
var standardDeviationSys; // standard deviation of systolic BP
var avgPressureSys; // average of systolic BP
var firstSys; // lowest point in systolic BP's range
var lastSys; // highest point in systolic BP's range
List sys = []; // list of all systolic BP data points used for calculations

// diastolic BP variables
var variancePressureDia; // variance of diastolic BP
var standardDeviationDia; // standard deviation of diastolic BP
var avgPressureDia; // average of diastolic BP
var firstDia; // lowest point in diastolic BP's range
var lastDia; // highest point in diastolic BP's range
List dia = []; // list of all diastolic BP data points used for calculations

// BG variables
var varianceBG; // variance of BG
var standardDeviationBG; // standard deviation of BG
var avgGlucose; // average of BG
var firstBG; // lowest point in BG's range
var lastBG; // highest point in BG's range
List bg = []; // list of all BG data points used for calculations

// HR variables
var varianceHR; // variance of HR
var standardDeviationHR; // standard deviation of HR
var avgHeartRate; // average of HR
var firstHR; // lowest point in HR's range
var lastHR; // highest point in HR's range
List hr = []; // list of all HR data points used for calculations

class HealthAnalysis extends StatefulWidget {
  @override
  _HealthAnalysisState createState() => _HealthAnalysisState();
}

class _HealthAnalysisState extends State<HealthAnalysis> {
  var patientData = FirebaseFirestore.instance
      .collection('patientData')
      .doc(FirebaseAuth.instance.currentUser!.uid);
  Datafunction datafunc = Datafunction(FirebaseAuth.instance.currentUser!.uid);
  var bloodGlucose;
  var bloodPressure;
  var heartRate;

  sysGet() async {
    // calculates standard deviation, variance, and range of systolic BP
    sys = [];
    final value = await datafunc.getAmount(
        50, 'bloodPressure'); //takes this persons last 50 values
    if (value != null) {
      for (var val in value) {
        double bpGet = datafunc.getSys(val);
        sys.add(bpGet.toDouble());
        bppoints++;
      }
    }
    sys.sort();
    var doubles = sys.map((e) => e as double).toList();

    setState(() {
      // if there's more than 1 data point, calculate the values; if not, automatically set to 0
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
    final value = await datafunc.getAmount(50, 'bloodPressure');
    if (value != null) {
      for (var val in value) {
        double bpGet = datafunc.getDia(val);
        dia.add(bpGet.toDouble());
      }
    }
    dia.sort();
    var doubles = dia.map((e) => e as double).toList();

    setState(() {
      // if there's more than 1 data point, calculate the values; if not, automatically set to 0
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

  bgGet() async {
    // calculates standard deviation, variance, and range of BG
    bg = [];
    final value = await datafunc.getAmount(50, 'bloodGlucose');
    if (value != null) {
      for (var val in value) {
        // fetch data from firestore - and add it in the dynamic array bg.
        double bgGet = datafunc.getMMOL(val);
        bg.add(bgGet.toDouble());
        bgpoints++;
      }
    }
    bg.sort();
    var doubles = bg
        .map((e) => e as double)
        .toList(); // converts dynamic list to double list

    setState(() {
      // if there's more than 1 data point, calculate the values; if not, automatically set to 0
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
    final value = await datafunc.getAmount(50, 'heartRate');
    if (value != null) {
      for (var val in value) {
        int hrGet = datafunc.getHR(val);
        hr.add(hrGet.toDouble());
        hrpoints++;
      }
    }
    hr.sort();
    var doubles = hr.map((e) => e as double).toList();

    setState(() {
      // if there's more than 1 data point, calculate the values; if not, automatically set to 0
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

  getNumberOfBGPoints() async {
    // gets length of list of BG points uploaded for user
    return bgpoints;
  }

  getNumberOfBPPoints() async {
    // gets length of list of BP points uploaded for user
    return bppoints;
  }

  getNumberOfHRPoints() async {
    // gets length of list of HR points uploaded for user
    return hrpoints;
  }

  Future<List<FlSpot>> getSysData() async {
    // gets list of BP (systolic) points to use in Graphs
    sysChart = [];
    final bpData = await datafunc.getAmount(50, 'bloodPressure');
    double index2 = 1.0;
    if (bpData != null) {
      for (var val in bpData) {
        double sys = datafunc.getSys(val);
        setState(() {
          sysChart.add(FlSpot(index2++, sys.toDouble()));
        });
      }
    }
    return sysChart;
  }

  Future<List<FlSpot>> getDiasData() async {
    // gets list of BP (diastolic) points to use in Graphs
    diaChart = [];
    final bpData = await datafunc.getAmount(50, 'bloodPressure');
    double index = 1.0;
    if (bpData != null) {
      for (var val in bpData) {
        double dias = datafunc.getDia(val);
        setState(() {
          diaChart.add(FlSpot(index++, dias.toDouble()));
        });
      }
    }
    return diaChart;
  }

  Future<List<FlSpot>> getBGData() async {
    // gets list of BG points to use in Graphs
    bgChart = [];
    final bgData = await datafunc.getAmount(50, 'bloodGlucose');
    double index = 1.0;
    if (bgData != null) {
      for (var val in bgData) {
        double glucose = datafunc.getMMOL(val);
        setState(() {
          bgChart.add(FlSpot(index++, glucose.toDouble()));
        });
      }
    }
    return bgChart;
  }

  Future<List<FlSpot>> getHRData() async {
    // gets list of HR points to use in Graphs
    hrChart = [];
    final hrData = await datafunc.getAmount(50, 'heartRate');
    double index = 1.0;
    if (hrData != null) {
      for (var val in hrData) {
        int heartrate = datafunc.getHR(val);
        setState(() {
          hrChart.add(FlSpot(index++, heartrate.toDouble()));
        });
      }
    }
    return hrChart;
  }

  getUploadedData() async {
    bloodPressure = patientData.collection('bloodPressure');
    bloodGlucose = patientData.collection('bloodGlucose');
    heartRate = patientData.collection('heartRate');
    // gets averages of each data type for user
    final bpData = await datafunc.getAmount(50, 'bloodPressure');
    final bgData = await datafunc.getAmount(50, 'bloodGlucose');
    final hrData = await datafunc.getAmount(50, 'heartRate');
    setState(
      () {
        // if data is not empty, calculate avgs; if empty, automatically set to 0
        if (bpData != null) {
          double sysaverage = 0;
          double diaaverage = 0;
          for (int i = 0; i < bpData.length; i++) {
            sysaverage += datafunc.getSys(bpData[i]);
            diaaverage += datafunc.getSys(bpData[i]);
          }
          avgPressureSys = sysaverage / bpData.length;
          avgPressureDia = diaaverage / bpData.length;
        } else {
          avgPressureSys = 0;
          avgPressureDia = 0;
        }
        if (bgData != null) {
          double averagebg = 0;
          for (int i = 0; i < bgData.length; i++) {
            averagebg += datafunc.getMMOL(bgData[i]);
          }
          avgGlucose = averagebg / bgData.length;
        } else {
          avgGlucose = 0;
        }
        if (hrData != null) {
          double averagehr = 0;
          for (int i = 0; i < hrData.length; i++) {
            averagehr += datafunc.getMMOL(hrData[i]);
          }
          avgHeartRate = averagehr / hrData.length;
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
            child: sysChart.isNotEmpty
                // if list is not empty, display the graph and summary card; if empty, display text telling user to input data
                ? extractBP()
                : NoDataCard(
                    textBody:
                        'No data has been uploaded for Blood Pressure. Please use the Data Input Page if you wish to add any.', // these texts can be changed to whatever is seen as fit! they are just a placeholder
                  ),
          ),
          Container(
            child: bgChart.isNotEmpty
                // if list is not empty, display the graph and summary card; if empty, display text telling user to input data
                ? extractBG()
                : NoDataCard(
                    textBody:
                        'No data has been uploaded for Blood Glucose. Please use the Data Input Page if you wish to add any.', // these texts can be changed to whatever is seen as fit! they are just a placeholder
                  ),
          ),
          Container(
            child: hrChart.isNotEmpty
                // if list is not empty, display the graph and summary card; if empty, display text telling user to input data
                ? extractHR()
                : NoDataCard(
                    textBody:
                        'No data has been uploaded for Heart Rate. Please use the Data Input Page if you wish to add any.', // these texts can be changed to whatever is seen as fit! they are just a placeholder
                  ),
          ),
          SizedBox(
            height: 70.0,
          ),
        ],
      ),
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
          minY: 10,
          showDots: false,
          maxY: 180,
          maxX: bppoints.toDouble(),
          primaryDataList: sysChart,
          secondaryDataList: diaChart,
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

  Widget extractBG() {
    // graph of BG data
    return Column(
      children: [
        Text(
          'Blood Glucose',
          style: kGraphTitleTextStyle,
          textAlign: TextAlign.center,
        ),
        HealthCharts(
          graphType: HealthCharts.BG,
          unitOfMeasurement: 'mmol/L',
          minY: 0,
          showDots: false,
          maxY: 10,
          maxX: bgpoints.toDouble(),
          primaryDataList: bgChart,
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

  Widget extractHR() {
    // graph of HR data
    return Column(
      children: [
        Text(
          'Pulse Rate',
          style: kGraphTitleTextStyle,
          textAlign: TextAlign.center,
        ),
        HealthCharts(
          graphType: HealthCharts.HR,
          unitOfMeasurement: 'BPM',
          minY: 30,
          showDots: false,
          maxY: 200,
          maxX: hrpoints.toDouble(),
          primaryDataList: hrChart,
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
