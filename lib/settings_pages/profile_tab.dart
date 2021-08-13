import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobile_health_app/Constants.dart';
import 'package:mobile_health_app/settings_pages/settings_constants.dart';
import 'settings_card.dart';
import 'package:firebase_auth/firebase_auth.dart';

final patientRef = FirebaseFirestore.instance
    .collection('patientprofile'); // create this as global variable
var first; // these variables will represent the info in firebase
var last;
var adr;
var age;
var dob;
var wt;
var ht;
var meds;
var conds;
var tele;
var sex;

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _auth = FirebaseAuth.instance;
  var loggedInUser;
  var uid;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    getUserData(_auth.currentUser!.uid);
  }

  void getCurrentUser() async {
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
    final DocumentSnapshot patientInfo =
        await patientRef.doc(_auth.currentUser!.uid).get();
    setState(
      () {
        first = patientInfo.get('first name');
        last = patientInfo.get('last name');
        adr = patientInfo.get('address');
        age = patientInfo.get('age');
        dob = patientInfo.get('dob');
        wt = patientInfo.get('wt');
        ht = patientInfo.get('ht');
        meds = patientInfo.get('meds');
        conds = patientInfo.get('conds');
        tele = patientInfo.get('tele');
        sex = patientInfo.get('sex');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSecondaryColour,
      appBar: AppBar(
        title: Text(
          'My Profile',
          style: kAppBarLabelStyle,
        ),
        centerTitle: true,
        backgroundColor: kPrimaryColour,
      ),
      body: ListView(
        children: [
          ProfileTab(
            editAnswer: 'Name: $first $last',
          ),
          ProfileTab(
            editAnswer: 'Age: $age',
          ),
          ProfileTab(
            editAnswer: 'Date of Birth: $dob',
          ),
          ProfileTab(editAnswer: 'Sex: $sex'),
          ProfileTab(
            editAnswer: 'Height: $ht',
          ),
          ProfileTab(
            editAnswer: 'Weight: $wt',
          ),
          ProfileTab(
            editAnswer: 'Medical Conditions: $conds',
          ),
          ProfileTab(
            editAnswer: 'Medications: $meds',
          ),
          ProfileTab(
            editAnswer: 'Telephone Number: $tele',
          ),
          ProfileTab(
            editAnswer: 'Home Address: $adr',
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: ElevatedButton(
              onPressed: () async {
                await Navigator.pushNamed(
                  context,
                  '/profileEdit',
                ).then(
                  (value) => getUserData(uid),
                );
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
