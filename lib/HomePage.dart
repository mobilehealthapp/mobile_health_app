import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_health_app/settings_pages/graph_info.dart';
import 'drawers.dart';
import 'package:mobile_health_app/drawers.dart';
import 'package:mobile_health_app/Constants.dart';
import 'package:mobile_health_app/settings_pages/settings_constants.dart';
import 'package:mobile_health_app/graphData.dart';
import 'package:fl_chart/fl_chart.dart';

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
final List<FlSpot> data1 = [];
final List<FlSpot> data2 = [];
final List<FlSpot> data2a = [];
final List<FlSpot> data3 = [];

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
    final DocumentSnapshot patientInfo = await patientRef.doc(uid).get();
    setState(() {
      name = patientInfo.get('first name');
    });
  }

  getUploadedData() async {
    final DocumentSnapshot uploadedData = await FirebaseFirestore.instance
        .collection('patientData')
        .doc(_auth.currentUser!.uid)
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

  Future<List<FlSpot>> getBPData() async {
    final bpData = await patientData
        .collection('bloodPressure')
        .orderBy('uploaded')
        .limitToLast(6)
        .get();
    final value = bpData.docs;
    double index = 1;
    double index2 = 1;
    for (var val in value) {
      double dias = val.get('diastolic');
      double sys = val.get('systolic');

      data2.add(FlSpot(index++, dias.toDouble()));
      data2a.add(FlSpot(index2++, sys.toDouble()));
    }
    return data2;
  }

  Future<List<FlSpot>> getBGData() async {
    final bgData = await patientData
        .collection('bloodGlucose')
        .orderBy('uploaded')
        .limitToLast(4)
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
    getBPData();
    getHRData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSecondaryColour,
      drawer: Drawers(),
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
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
        backgroundColor: kPrimaryColour,
        title: Text(
          'Hello, $name',
          style: kAppBarLabelStyle,
        ),
      ),
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
          Text(
            'Blood Pressure',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 17.0,
            ),
            textAlign: TextAlign.center,
          ),
          Container(
            child: extractData2V2(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Legend(
                text: 'Systolic',
                color: Colors.black,
              ),
              Legend(
                text: 'Diastolic',
                color: Colors.red,
              ),
            ],
          ),
          SummaryCard(
            type: 'Average Blood Pressure:',
            value: '$avgPressureSys/$avgPressureDia mmHg',
          ),
          SizedBox(
            height: 25.0,
          ),
          Text(
            'Blood Glucose',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 17.0,
            ),
            textAlign: TextAlign.center,
          ),
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
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 17.0,
            ),
            textAlign: TextAlign.center,
          ),
          Container(
            child: extractDataV2(),
          ),
          SummaryCard(value: '$avgHeartRate bpm', type: 'Average Pulse Rate:'),
          SizedBox(
            height: 70.0,
          ),
        ],
      ),
    );
  }
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
    yStart: 10,
    bool1: true,
    yLength: 180,
    xLength: 6,
    list: data2,
    list2: data2a,
  );
}

Widget extractData3V2() {
  return Charts(
    units: 'mmol/L',
    yStart: 0,
    bool1: true,
    yLength: 10,
    xLength: 6,
    list: data3,
  );
}
