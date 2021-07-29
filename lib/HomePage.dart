import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_health_app/Camera/data_input_page.dart';
import 'package:mobile_health_app/drawers.dart';
import 'package:mobile_health_app/welcome_authentication_pages/welcome_screen.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:mobile_health_app/graphData.dart';

import 'drawers.dart';

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
      drawer: Drawers(),
      appBar: AppBar(actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            child: Icon(Icons.logout),
            onTap: () async {
              FirebaseAuth.instance.signOut();
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => WelcomeScreen()));
            },
          ),
        )
      ], backgroundColor: Colors.cyan, title: Text('Hello, $name')),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => DataInput()));
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
