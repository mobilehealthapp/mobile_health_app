import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_health_app/graphs/graph_info.dart';
import 'package:mobile_health_app/Drawers/drawers.dart';
import 'package:mobile_health_app/Constants.dart';
import 'package:mobile_health_app/graphs/graphData.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:mobile_health_app/Analysis/health_analysis.dart';

final patientData = FirebaseFirestore.instance.collection('patientData').doc(
    FirebaseAuth.instance.currentUser!
        .uid); // DocumentReference used to access patient's uploaded medical data on Firestore
final patientRef = FirebaseFirestore.instance.collection(
    'patientprofile'); // CollectionReference used to access patient's profile data on Firestore
var name; //declare variable high up in file
var avgGlucose;
var avgPressureDia;
var avgPressureSys;
var avgHeartRate;

List<FlSpot> data1 = []; // used for systolic BP in fl_chart
List<FlSpot> data1a = []; // used for diastolic BP in fl_chart
List<FlSpot> data2 = []; // used for BG in fl_chart
List<FlSpot> data3 = []; // used for HR in fl_chart

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
    // gets list of 6 most recent BP (systolic) points to use in Graphs
    data1 = [];
    final bpData = await patientData
        .collection('bloodPressure')
        .orderBy('uploaded')
        .limitToLast(6)
        .get();
    final value = bpData.docs;
    double index2 = 1.0;
    for (var val in value) {
      double sys = val.get('systolic');
      data1.add(FlSpot(index2++, sys.toDouble()));
    }

    return data1;
  }

  Future<List<FlSpot>> getDiasData() async {
    // gets list of 6 most recent BP (diastolic) points to use in Graphs
    data1a = [];
    final bpData = await patientData
        .collection('bloodPressure')
        .orderBy('uploaded')
        .limitToLast(6)
        .get();
    final value = bpData.docs;
    double index = 1.0;
    for (var val in value) {
      double dias = val.get('diastolic');
      data1a.add(FlSpot(index++, dias.toDouble()));
    }
    return data1a;
  }

  Future<List<FlSpot>> getBGData() async {
    // gets list of 6 most recent BG points to use in Graphs
    data2 = [];
    final bgData = await patientData
        .collection('bloodGlucose')
        .orderBy('uploaded')
        .limitToLast(4)
        .get();
    final value = bgData.docs;
    double index = 1.0;
    for (var val in value) {
      double glucose = val.get('blood glucose (mmol|L)');
      data2.add(FlSpot(index++, glucose.toDouble()));
    }
    return data2;
  }

  Future<List<FlSpot>> getHRData() async {
    // gets list of 6 most recent HR points to use in Graphs
    data3 = [];
    final hrData = await patientData
        .collection('heartRate')
        .orderBy('uploaded')
        .limitToLast(6)
        .get();
    final value = hrData.docs;
    double index = 1.0;
    for (var val in value) {
      int heartRate = val.get('heart rate');
      data3.add(FlSpot(index++, heartRate.toDouble()));
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
            height: 20.0,
          ),
          Container(
            child: data1.isNotEmpty
                ? extractDataV2()
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
                ? extractData2V2()
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
                ? extractData3V2()
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

  Widget extractDataV2() {
    return Column(
      children: [
        Text(
          'Blood Pressure',
          style: kGraphTitleTextStyle,
          textAlign: TextAlign.center,
        ),
        Charts2(
          units: 'mmHg',
          yStart: 30,
          bool1: true,
          yLength: 180,
          xLength: 6,
          list: data1a,
          list2: data1,
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
      ],
    );
  }

  Widget extractData2V2() {
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
          bool1: true,
          yLength: 10,
          xLength: 6,
          list: data2,
        ),
        SummaryCard(
          value: '$avgGlucose mmol/L',
          type: 'Average Blood Glucose:',
        ),
        SizedBox(
          height: 25.0,
        ),
      ],
    );
  }

  Widget extractData3V2() {
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
          bool1: true,
          yLength: 200,
          xLength: 6,
          list: data3,
        ),
        SummaryCard(
          value: '$avgHeartRate bpm',
          type: 'Average Pulse Rate:',
        ),
        SizedBox(
          height: 25.0,
        ),
      ],
    );
  }
}
