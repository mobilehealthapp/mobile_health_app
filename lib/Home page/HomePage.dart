import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Drawers/drawers.dart';
import 'package:mobile_health_app/Drawers/drawers.dart';
import 'package:mobile_health_app/Constants.dart';
import 'package:mobile_health_app/Home%20page/graphData.dart';

final patientRef = FirebaseFirestore.instance
    .collection('patientprofile'); //declare reference high up in file
var name; //declare variable high up in file

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

  @override
  void initState() {
    getCurrentUser();
    getUserData(uid);
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
        title: Text('Hello, $name'),
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
        children: [
          SizedBox(
            height: 30.0,
          ),
          Text(
            ' Recent Analysis',
            style: TextStyle(
              fontSize: 40,
            ),
          ),
          SizedBox(
            height: 30.0,
          ),
          Text(
            'Blood pressure for this week',
            textAlign: TextAlign.center,
          ),
          Chart1(),
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
            type: 'Average Blood Pressure',
            value: '145/89 ',
          ),
          Chart2(),
          SummaryCard(value: '3.4', type: 'Average Blood Sugar'),
          Chart3(),
          SummaryCard(value: '25', type: 'Average Pulse'),
        ],
      ),
    );
  }
}

//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:mobile_health_app/settings_pages/graph_info.dart';
// import 'package:mobile_health_app/Drawers/drawers.dart';
// import 'package:mobile_health_app/Constants.dart';
// import 'package:mobile_health_app/settings_pages/settings_constants.dart';
// import 'package:mobile_health_app/graphData.dart';
// import 'package:fl_chart/fl_chart.dart';
//
// final patientData = FirebaseFirestore.instance
//     .collection('patientData')
//     .doc(FirebaseAuth.instance.currentUser!.uid);
// final patientRef = FirebaseFirestore.instance
//     .collection('patientprofile'); //declare reference high up in file
// var name; //declare variable high up in file
// var avgGlucose;
// var avgPressureDia;
// var avgPressureSys;
// var avgHeartRate;
//
// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);
//
//   @override
//   _HomePageState createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   final _auth = FirebaseAuth.instance;
//   var loggedInUser;
//   var uid; //declare below state
//
//   void getCurrentUser() async {
//     try {
//       final user = _auth.currentUser;
//       if (user != null) {
//         loggedInUser = user;
//         print(loggedInUser.email);
//         uid = user.uid.toString(); //convert to string in this method
//       }
//     } catch (e) {
//       print(e);
//     }
//   }
//
//   getUserData(uid) async {
//     final DocumentSnapshot patientInfo = await patientRef.doc(uid).get();
//     setState(() {
//       name = patientInfo.get('first name');
//     });
//   }
//
//   getUploadedData() async {
//     final DocumentSnapshot uploadedData = await FirebaseFirestore.instance
//         .collection('patientData')
//         .doc(_auth.currentUser!.uid)
//         .get();
//     setState(
//       () {
//         avgGlucose = uploadedData.get('Average Blood Glucose (mmol|L)');
//         avgPressureDia = uploadedData.get('Average Blood Pressure (diastolic)');
//         avgPressureSys = uploadedData.get('Average Blood Pressure (systolic)');
//         avgHeartRate = uploadedData.get('Average Heart Rate');
//       },
//     );
//   }
//
//   @override
//   void initState() {
//     getCurrentUser();
//     getUserData(uid);
//     getUploadedData();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: kSecondaryColour,
//       drawer: Drawers(),
//       appBar: AppBar(
//         iconTheme: IconThemeData(
//           color: Colors.white,
//         ),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: GestureDetector(
//               child: Icon(
//                 Icons.logout,
//               ),
//               onTap: () async {
//                 FirebaseAuth.instance.signOut();
//                 Navigator.of(context).pushNamedAndRemoveUntil(
//                     '/', (Route<dynamic> route) => false);
//               },
//             ),
//           )
//         ],
//         backgroundColor: kPrimaryColour,
//         title: Text(
//           'Hello, $name',
//           style: kAppBarLabelStyle,
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Colors.grey[600],
//         onPressed: () {
//           Navigator.of(context).pushNamed('/dataInput');
//         },
//         child: Icon(
//           Icons.camera_alt_rounded,
//         ),
//       ),
//       body: ListView(
//         shrinkWrap: true,
//         children: [
//           SizedBox(
//             height: 10.0,
//           ),
//           Padding(
//             padding: EdgeInsets.only(left: 10.0),
//             child: Text(
//               'Recent Analysis',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 40,
//                 decoration: TextDecoration.underline,
//               ),
//             ),
//           ),
//           SizedBox(
//             height: 30.0,
//           ),
//           Text(
//             'Blood Pressure',
//             style: TextStyle(
//               color: Colors.black,
//               fontWeight: FontWeight.bold,
//               fontSize: 17.0,
//             ),
//             textAlign: TextAlign.center,
//           ),
//           Container(
//             child: ExtractData2V2(),
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: <Widget>[
//               Legend(
//                 text: 'Systolic',
//                 color: Colors.black,
//               ),
//               Legend(
//                 text: 'Diastolic',
//                 color: Colors.red,
//               ),
//             ],
//           ),
//           SummaryCard(
//             type: 'Average Blood Pressure:',
//             value: '$avgPressureSys/$avgPressureDia mmHg',
//           ),
//           SizedBox(
//             height: 25.0,
//           ),
//           Text(
//             'Blood Glucose',
//             style: TextStyle(
//               color: Colors.black,
//               fontWeight: FontWeight.bold,
//               fontSize: 17.0,
//             ),
//             textAlign: TextAlign.center,
//           ),
//           Container(
//             child: ExtractData3V2(),
//           ),
//           SummaryCard(
//               value: '$avgGlucose mmol/L', type: 'Average Blood Glucose:'),
//           SizedBox(
//             height: 25.0,
//           ),
//           Text(
//             'Pulse Rate',
//             style: TextStyle(
//               color: Colors.black,
//               fontWeight: FontWeight.bold,
//               fontSize: 17.0,
//             ),
//             textAlign: TextAlign.center,
//           ),
//           Container(
//             child: ExtractDataV2(),
//           ),
//           SummaryCard(value: '$avgHeartRate bpm', type: 'Average Pulse Rate:'),
//           SizedBox(
//             height: 70.0,
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class ExtractDataV2 extends StatefulWidget {
//   const ExtractDataV2({Key? key}) : super(key: key);
//
//   @override
//   _ExtractDataV2State createState() => _ExtractDataV2State();
// }
//
// class _ExtractDataV2State extends State<ExtractDataV2> {
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance
//           .collection('patientData')
//           .doc(FirebaseAuth.instance.currentUser!.uid)
//           .collection('heartRate')
//           .orderBy('uploaded')
//           .limitToLast(6)
//           .snapshots(),
//       builder: (context, snapshot) {
//         final value = snapshot.data!.docs;
//         final List<FlSpot> data1 = [];
//         double index = 1.0;
//         for (var val in value) {
//           int heartrate = val.get('heart rate');
//           data1.add(FlSpot(index++, heartrate.toDouble()));
//         }
//         return Charts(
//           yStart: 30,
//           bool1: true,
//           yLength: 200,
//           xLength: 6,
//           list: data1,
//         );
//       },
//     );
//   }
// }
//
// class ExtractData2V2 extends StatefulWidget {
//   const ExtractData2V2({Key? key}) : super(key: key);
//
//   @override
//   _ExtractData2V2State createState() => _ExtractData2V2State();
// }
//
// class _ExtractData2V2State extends State<ExtractData2V2> {
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance
//           .collection('patientData')
//           .doc(FirebaseAuth.instance.currentUser!.uid)
//           .collection('bloodPressure')
//           .orderBy('uploaded')
//           .limitToLast(6)
//           .snapshots(),
//       builder: (context, snapshot) {
//         final value = snapshot.data!.docs;
//         final List<FlSpot> data2 = [];
//         final List<FlSpot> data3 = [];
//         double index = 1;
//         double index2 = 1;
//
//         for (var val in value) {
//           double dias = val.get('diastolic');
//           double sys = val.get('systolic');
//
//           data2.add(FlSpot(index++, dias.toDouble()));
//           data3.add(FlSpot(index2++, sys.toDouble()));
//         }
//         return Charts2(
//             yStart: 10,
//             bool1: true,
//             yLength: 180,
//             xLength: 6,
//             list: data2,
//             list2: data3);
//       },
//     );
//   }
// }
//
// class ExtractData3V2 extends StatefulWidget {
//   const ExtractData3V2({Key? key}) : super(key: key);
//
//   @override
//   _ExtractData3V2State createState() => _ExtractData3V2State();
// }
//
// class _ExtractData3V2State extends State<ExtractData3V2> {
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance
//           .collection('patientData')
//           .doc(FirebaseAuth.instance.currentUser!.uid)
//           .collection('bloodGlucose')
//           .orderBy('uploaded')
//           .limitToLast(2)
//           .snapshots(),
//       builder: (context, snapshot) {
//         final value = snapshot.data!.docs;
//         final List<FlSpot> data1 = [];
//         double index = 1.0;
//
//         for (var val in value) {
//           double glucose = val.get('blood glucose (mmol|L)');
//           data1.add(FlSpot(index++, glucose.toDouble()));
//         }
//         return Charts(
//           yStart: 0,
//           bool1: true,
//           yLength: 10,
//           xLength: 6,
//           list: data1,
//         );
//       },
//     );
//   }
// }
