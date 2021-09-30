import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '/constants.dart';
import '/Analysis/health_analysis.dart';
import '/Graphs/graph_info.dart';
import '/Drawers/drawers.dart';
import '/Graphs/graph_data.dart';

/// This file contains the HomePage widget, which the user should reach either
/// after logging in, or (if already logged in) they'll land here on start.
/// It accesses the database, loads averages and recent data points,
/// and displays that data on graphs.
///

/* <ramble>
 This is the updated/simplified version of this file.
 it's been tested and seems to be working the same.
 While nothing MAJOUR was changed, there were some optimizations,
 and restructuring to code.

 Other than that documentation and commenting was added.

 The original is saved under <root>/legacy/old_home_page.dart
 </ramble>
*/

// TODO:Find a way to test for fields existence that isn't a try/on StateError block
// ctrl+F -> StateError

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _auth = FirebaseAuth.instance;
  late final User loggedInUser;
  late final String uid; //It's a string, as it acts as the database key

  String greeting = 'Hello'; // Message for top of app bar(check for name later)
  num avgGlucose = 0;
  num avgPressureDia = 0;
  num avgPressureSys = 0;
  num avgHeartRate = 0;

  List<FlSpot> systolicList = [];
  List<FlSpot> diastolicList = [];
  List<FlSpot> glucoseList = [];
  List<FlSpot> heartRateList = [];

  // DocumentReference used to access the uploaded measurements on Firestore
  late final DocumentReference patientMedicalDoc;

  // CollectionReference used to access patient's profile info on Firestore
  late final CollectionReference patientProfileCollection;

  //Collection references to the collections within measurement doc
  late final CollectionReference bloodGlucoseCollection;
  late final CollectionReference bloodPressureCollection;
  late final CollectionReference heartRateCollection;

  @override
  void initState() {
    // initialize functions
    fetchFirebaseReferences();

    generateGreeting();
    fetchCurrentUser();

    fetchBGData();
    fetchBPData();
    fetchHRData();
    fetchUploadedData();
    super.initState();
  }

  void fetchFirebaseReferences() {
    ///Fetches and initialises document and collection references.
    this.patientMedicalDoc = FirebaseFirestore.instance
        .collection('patientData')
        .doc(FirebaseAuth.instance.currentUser!.uid);

    this.patientProfileCollection =
        FirebaseFirestore.instance.collection('patientprofile');

    this.bloodPressureCollection =
        patientMedicalDoc.collection('bloodPressure');

    this.bloodGlucoseCollection = patientMedicalDoc.collection('bloodGlucose');

    this.heartRateCollection = patientMedicalDoc.collection('heartRate');
  }

  void fetchCurrentUser() {
    ///Initialize loggedInUser and string of uid
    try {
      final user = _auth.currentUser;
      //TODO: what happens if user is null?
      if (user != null) {
        this.loggedInUser = user;
        this.uid = user.uid.toString();
      }
    } catch (e) {
      print(e);
    }
  }

  void generateGreeting() async {
    /// Add name to AppBar greeting, if it can be found in database
    final DocumentSnapshot patientInfo =
    await this.patientProfileCollection.doc(_auth.currentUser!.uid).get();
    try { //if field doesn't exist it throws a StateError
      String? name = patientInfo.get('first name');
      setState(() {
        this.greeting = 'Hello, $name';
      }
      );
    } on StateError {
      setState(() {
        this.greeting = 'Hello';
      }
      );
    }
  }

  void fetchBPData() async {
    /// gets list of 6 most recent BP (systolic) points to use in Graphs

    this.systolicList.clear(); //Cleared in case function is used to update data
    this.diastolicList.clear();

    final bpData = await this
        .bloodPressureCollection
        .orderBy('uploaded') // i.e. oldest to newest
        .limitToLast(6) // Calls last 6 uploaded docs
        .get();
    final value = bpData.docs; // calls on the docs in the collection
    double xPos = 1.0;
    double syst;
    double dias;
    for (var val in value) {
      try { //if field doesn't exist it throws a StateError
        syst = await val.get('systolic');
        dias = await val.get('diastolic');
      } on StateError {
        break;
      }
      systolicList.add(FlSpot(xPos, syst.toDouble()));
      diastolicList.add(FlSpot(xPos, dias.toDouble()));
      ++xPos;
    }
  }

  void fetchBGData() async {
    /// gets list of 6 most recent BG points to use in Graphs
    this.glucoseList.clear(); //Cleared in case function is used to update data

    final bgData = await this
        .bloodGlucoseCollection
        .orderBy('uploaded') // i.e. oldest to newest
        .limitToLast(6) // Calls last 6 uploaded docs
        .get();
    final value = bgData.docs; // calls on the docs in the collection
    double xPos = 1.0;
    double glucose;
    for (var val in value) {
      try { //if field doesn't exist it throws a StateError
        glucose = await val.get('blood glucose (mmol|L)');
      } on StateError {
        break;
      }
      glucoseList.add(FlSpot(xPos++, glucose.toDouble()));
    }
  }

  void fetchHRData() async {
    /// gets list of 6 most recent HR points to use in Graphs

    this.heartRateList.clear(); //Cleared in case this is used to update data

    final hrData = await this
        .heartRateCollection
        .orderBy('uploaded') // i.e. oldest to newest
        .limitToLast(6) // Calls last 6 uploaded docs
        .get();
    final value = hrData.docs; // calls on the docs in the collection
    double xPos = 1.0;
    int heartRate;
    for (var val in value) {
      try { //if field doesn't exist it throws a StateError
        heartRate = await val.get('heart rate');
      } on StateError {
        break;
      }
      heartRateList.add(FlSpot(xPos++, heartRate.toDouble()));
    }
  }

  void fetchUploadedData() async {
    /// gets averages of each data type for user
    final DocumentSnapshot uploadedData = await this.patientMedicalDoc.get();

    //If doc doesn't have the entry, it'll throw a StateError
    try {
      avgPressureSys = await uploadedData.get('Average Blood Pressure (systolic)');
    } on StateError {
      avgPressureSys = 0;
    }
    try {
      avgPressureDia = await uploadedData.get('Average Blood Pressure (diastolic)');
    } on StateError {
      avgPressureDia = 0;
    }
    try {
      avgGlucose = await uploadedData.get('Average Blood Glucose (mmol|L)');
    } on StateError {
      avgGlucose = 0;
    }
    try {
      avgHeartRate = await uploadedData.get('Average Heart Rate');
    } on StateError {
      avgHeartRate = 0;
    }
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
        title: Text(this.greeting),
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
          Container(child: extractBP()),
          Container(child: extractBG()),
          Container(child: extractHR()),
          SizedBox(
            height: 70.0,
          ),
        ],
      ),
    );
  }

  // Note to future coders:
  // I hate with a passion I'm leaving 3 copy-and-paste functions.
  // with just a few different parameters. I just want you to know that.
  // To save you from scrolling up and down, looking for differences...
  // the differences are: the mentioning of their specific data/it's unit;
  // yStart; yLength; unitOfMeasurement; and the fact BP has an extra data list.

  Widget extractBP() {
    if (this.systolicList.isEmpty) {
      return NoDataCard(
        textBody:
        'No data has been uploaded for Blood Pressure. Please use the Data Input Page if you wish to add any.', // these texts can be changed to whatever is seen as fit! they are just a placeholder
      );
    }
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
    if (this.glucoseList.isEmpty) {
      return NoDataCard(
        textBody:
        'No data has been uploaded for Blood Glucose. Please use the Data Input Page if you wish to add any.', // these texts can be changed to whatever is seen as fit! they are just a placeholder
      );
    }
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
    if (this.heartRateList.isEmpty) {
      return NoDataCard(
        textBody:
        'No data has been uploaded for Heart Rate. Please use the Data Input Page if you wish to add any.', // these texts can be changed to whatever is seen as fit! they are just a placeholder
      );
    }
    return Column(
      children: [
        Text(
          'Heart Rate',
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
