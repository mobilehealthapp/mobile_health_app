import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_health_app/Constants.dart';
import 'settings_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_health_app/welcome_authentication_pages/database_auth_services..dart';

final doctorRef = FirebaseFirestore.instance
    .collection('doctorprofile'); // create this as global variable
var drFirst;
var drLast;
var quali;
var drTele;
var fax;
var clinicAdr;

class DrProfileEdit extends StatefulWidget {
  @override
  _DrProfileEditState createState() => _DrProfileEditState();
}

class _DrProfileEditState extends State<DrProfileEdit> {
  final _auth = FirebaseAuth.instance;
  var uid;
  var loggedInUser;

  TextEditingController drFirstTEC = TextEditingController();
  TextEditingController drLastTEC = TextEditingController();
  TextEditingController qualiTEC = TextEditingController();
  TextEditingController drTeleTEC = TextEditingController();
  TextEditingController faxTEC = TextEditingController();
  TextEditingController clinicAdrTEC = TextEditingController();

  void drUpdateProfile() {
    if (drFirstTEC.text == '') {
      drFirst = drFirst;
    } else
      drFirst = drFirstTEC.text;

    if (drLastTEC.text == '') {
      drLast = drLast;
    } else
      drLast = drLastTEC.text;

    if (qualiTEC.text == '') {
      quali = quali;
    } else
      quali = qualiTEC.text;

    if (drTeleTEC.text == '') {
      drTele = drTele;
    } else
      drTele = drTeleTEC.text;

    if (faxTEC.text == '') {
      fax = fax;
    } else
      fax = faxTEC.text;

    if (clinicAdrTEC.text == '') {
      clinicAdr = clinicAdr;
    } else
      clinicAdr = clinicAdrTEC.text;
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    getUserData(uid);
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
    final DocumentSnapshot doctorInfo = await doctorRef.doc(uid).get();
    setState(
      () {
        drFirst = doctorInfo.get('first name');
        drLast = doctorInfo.get('last name');
        drTele = doctorInfo.get('tele');
        quali = doctorInfo.get('quali');
        fax = doctorInfo.get('fax');
        clinicAdr = doctorInfo.get('clinicAddress');
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
            TextField(
              controller: drFirstTEC,
              decoration: kTextFieldDecoration.copyWith(
                hintText: drFirst,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            textFieldLabel('Last Name'),
            TextField(
              controller: drLastTEC,
              decoration: kTextFieldDecoration.copyWith(
                hintText: drLast,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            textFieldLabel('Qualifications'),
            TextField(
              controller: qualiTEC,
              decoration: kTextFieldDecoration.copyWith(
                hintText: quali,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            textFieldLabel('Telephone Number'),
            TextField(
              maxLength: 12,
              controller: drTeleTEC,
              keyboardType: TextInputType.phone,
              decoration: kTextFieldDecoration.copyWith(
                counterText: '',
                hintText: drTele,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            textFieldLabel('Fax Number'),
            TextField(
              maxLength: 12,
              controller: faxTEC,
              keyboardType: TextInputType.phone,
              decoration: kTextFieldDecoration.copyWith(
                counterText: '',
                hintText: fax,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            textFieldLabel('Clinic Address'),
            TextField(
              keyboardType: TextInputType.streetAddress,
              controller: clinicAdrTEC,
              decoration: kTextFieldDecoration.copyWith(
                hintText: clinicAdr,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: ElevatedButton(
                    style: kCancel,
                    onPressed: () async {
                      setState(
                        () {
                          drFirst = drFirst;
                          drLast = drLast;
                          quali = quali;
                          drTele = drTele;
                          fax = fax;
                          clinicAdr = clinicAdr;
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
                          drUpdateProfile();
                          DatabaseAuth(uid: loggedInUser.uid).updateDoctorData(
                            drFirst,
                            drLast,
                            quali,
                            fax,
                            drTele,
                            clinicAdr,
                          );
                          Navigator.pop(
                            context,
                            {
                              drFirst,
                              drLast,
                              quali,
                              drTele,
                              fax,
                              clinicAdr,
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
