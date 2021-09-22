import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_health_app/Graphs/graph_info.dart';
import 'package:mobile_health_app/Drawers/drawers.dart';
import 'package:mobile_health_app/Constants.dart';
import 'package:mobile_health_app/Graphs/graph_data.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:mobile_health_app/Analysis/health_analysis.dart';

// TODO: Make sure data refreshes when new user signs in and displays their data, NOT previous user's

final patientData = FirebaseFirestore.instance.collection('patientData').doc(
    FirebaseAuth.instance.currentUser!
        .uid); // DocumentReference used to access patient's uploaded medical data on Firestore
final patientRef = FirebaseFirestore.instance.collection(
    'patientprofile'); // CollectionReference used to access patient's profile data on Firestore
var bloodGlucose = patientData.collection(
    'bloodGlucose'); // CollectionReference used to access patient's BG data
var bloodPressure = patientData.collection(
    'bloodPressure'); // CollectionReference used to access patient's BP data
var heartRate = patientData.collection(
    'heartRate'); // CollectionReference used to access patient's HR data

var name; // patient's name
var avgGlucose; // average BG
var avgPressureDia; // average diastolic BP
var avgPressureSys; // average systolic BP
var avgHeartRate; // average HR

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
    // get user's first name from Firestore collection patientprofile to display in AppBar
    final DocumentSnapshot patientInfo = await patientRef.doc(uid).get();
    setState(() {
      name = patientInfo.get('first name');
    });
  }

  Future<List<FlSpot>> getSysData() async {
    // gets list of 6 most recent BP (systolic) points to use in Graphs
    data1 = [];
    final bpData = await patientData
        .collection('bloodPressure')
        .orderBy('uploaded') // orders by the field 'uploaded' which is same as ordering from oldest to newest
        .limitToLast(6) // only calls on last 6 docs in collection
        .get();
    final value = bpData.docs; // calls on the docs in the collection
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
    final bpData = await bloodPressure
        .orderBy(
            'uploaded') // orders by the field 'uploaded' which is same as ordering from oldest to newest
        .limitToLast(6) // only calls on last 6 docs in collection
        .get();
    final value = bpData.docs; // calls on the docs in the collection
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
    final bgData = await bloodGlucose
        .orderBy(
            'uploaded') // orders by the field 'uploaded' which is same as ordering from oldest to newest
        .limitToLast(6) // only calls on last 6 docs in collection
        .get();
    final value = bgData.docs; // calls on the docs in the collection
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
    final hrData = await heartRate
        .orderBy(
            'uploaded') // orders by the field 'uploaded' which is same as ordering from oldest to newest
        .limitToLast(6) // only calls on last 6 docs in collection
        .get();
    final value = hrData.docs; // calls on the docs in the collection
    double index = 1.0;
    for (var val in value) {
      int heartRate = val.get('heart rate');
      data3.add(FlSpot(index++, heartRate.toDouble()));
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
    getCurrentUser();
    getUserData(uid);
    getBGData();
    getSysData();
    getDiasData();
    getHRData();
    getUploadedData();
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
        title: name != ''
            ? Text(
                // if name is not empty, display user's name
                'Hello, $name',
              )
            : Text(
                // if name is empty, remove comma to only display 'Hello'
                'Hello',
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
                fontSize: 40.0,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Container(
            child: data1.isNotEmpty // if list is not empty, display the graph and summary card; if empty, display text telling user to input data
                ? extractDataV2()
                : NoDataCard(
                    textBody:
                        'No data has been uploaded for Blood Pressure. Please use the Data Input Page if you wish to add any.', // these texts can be changed to whatever is seen as fit! they are just a placeholder
                  ),
          ),
          Container(
            child: data2.isNotEmpty // if list is not empty, display the graph and summary card; if empty, display text telling user to input data
                ? extractData2V2()
                : NoDataCard(
                    textBody:
                        'No data has been uploaded for Blood Glucose. Please use the Data Input Page if you wish to add any.', // these texts can be changed to whatever is seen as fit! they are just a placeholder
                  ),
          ),
          Container(
            child: data3.isNotEmpty // if list is not empty, display the graph and summary card; if empty, display text telling user to input data
                ? extractData3V2()
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

  Widget extractDataV2() {
    return Column(
      children: [
        Text(
          'Blood Pressure',
          style: kGraphTitleTextStyle,
          textAlign: TextAlign.center,
        ),
        BPCharts(
          unitOfMeasurement: 'mmHg',
          yStart: 30,
          showDots: true,
          yLength: 180,
          xLength: 6,
          dataList: data1a,
          list2: data1,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            NewLegend(name: 'Systolic', color: Colors.black),
            NewLegend(name: 'Diastolic', color: Colors.red),
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
        BGCharts(
          unitOfMeasurement: 'mmol/L',
          yStart: 0,
          showDots: true,
          yLength: 10,
          xLength: 6,
          dataList: data2,
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
        HRCharts(
          unitOfMeasurement: 'BPM',
          yStart: 30,
          showDots: true,
          yLength: 200,
          xLength: 6,
          dataList: data3,
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
