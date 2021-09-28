import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_health_app/constants.dart';
import 'package:mobile_health_app/Settings/settings_constants.dart';
import 'package:mobile_health_app/Authentication/database_auth_services.dart';

final patientRef = FirebaseFirestore.instance.collection(
    'patientprofile'); // CollectionReference used to access patient's profile data on Firestore

var adr; // home address
var age; // age
var conds; // medical conditions that the patient has
var dob; // date of birth
var first; // first name
var ht; // height
var last; // last name
var meds; // medications that the patient is on
var province; // province or territory
var sex; // sex of patient
var tele; // telephone number
var wt; // weight

class ProfileEdit extends StatefulWidget {
  const ProfileEdit({Key? key}) : super(key: key);

  @override
  _ProfileEditState createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  final _auth = FirebaseAuth.instance;
  var loggedInUser;
  var uid;
  bool showSpinner = false;

  TextEditingController adrTEC = TextEditingController();
  TextEditingController ageTEC = TextEditingController();
  TextEditingController condsTEC = TextEditingController();
  TextEditingController dobTEC = TextEditingController();
  TextEditingController firstTEC = TextEditingController();
  TextEditingController htTEC = TextEditingController();
  TextEditingController lastTEC = TextEditingController();
  TextEditingController medsTEC = TextEditingController();
  TextEditingController teleTEC = TextEditingController();
  TextEditingController wtTEC = TextEditingController();

  void updateProfile() {
    // this function tells code that if the user does not enter anything
    // in a specific text field, don't change it in Firestore
    setState(
      () {
        if (adrTEC.text == '') {
          adr = adr;
        } else
          adr = adrTEC.text;

        if (ageTEC.text == '') {
          age = age;
        } else
          age = ageTEC.text;

        if (condsTEC.text == '') {
          conds = conds;
        } else
          conds = condsTEC.text;

        if (dobTEC.text == '') {
          dob = dob;
        } else
          dob = dobTEC.text;

        if (firstTEC.text == '') {
          first = first;
        } else
          first = firstTEC.text;

        if (htTEC.text == '') {
          ht = ht;
        } else
          ht = htTEC.text;

        if (lastTEC.text == '') {
          last = last;
        } else
          last = lastTEC.text;

        if (medsTEC.text == '') {
          meds = meds;
        } else
          meds = medsTEC.text;

        if (teleTEC.text == '') {
          tele = tele;
        } else
          tele = teleTEC.text;

        if (wtTEC.text == '') {
          wt = wt;
        } else
          wt = wtTEC.text;
      },
    );
  }

  @override
  void initState() {
    // initialize functions
    getCurrentUser();
    getUserData(uid);
    super.initState();
  }

  void getCurrentUser() async {
    // find uid
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
        uid = user.uid.toString();
      }
    } catch (e) {
      print(e);
    }
  }

  getUserData(uid) async {
    // retrieve patient's data from Firestore
    final DocumentSnapshot patientInfo = await patientRef.doc(uid).get();
    setState(
      () {
        adr = patientInfo.get('address');
        age = patientInfo.get('age');
        conds = patientInfo.get('conds');
        dob = patientInfo.get('dob');
        first = patientInfo.get('first name');
        ht = patientInfo.get('ht');
        last = patientInfo.get('last name');
        meds = patientInfo.get('meds');
        province = patientInfo.get('province');
        sex = patientInfo.get('sex');
        tele = patientInfo.get('tele');
        wt = patientInfo.get('wt');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSecondaryColour,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Edit my Information'),
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10.0),
            ),
            textFieldLabel('First Name'),
            TextFormField(
              controller: firstTEC,
              decoration: kTextFieldDecoration.copyWith(
                hintText: first,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            textFieldLabel('Last Name'),
            TextFormField(
              controller: lastTEC,
              decoration: kTextFieldDecoration.copyWith(
                hintText: last,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            textFieldLabel('Age'),
            TextFormField(
              maxLength: 3,
              controller: ageTEC,
              keyboardType: TextInputType.number,
              decoration: kTextFieldDecoration.copyWith(
                counterText: '',
                hintText: age,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            textFieldLabel('Date of Birth (DD-MM-YYYY)'),
            TextFormField(
              maxLength: 10,
              controller: dobTEC,
              keyboardType: TextInputType.datetime,
              decoration: kTextFieldDecoration.copyWith(
                counterText: '',
                hintText: dob,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                textFieldLabel('Province/Territory:    '),
                DropdownButton<String>(
                  iconDisabledColor: Colors.black,
                  iconEnabledColor: Colors.black,
                  value: province,
                  hint: Text(''),
                  style: kTextStyle2,
                  items: [
                    DropdownMenuItem(
                      child: Text(''),
                      value: '',
                    ),
                    DropdownMenuItem(
                      child: Text('AB'),
                      value: 'AB',
                    ),
                    DropdownMenuItem(
                      child: Text('BC'),
                      value: 'BC',
                    ),
                    DropdownMenuItem(
                      child: Text('MB'),
                      value: 'MB',
                    ),
                    DropdownMenuItem(
                      child: Text('NB'),
                      value: 'NB',
                    ),
                    DropdownMenuItem(
                      child: Text('NL'),
                      value: 'NL',
                    ),
                    DropdownMenuItem(
                      child: Text('NS'),
                      value: 'NS',
                    ),
                    DropdownMenuItem(
                      child: Text('NU'),
                      value: 'NU',
                    ),
                    DropdownMenuItem(
                      child: Text('NWT'),
                      value: 'NWT',
                    ),
                    DropdownMenuItem(
                      child: Text('ON'),
                      value: 'ON',
                    ),
                    DropdownMenuItem(
                      child: Text('PEI'),
                      value: 'PEI',
                    ),
                    DropdownMenuItem(
                      child: Text('QC'),
                      value: 'QC',
                    ),
                    DropdownMenuItem(
                      child: Text('SK'),
                      value: 'SK',
                    ),
                    DropdownMenuItem(
                      child: Text('YT'),
                      value: 'YT',
                    ),
                  ],
                  onChanged: (value) {
                    setState(
                      () {
                        province = value.toString();
                      },
                    );
                  },
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                textFieldLabel('Sex:    '),
                DropdownButton<String>(
                  iconDisabledColor: Colors.black,
                  iconEnabledColor: Colors.black,
                  value: sex,
                  hint: Text(''),
                  style: kTextStyle2,
                  items: [
                    DropdownMenuItem(
                      child: Text(''),
                      value: '',
                    ),
                    DropdownMenuItem(
                      child: Text('M'),
                      value: 'M',
                    ),
                    DropdownMenuItem(
                      child: Text('F'),
                      value: 'F',
                    ),
                    DropdownMenuItem(
                      child: Text('X'),
                      value: 'X',
                    ),
                  ],
                  onChanged: (value) {
                    setState(
                      () {
                        sex = value.toString();
                      },
                    );
                  },
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            textFieldLabel('Height (Please specify if measured in cm or ft)'),
            TextFormField(
              controller: htTEC,
              decoration: kTextFieldDecoration.copyWith(
                hintText: ht,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            textFieldLabel('Weight (Please specify if measured in lbs or kg)'),
            TextFormField(
              controller: wtTEC,
              decoration: kTextFieldDecoration.copyWith(
                hintText: wt,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            textFieldLabel('Medical Conditions (Please list all)'),
            TextFormField(
              controller: condsTEC,
              decoration: kTextFieldDecoration.copyWith(
                hintText: conds,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            textFieldLabel('Medications (Please list all)'),
            TextFormField(
              controller: medsTEC,
              decoration: kTextFieldDecoration.copyWith(
                hintText: meds,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            textFieldLabel('Telephone Number'),
            TextFormField(
              maxLength: 12,
              controller: teleTEC,
              keyboardType: TextInputType.phone,
              decoration: kTextFieldDecoration.copyWith(
                counterText: '',
                hintText: tele,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            textFieldLabel('Home Address'),
            TextFormField(
              keyboardType: TextInputType.streetAddress,
              controller: adrTEC,
              decoration: kTextFieldDecoration.copyWith(
                hintText: adr,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: ElevatedButton(
                    style: kCancel,
                    onPressed: () async {
                      setState(
                        () {
                          // if the user presses 'cancel', do not change any values
                          // in Firestore, even if there are new values in some text fields and exit page
                          adr = adr;
                          age = age;
                          conds = conds;
                          dob = dob;
                          first = first;
                          ht = ht;
                          last = last;
                          meds = meds;
                          tele = tele;
                          wt = wt;
                          Navigator.pop(context);
                        },
                      );
                    },
                    child: Text(
                      'Cancel',
                      style: kAppBarLabelStyle,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: ElevatedButton(
                    style: kConfirm,
                    onPressed: () async {
                      setState(
                        () {
                          // if the user presses confirm, update info in Firestore and exit page
                          showSpinner = true;
                          updateProfile();
                          DatabaseAuth(uid: loggedInUser.uid).updatePatientData(
                            adr,
                            age,
                            conds,
                            dob,
                            first,
                            ht,
                            last,
                            meds,
                            province,
                            sex,
                            tele,
                            wt,
                          );
                          Navigator.pop(
                            context,
                            {
                              adr,
                              age,
                              conds,
                              dob,
                              first,
                              ht,
                              last,
                              meds,
                              province,
                              sex,
                              tele,
                              wt,
                            },
                          );
                          setState(
                            () {
                              showSpinner = false;
                            },
                          );
                        },
                      );
                    },
                    child: Text(
                      'Confirm',
                      style: kAppBarLabelStyle,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
