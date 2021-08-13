import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_health_app/Constants.dart';
import 'package:mobile_health_app/settings_pages/settings_constants.dart';
import 'package:mobile_health_app/welcome_authentication_pages/database_auth_services.dart';

final patientRef = FirebaseFirestore.instance
    .collection('patientprofile'); // create this as global variable
var first;
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

  TextEditingController firstTEC = TextEditingController();
  TextEditingController lastTEC = TextEditingController();
  TextEditingController ageTEC = TextEditingController();
  TextEditingController dobTEC = TextEditingController();
  TextEditingController medsTEC = TextEditingController();
  TextEditingController condsTEC = TextEditingController();
  TextEditingController wtTEC = TextEditingController();
  TextEditingController htTEC = TextEditingController();
  TextEditingController teleTEC = TextEditingController();
  TextEditingController adrTEC = TextEditingController();

  void updateProfile() {
    // this function tells code that if the user does not enter anything in a specific text field, don't change it
    setState(
      () {
        if (firstTEC.text == '') {
          first = first;
        } else
          first = firstTEC.text;

        if (lastTEC.text == '') {
          last = last;
        } else
          last = lastTEC.text;

        if (ageTEC.text == '') {
          age = age;
        } else
          age = ageTEC.text;

        if (dobTEC.text == '') {
          dob = dob;
        } else
          dob = dobTEC.text;

        if (medsTEC.text == '') {
          meds = meds;
        } else
          meds = medsTEC.text;

        if (condsTEC.text == '') {
          conds = conds;
        } else
          conds = condsTEC.text;

        if (wtTEC.text == '') {
          wt = wt;
        } else
          wt = wtTEC.text;

        if (htTEC.text == '') {
          ht = ht;
        } else
          ht = htTEC.text;
        if (teleTEC.text == '') {
          tele = tele;
        } else
          tele = teleTEC.text;
        if (adrTEC.text == '') {
          adr = adr;
        } else
          adr = adrTEC.text;
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
    // calls on specific fields from the patient's document to display their profile info
    final DocumentSnapshot patientInfo = await patientRef.doc(uid).get();
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
        automaticallyImplyLeading: false,
        title: Text(
          'Edit my Information',
          style: kAppBarLabelStyle,
        ),
        centerTitle: true,
        backgroundColor: kPrimaryColour,
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
                DropdownButton<String>(
                  iconDisabledColor: Colors.black,
                  iconEnabledColor: Colors.black,
                  hint: Text(
                    'Sex',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  value: sex,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                  ),
                  items: [
                    DropdownMenuItem(
                      child: Text('Sex'),
                      value: 'Sex',
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
                          first = first;
                          last = last;
                          age = age;
                          dob = dob;
                          meds = meds;
                          conds = conds;
                          wt = wt;
                          ht = ht;
                          tele = tele;
                          adr = adr;
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
                          showSpinner = true;
                          updateProfile();
                          DatabaseAuth(uid: loggedInUser.uid).updatePatientData(
                            first,
                            last,
                            age,
                            dob,
                            sex,
                            ht,
                            wt,
                            conds,
                            meds,
                            tele,
                            adr,
                          );
                          Navigator.pop(
                            context,
                            {
                              first,
                              last,
                              age,
                              dob,
                              sex,
                              ht,
                              wt,
                              conds,
                              meds,
                              tele,
                              adr
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
