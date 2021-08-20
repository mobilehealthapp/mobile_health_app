import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_health_app/Constants.dart';
import 'package:mobile_health_app/Settings/settings_constants.dart';
import 'settings_classes.dart';

final patientRef = FirebaseFirestore.instance.collection(
    'patientprofile'); // CollectionReference used to access patient's profile data on Firestore
var first; // first name
var last; // last name
var province; //province or territory
var adr; // home address
var age; // age
var dob; // date of birth
var wt; // weight
var ht; // height
var meds; // medications that the patient is on
var conds; // medical conditions that the patient has
var tele; // telephone number
var sex; // sex of patient

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
    // initialize functions
    super.initState();
    getCurrentUser();
    getUserData(_auth.currentUser!.uid);
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
    // retrieve patient's data from Firestore
    final DocumentSnapshot patientInfo =
        await patientRef.doc(_auth.currentUser!.uid).get();
    setState(
      // changes the values of the variables previously declared at top of file
      () {
        first = patientInfo.get(
            'first name'); // must call on exact field name to get correct data from Firestore
        last = patientInfo.get(
            'last name'); // if there is a typo, the correct field won't be called
        province = patientInfo.get('province');
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
        title: Text('My Profile'),
      ),
      body: ListView(
        children: [
          // displays all of user's profile information on tabs in a ListView
          ProfileTab(
            editAnswer:
                'Name: $first $last', // using $ in a string allows you to access a specific variable's value
          ),
          ProfileTab(
            editAnswer: 'Age: $age',
          ),
          ProfileTab(
            editAnswer: 'Date of Birth: $dob',
          ),
          ProfileTab(
            editAnswer: 'Province/Territory: $province',
          ),
          ProfileTab(
            editAnswer: 'Sex: $sex',
          ),
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
                  /*
                  calling on the getUserData() function after navigator.then will return the proper values
                  on the profile edit text fields
                   */
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
