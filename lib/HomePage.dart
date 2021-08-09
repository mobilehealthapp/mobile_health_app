import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_health_app/Graph/ExtractData.dart';
import 'drawers.dart';
import 'package:mobile_health_app/drawers.dart';
import 'package:mobile_health_app/Constants.dart';
import 'package:mobile_health_app/settings_pages/settings_constants.dart';

final patientRef = FirebaseFirestore.instance
    .collection('patientprofile'); //declare reference high up in file
var name;
//declare variable high up in file

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
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          Container(
            // height: 400,
            // width: 400,
            child: ExtractData2V2(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    width: 10,
                    height: 10,
                    color: Colors.black,
                  ),
                  SizedBox(width: 5.0),
                  Text(
                    'Systolic',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              SizedBox(width: 10.0),
              Row(
                children: <Widget>[
                  Container(
                    width: 10,
                    height: 10,
                    color: Colors.red,
                  ),
                  SizedBox(width: 5.0),
                  Text(
                    'Diastolic',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ],
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //   children: <Widget>[
          //     Legend(
          //       text: 'Systolic',
          //       color: Colors.black,
          //     ),
          //     Legend(
          //       text: 'Diastolic',
          //       color: Colors.red,
          //     ),
          //   ],
          // ),

          // Text(
          //   'Blood Sugar for this week',
          //   textAlign: TextAlign.center,
          //   style: TextStyle(fontSize: 20.0),
          // ),
          // Chart2(),
          // SummaryCard(value: '3.4', type: 'Average Blood Sugar'),
          // Text(
          //   'Heart pulse for this week',
          //   textAlign: TextAlign.center,
          //   style: TextStyle(fontSize: 20.0),
          // ),
          // Chart3(),
          // SummaryCard(value: '25', type: 'Average Pulse'),
          Container(
            child: ExtractDataV2(),
          ),
          Container(
            height: 400,
            width: 400,
            child: ExtractData3V2(),
          ),
          // ExtractDataCard()
        ],
      ),
    );
  }
}
