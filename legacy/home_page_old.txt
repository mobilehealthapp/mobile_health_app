import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_health_app/Graphs/graph_info.dart';
import 'package:mobile_health_app/Drawers/drawers.dart';
import 'package:mobile_health_app/constants.dart';
import 'package:mobile_health_app/Graphs/graph_data.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:mobile_health_app/Analysis/health_analysis.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _auth = FirebaseAuth.instance;
  var loggedInUser;
  late final String uid; //declare below state

  String name = ''; // patient's name
  num avgGlucose = 0; // average BG
  num avgPressureDia = 0; // average diastolic BP
  num avgPressureSys = 0; // average systolic BP
  num avgHeartRate = 0; // average HR

  List<FlSpot> systolicList = []; // used for systolic BP in fl_chart
  List<FlSpot> diastolicList = []; // used for diastolic BP in fl_chart
  List<FlSpot> glucoseList = []; // used for BG in fl_chart
  List<FlSpot> heartRateList = []; // used for HR in fl_chart

  var patientMedicalData; // DocumentReference used to access patient's uploaded medical data on Firestore
  var patientProfileRef;  // CollectionReference used to access patient's profile info on Firestore

  var bloodGlucoseCollection;
  var bloodPressureCollection;
  var heartRateCollection;

  @override
  void initState() {
    // initialize functions
    fetchCurrentUser();

    fetchFirebaseReferences();

    fetchUserData();

    fetchBGData();
    fetchSysData();
    fetchDiasData();
    fetchHRData();
    fetchUploadedData();
    super.initState();
  }

  void fetchCurrentUser() {
    ///Initialize loggedInUser and uid(converted to string)
    try {
      final user = _auth.currentUser;
      //TODO: what happens if user is null?
      if (user != null) {
        this.loggedInUser = user;
        print(loggedInUser.email);
        this.uid = user.uid.toString(); //convert to string in this method
      }
    } catch (e) {
      print(e);
    }
  }

  void fetchFirebaseReferences() {
    ///Initialises document and collection references for user.

    this.patientMedicalData = FirebaseFirestore.instance.collection('patientData')
        .doc(FirebaseAuth.instance.currentUser!.uid);

    this.patientProfileRef = FirebaseFirestore.instance.collection('patientprofile');

    this.bloodPressureCollection = patientMedicalData.collection('bloodPressure');
    this.bloodGlucoseCollection = patientMedicalData.collection('bloodGlucose');
    this.heartRateCollection = patientMedicalData.collection('heartRate');

  }

  void fetchUserData() async {
    /// get user's first name from Firestore collection patientprofile to display in AppBar
    final DocumentSnapshot patientInfo = await patientProfileRef.doc(_auth.currentUser!.uid).get();
    setState(() {
      name = patientInfo.get('first name');
    });
  }


  void fetchSysData() async {
    /// gets list of 6 most recent BP (systolic) points to use in Graphs

    systolicList.clear();
    final bpData = await this.bloodPressureCollection
        .orderBy('uploaded') // orders by the field 'uploaded' which is same as ordering from oldest to newest
        .limitToLast(6) // only calls on last 6 docs in collection
        .get();
    final value = bpData.docs; // calls on the docs in the collection
    double xPos = 1.0;
    for (var val in value) {
      double syst = val.get('systolic');
      systolicList.add(FlSpot(xPos++, syst.toDouble()));
    }
  }

  void fetchDiasData() async {
    /// gets list of 6 most recent BP (diastolic) points to use in Graphs
    diastolicList.clear();
    final bpData = await this.bloodPressureCollection
        .orderBy('uploaded') // orders by the field 'uploaded' which is same as ordering from oldest to newest
        .limitToLast(6) // only calls on last 6 docs in collection
        .get();
    final value = bpData.docs; // calls on the docs in the collection
    double xPos = 1.0;
    for (var val in value) {
      double dias = val.get('diastolic');
      diastolicList.add(FlSpot(xPos++, dias.toDouble()));
    }
  }

  void fetchBGData() async {
    /// gets list of 6 most recent BG points to use in Graphs
    glucoseList.clear();
    final bgData = await this.bloodGlucoseCollection
        .orderBy('uploaded') // orders by the field 'uploaded' which is same as ordering from oldest to newest
        .limitToLast(6) // only calls on last 6 docs in collection
        .get();
    final value = bgData.docs; // calls on the docs in the collection
    double xPos = 1.0;
    for (var val in value) {
      double glucose = val.get('blood glucose (mmol|L)');
      glucoseList.add(FlSpot(xPos++, glucose.toDouble()));
    }
  }

  void fetchHRData() async {
    /// gets list of 6 most recent HR points to use in Graphs
    heartRateList.clear();
    final hrData = await heartRateCollection
        .orderBy('uploaded') // orders by the field 'uploaded' which is same as ordering from oldest to newest
        .limitToLast(6) // only calls on last 6 docs in collection
        .get();
    final value = hrData.docs; // calls on the docs in the collection
    double xPos = 1.0;
    for (var val in value) {
      int heartRate = val.get('heart rate');
      heartRateList.add(FlSpot(xPos++, heartRate.toDouble()));
    }
  }

  void fetchUploadedData() async {
    /// gets averages of each data type for user
    final bpData = await bloodPressureCollection
        .orderBy(
        'uploaded') // orders by the field 'uploaded' which is same as ordering from oldest to newest
        .get();
    final bpData1 = bpData.docs;
    final bgData = await bloodGlucoseCollection
        .orderBy(
        'uploaded') // orders by the field 'uploaded' which is same as ordering from oldest to newest
        .get();
    final bgData1 = bgData.docs;
    final hrData = await heartRateCollection
        .orderBy(
        'uploaded') // orders by the field 'uploaded' which is same as ordering from oldest to newest
        .get();
    final hrData1 = hrData.docs;
    final DocumentSnapshot uploadedData = await patientMedicalData.get();
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
            child: systolicList.isNotEmpty // if list is not empty, display the graph and summary card; if empty, display text telling user to input data
                ? extractBP()
                : NoDataCard(
              textBody:
              'No data has been uploaded for Blood Pressure. Please use the Data Input Page if you wish to add any.', // these texts can be changed to whatever is seen as fit! they are just a placeholder
            ),
          ),
          Container(
            child: glucoseList.isNotEmpty // if list is not empty, display the graph and summary card; if empty, display text telling user to input data
                ? extractBG()
                : NoDataCard(
              textBody:
              'No data has been uploaded for Blood Glucose. Please use the Data Input Page if you wish to add any.', // these texts can be changed to whatever is seen as fit! they are just a placeholder
            ),
          ),
          Container(
            child: heartRateList.isNotEmpty // if list is not empty, display the graph and summary card; if empty, display text telling user to input data
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
          dataList: diastolicList,
          secondaryDataList: systolicList,
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

  Widget extractBG() {
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
          dataList: glucoseList,
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

  Widget extractHR() {
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
          dataList: heartRateList,
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
