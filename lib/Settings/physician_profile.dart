import 'package:flutter/material.dart';
import 'package:mobile_health_app/constants.dart';
import 'package:mobile_health_app/Settings/settings_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'settings_classes.dart';

final doctorRef = FirebaseFirestore.instance.collection(
    'doctorprofile'); // CollectionReference used to access doctor's profile data on Firestore

var clinicAdr; // clinic address
var doctorCode; // unique access code assigned to doctor when they sign up for app
var drFirst; // first name
var drLast; // last name
var drTele; // telephone number (clinic)
var fax; // fax number (clinic)
var province; // province or territory
var quali; // qualifications

class DrProfilePage extends StatefulWidget {
  const DrProfilePage({Key? key}) : super(key: key);

  @override
  _DrProfilePageState createState() => _DrProfilePageState();
}

class _DrProfilePageState extends State<DrProfilePage> {
  final _auth = FirebaseAuth.instance;
  var loggedInUser;
  var uid;

  @override
  void initState() {
    // initialize functions
    super.initState();
    getCurrentUser();
    getUserData(uid);
  }

  void getCurrentUser() async {
    // find uid
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
        uid = user.uid.toString(); //convert uid to String
      }
    } catch (e) {
      print(e);
    }
  }

  getUserData(uid) async {
    // retrieve doctor's data from Firestore
    final DocumentSnapshot doctorInfo = await doctorRef.doc(uid).get();
    setState(
      () {
        clinicAdr = doctorInfo.get('clinicAddress');
        doctorCode = doctorInfo.get('access code');
        drFirst = doctorInfo.get('first name');
        drLast = doctorInfo.get('last name');
        drTele = doctorInfo.get('tele');
        fax = doctorInfo.get('fax');
        province = doctorInfo.get('province');
        quali = doctorInfo.get('quali');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSecondaryColour,
      appBar: AppBar(
        title: Text('My Profile'),
      ),
      body: ListView(
        children: <Widget>[
          // displays all of doctor's profile information on tabs in a ListView
          ProfileTab(
            editAnswer: 'Name: $drFirst $drLast',
          ),
          ProfileTab(
            editAnswer: 'Qualifications: $quali',
          ),
          ProfileTab(
            editAnswer: 'Province/Territory: $province',
          ),
          ProfileTab(
            editAnswer: 'Doctor ID: $doctorCode',
          ),
          ProfileTab(
            editAnswer: 'Telephone Number: $drTele',
          ),
          ProfileTab(
            editAnswer: 'Fax: $fax',
          ),
          ProfileTab(
            editAnswer: 'Clinic Address: $clinicAdr',
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: ElevatedButton(
              onPressed: () async {
                await Navigator.pushNamed(
                  context,
                  '/drProfileEdit',
                ).then(
                  (value) => getUserData(uid),
                );
                // takes user to page where they can edit their profile info
              },
              child: TabContent(label: 'Edit My Information'),
              style: kSettingsCardStyle,
            ),
          ),
        ],
      ),
    );
  }
}
