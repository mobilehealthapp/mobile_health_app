import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile_health_app/Home_Page/logout.dart';

import '/constants.dart';
import '/Analysis/health_analysis.dart';
import '/Graphs/graph_info.dart';
import '/Drawers/drawers.dart';
import '/Graphs/graph_data.dart';
import '/Notification/notifications.dart';
import '/Data/patient_data_functions.dart';

/// This file contains the HomePage widget, which the user should reach either
/// after logging in, or (if already logged in) they'll land here on start.
/// It accesses the database, loads averages and recent data points,
/// and displays that data on graphs.
///

/* <ramble>
 This is the updated/simplified version of this file.
 it's been tested and seems to be working the same.
 While nothing MAJOR was changed, there were some optimizations,
 and restructuring to code.

 Other than that documentation and commenting was added.

 The original is saved under <root>/legacy/old_home_page.txt
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
  late final CollectionReference patientDoctorsCollection;

  //Collection references to the collections within measurement doc
  late final CollectionReference bloodGlucoseCollection;
  late final CollectionReference bloodPressureCollection;
  late final CollectionReference heartRateCollection;

  @override
  void initState() {
    // initialize functions
    super.initState();

    fetchFirebaseReferences();
    generateGreeting();
    fetchCurrentUser();

    listenNotifications();
    firstSession();
    hasDoctor();
  }

  void fetchFirebaseReferences() {
    ///Fetches and initialises document and collection references.
    this.patientMedicalDoc = FirebaseFirestore.instance
        .collection('patientData')
        .doc(FirebaseAuth.instance.currentUser!.uid);

    this.patientProfileCollection =
        FirebaseFirestore.instance.collection('patientprofile');

    this.patientDoctorsCollection = patientProfileCollection
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('patientDoctors');

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

  void listenNotifications() {
    NotificationApi.onNotifications.stream.listen(onClickedNotification);
  }

  void onClickedNotification(String? payload) =>
      Navigator.of(context).pushNamed(
        payload!,
      );

  Future firstSession() async {
    DocumentSnapshot snapshot = await patientProfileCollection.doc(uid).get();
    var session = snapshot.get('First Session');
    if (session != null) {
      //if first session is true show a notification for them to edit their profile
      NotificationApi.showNotification(
          title: 'First Login!',
          body: 'Welcome to MedScan! Click Here to Update Your Profile!',
          payload: "/profileEdit");
      await patientProfileCollection.doc(uid).update({'First Session': null});
      return;
    }
    return;
  }

  Future hasDoctor() async {
    await NotificationApi.init(
        initScheduled: true); //this was originally called in the initState
    QuerySnapshot snapshot = await patientDoctorsCollection.get();
    if (snapshot.size != 0) {
      return;
    } else {
      NotificationApi.showScheduledNotification(
        title: 'Add a Doctor',
        body: 'Click Here to Add your Doctor to your Profile!',
        payload: '/addDoctors',
      );
    }
  }

  void generateGreeting() async {
    /// Add name to AppBar greeting, if it can be found in database
    final DocumentSnapshot patientInfo =
        await this.patientProfileCollection.doc(_auth.currentUser!.uid).get();
    try {
      //if field doesn't exist it throws a StateError
      String? name = patientInfo.get('first name');
      setState(() {
        this.greeting = 'Hello, $name';
      });
    } on StateError {
      setState(() {
        this.greeting = 'Hello';
      });
    }
  }

  Future<void> fetchBPData() async {
    /// gets list of 6 most recent BP (systolic) points to use in Graphs

    this.systolicList.clear(); //Cleared in case function is used to update data
    this.diastolicList.clear();
    var bplist = await Datafunction(uid).getAmount(6, 'bloodPressure');
    //setState(() {});
    double xPos = 1.0;
    num syst;
    num dias;
    String data;
    if (bplist != null) {
      for (int i = 0; i < bplist.length; i++) {
        data = bplist[i];
        avgPressureSys += double.parse(data.split(',')[0]);
        syst = num.parse(data.split(',')[0]);
        avgPressureDia += double.parse(data.split(',')[1]);
        dias = num.parse(data.split(',')[1]);
        systolicList.add(FlSpot(xPos, syst.toDouble()));
        diastolicList.add(FlSpot(xPos, dias.toDouble()));
        ++xPos;
      }
      avgPressureSys = avgPressureSys ~/ bplist.length;
      avgPressureDia = avgPressureDia ~/ bplist.length;
    }
  }

  Future<void> fetchBGData() async {
    /// gets list of 6 most recent BG points to use in Graphs
    this.glucoseList.clear(); //Cleared in case function is used to update data

    var bglist = await Datafunction(uid).getAmount(6, 'bloodGlucose');
    double xPos = 1.0;
    double glucose;
    String data;
    if (bglist != null) {
      for (int i = 0; i < bglist.length; i++) {
        data = bglist[i];
        avgGlucose += double.parse(data.split(',')[1]);
        glucose = double.parse(
            data.split(',')[0]); //get the mmol/L recording of the user
        glucoseList.add(FlSpot(xPos, glucose.toDouble()));
        ++xPos;
      }
      avgGlucose = avgGlucose ~/ bglist.length;
    }
  }

  Future<void> fetchHRData() async {
    /// gets list of 6 most recent HR points to use in Graphs

    this.heartRateList.clear(); //Cleared in case this is used to update data

    var hrlist = await Datafunction(uid).getAmount(6, 'heartRate');
    double xPos = 1.0;
    int heartRate;
    String data;
    if (hrlist != null) {
      for (int i = 0; i < hrlist.length; i++) {
        data = hrlist[i];
        avgHeartRate += int.parse(data.split(',')[0]);
        heartRate =
            int.parse(data.split(',')[0]); //parse the recording from the String
        heartRateList.add(FlSpot(xPos, heartRate.toDouble()));
        ++xPos;
      }
      avgHeartRate = avgHeartRate ~/ hrlist.length;
    }
  }

  Container graphFutureBuilder(
      {required Function future, required Function uponCompletion}) {
    return Container(
        child: FutureBuilder<void>(
            future: future(),
            builder: (
              BuildContext context,
              AsyncSnapshot<void> snapshot,
            ) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else {
                return uponCompletion();
              }
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSecondaryColour,
      drawer: Drawers(),
      appBar: AppBar(
        actions: [
          LogoutButton(),
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
          graphFutureBuilder(future: fetchBPData, uponCompletion: extractBP),
          graphFutureBuilder(future: fetchBGData, uponCompletion: extractBG),
          graphFutureBuilder(future: fetchHRData, uponCompletion: extractHR),
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
        HealthCharts(
          graphType: HealthCharts.BP,
          unitOfMeasurement: 'mmHg',
          minY: 30,
          showDots: true,
          maxY: 180,
          maxX: 6,
          primaryDataList: diastolicList,
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
        HealthCharts(
          graphType: HealthCharts.BG,
          unitOfMeasurement: 'mmol/L',
          minY: 0,
          showDots: true,
          maxY: 10,
          maxX: 6,
          primaryDataList: glucoseList,
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
        HealthCharts(
          graphType: HealthCharts.HR,
          unitOfMeasurement: 'BPM',
          minY: 30,
          showDots: true,
          maxY: 200,
          maxX: 6,
          primaryDataList: heartRateList,
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
