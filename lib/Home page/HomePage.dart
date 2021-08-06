import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Drawers/drawers.dart';
import 'package:mobile_health_app/Drawers/drawers.dart';
import 'package:mobile_health_app/Constants.dart';
import 'package:mobile_health_app/settings_pages/settings_constants.dart';
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
