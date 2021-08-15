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
List bg = [];

var varianceHR; // HR variables
var standardDeviationHR;
var avgHeartRate;
List hr = [];

var variancePressureSys; // systolic BP variables
var standardDeviationSys;
var avgPressureSys;
List sys = [];

var variancePressureDia; // diastolic BP variables
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
    // get BG info (used to calculate variance, standard dev, and range)
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
    // get HR info (used to calculate variance, standard dev, and range)
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
    // get BP (systolic) info (used to calculate variance, standard dev, and range)
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
    // get BP (diastolic) info (used to calculate variance, standard dev, and range)
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
    final bpData =
        await patientData.collection('bloodPressure').orderBy('uploaded').get();
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
    final bgData =
        await patientData.collection('bloodGlucose').orderBy('uploaded').get();
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
    final hrData =
    await patientData.collection('heartRate').orderBy('uploaded').get();
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

  @override
  void initState() {
    // initialize functions
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
                : Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Center(
                      child: NoDataCard(
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            'No data has been uploaded for Blood Pressure. Please use the Data Input Page if you wish to add any.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
          Container(
            child: data2.isNotEmpty
                // if list is not empty, display the graph and summary card; if empty, display text telling user to input data
                ? extractData2()
                : Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Center(
                      child: NoDataCard(
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            'No data has been uploaded for Blood Glucose. Please use the Data Input Page if you wish to add any.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
          Container(
            child: data3.isNotEmpty
                // if list is not empty, display the graph and summary card; if empty, display text telling user to input data
                ? extractData3()
                : Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Center(
                      child: NoDataCard(
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            'No data has been uploaded for Heart Rate. Please use the Data Input Page if you wish to add any.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
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
          range: 'range',
          // range: '${bg[0]} - ${bg[numberOfBGPoints - 1]}',
          //range: '${bg.first} - ${bg.last}',
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
          range: 'range',
          // range: '${hr[0]} - ${hr[numberOfHRPoints - 1]}',
        ),
      ],
    );
  }
}

class NoDataCard extends StatelessWidget {
  // card to show if user has no data of specific type
  final Widget child;

  NoDataCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: child,
      ),
      margin: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: Color(0xFF607D8B),
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }
}
