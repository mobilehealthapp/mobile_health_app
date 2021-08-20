import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_health_app/graphs/graph_info.dart';
import 'package:mobile_health_app/Drawers/drawers.dart';
import 'package:mobile_health_app/Constants.dart';
import 'package:mobile_health_app/graphs/graphData.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:mobile_health_app/Analysis/health_analysis.dart';

final patientData = FirebaseFirestore.instance
    .collection('patientData')
    .doc(FirebaseAuth.instance.currentUser!.uid);
final patientRef = FirebaseFirestore.instance
    .collection('patientprofile'); //declare reference high up in file
var name; //declare variable high up in file
var avgGlucose;
var avgPressureDia;
var avgPressureSys;
var avgHeartRate;
List<FlSpot> data1 = [];
List<FlSpot> data2 = [];
List<FlSpot> data2a = [];
List<FlSpot> data3 = [];

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _auth = FirebaseAuth.instance;
  var loggedInUser;
  var uid; //declare below state

  void getCurrentUser() async {
    // will return the current users uid
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

  getUserData(uid) async {
    // return user data from the patient info collection
    final DocumentSnapshot patientInfo = await patientRef.doc(uid).get();
    setState(() {
      name = patientInfo.get('first name');
    });
  }

  getUploadedData() async {
    // gets averages of each data type for user
    final DocumentSnapshot uploadedData = await patientData.get();
    setState(
      () {
        // if (bg.isNotEmpty) {
        avgGlucose = uploadedData.get('Average Blood Glucose (mmol|L)');
        // }
        // if (sys.isNotEmpty) {
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
    // gets list of 6 most recent HR points to use in Graphs
    data1 = [];
    final hrData = await patientData
        .collection('heartRate')
        .orderBy('uploaded')
        .limitToLast(6)
        .get();
    final value = hrData.docs;
    double index = 1.0;
    for (var val in value) {
      int heartRate = val.get('heart rate');
      data1.add(FlSpot(index++, heartRate.toDouble()));
    }
    return data1;
  }

  Future<List<FlSpot>> getDiasData() async {
    // gets list of 6 most recent BP (diastolic) points to use in Graphs
    data2 = [];
    final bpData = await patientData
        .collection('bloodPressure')
        .orderBy('uploaded')
        .limitToLast(6)
        .get();
    final value = bpData.docs;
    double index = 1.0;
    for (var val in value) {
      double dias = val.get('diastolic');
      data2.add(FlSpot(index++, dias.toDouble()));
    }
    return data2;
  }

  Future<List<FlSpot>> getSysData() async {
    // gets list of 6 most recent BP (systolic) points to use in Graphs
    data2a = [];
    final bpData = await patientData
        .collection('bloodPressure')
        .orderBy('uploaded')
        .limitToLast(6)
        .get();
    final value = bpData.docs;
    double index2 = 1.0;
    for (var val in value) {
      double sys = val.get('systolic');
      data2a.add(FlSpot(index2++, sys.toDouble()));
    }

    return data2a;
  }

  Future<List<FlSpot>> getBGData() async {
    // gets list of 6 most recent BG points to use in Graphs
    data3 = [];
    final bgData = await patientData
        .collection('bloodGlucose')
        .orderBy('uploaded')
        .limitToLast(6) // only the most recent 6 data will be fetched
        .get();
    final value = bgData.docs;
    double index = 1.0;
    for (var val in value) {
      double glucose = val.get('blood glucose (mmol|L)');
      data3.add(FlSpot(index++, glucose.toDouble()));
    }
    return data3;
  }

  @override
  void initState() {
    getCurrentUser();
    getUserData(uid);
    getUploadedData();
    getBGData();
    getSysData();
    getDiasData();
    getHRData();
    super.initState();
  }

  var data;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSecondaryColour,
      drawer: Drawers(),
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              child: Icon(
                Icons.logout,
              ),
              onTap: () async {
                FirebaseAuth.instance.signOut();
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/', (Route<dynamic> route) => false);
              },
            ),
          )
        ],
        title: Text(
          'Hello, $name',
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation
          .centerFloat, // the camera will be in the center
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
            height: 10.0,
          ),
          Padding(
            padding: EdgeInsets.only(left: 10.0),
            child: Text(
              'Recent Analysis',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 40,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
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
                ? extractData2V2()
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
                  ),
          ),
          Container(
            child: data2.isNotEmpty && data2a.isNotEmpty
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      NewLegend(name: 'Systolic', color: Colors.black),
                      SizedBox(width: 10.0),
                      NewLegend(name: 'Diastolic', color: Colors.red),
                    ],
                  )
                : Text(''),
          ),
          Container(
            child: data2.isNotEmpty && data2a.isNotEmpty
                ? SummaryCard(
                    type: 'Average Blood Pressure:',
                    value: '$avgPressureSys/$avgPressureDia mmHg',
                  )
                : Text(''),
          ),
          SizedBox(height: 25.0),
          Text('Blood Glucose',
              style: kGraphTitleTextStyle, textAlign: TextAlign.center),
          Container(
            child: extractData3V2(),
          ),
          SummaryCard(
              value: '$avgGlucose mmol/L', type: 'Average Blood Glucose:'),
          SizedBox(
            height: 25.0,
          ),
          Text(
            'Pulse Rate',
            style: kGraphTitleTextStyle,
            textAlign: TextAlign.center,
          ),
          Container(
            child: extractDataV2(),
          ),
          SummaryCard(value: '$avgHeartRate bpm', type: 'Average Pulse Rate:'),
          // SummaryCard(
          //     value: '${hr.first} bpm', type: "Smallest value in the list : "),
          // SummaryCard(
          //     value: '${hr.last} bpm', type: "Biggest value in the list"),
          SizedBox(
            height: 70.0,
          ),
        ],
      ),
    );
  }

  Widget extractDataV2() {
    return Charts(
      units: 'BPM',
      yStart: 30,
      bool1: true,
      yLength: 200,
      xLength: 6,
      list: data1,
    );
  }

  Widget extractData2V2() {
    return Charts2(
      units: 'mmHg',
      yStart: 30,
      bool1: true,
      yLength: 180,
      xLength: 6,
      list: data2,
      list2: data2a,
    );
  }

  Widget extractData3V2() {
    //blood glucose
    return Charts3(
      units: 'mmol/L',
      yStart: 0,
      bool1: true,
      yLength: 10,
      xLength: 6,
      list: data3,
    );
  }
}

class NewLegend extends StatelessWidget {
  NewLegend({required this.color, required this.name});
  final Color color;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(width: 20, height: 20, color: color),
        SizedBox(width: 5.0),
        Text(
          name,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
