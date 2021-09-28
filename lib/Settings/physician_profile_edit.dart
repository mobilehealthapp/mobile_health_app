import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_health_app/constants.dart';
import 'settings_constants.dart';
import 'package:mobile_health_app/Authentication/database_auth_services.dart';

final doctorRef = FirebaseFirestore.instance
    .collection('doctorprofile'); // CollectionReference used to access doctor's profile data on Firestore

var clinicAdr; // clinic address
var drFirst; // first name
var drLast; // last name
var drTele; // telephone number (clinic)
var fax; // fax number (clinic)
var province; // province or territory
var quali; // qualifications

class DrProfileEdit extends StatefulWidget {
  @override
  _DrProfileEditState createState() => _DrProfileEditState();
}

class _DrProfileEditState extends State<DrProfileEdit> {
  final _auth = FirebaseAuth.instance;
  var uid;
  var loggedInUser;

  TextEditingController clinicAdrTEC = TextEditingController();
  TextEditingController drFirstTEC = TextEditingController();
  TextEditingController drLastTEC = TextEditingController();
  TextEditingController drTeleTEC = TextEditingController();
  TextEditingController faxTEC = TextEditingController();
  TextEditingController provinceTEC = TextEditingController();
  TextEditingController qualiTEC = TextEditingController();

  void drUpdateProfile() {
    // this function tells code that if the user does not enter anything
    // in a specific text field, don't change it in Firestore
    if (clinicAdrTEC.text == '') {
      clinicAdr = clinicAdr;
    } else
      clinicAdr = clinicAdrTEC.text;

    if (drFirstTEC.text == '') {
      drFirst = drFirst;
    } else
      drFirst = drFirstTEC.text;

    if (drLastTEC.text == '') {
      drLast = drLast;
    } else
      drLast = drLastTEC.text;

    if (drTeleTEC.text == '') {
      drTele = drTele;
    } else
      drTele = drTeleTEC.text;

    if (faxTEC.text == '') {
      fax = fax;
    } else
      fax = faxTEC.text;

    if (provinceTEC.text == '') {
      province = province;
    } else
      province = provinceTEC.text;

    if (qualiTEC.text == '') {
      quali = quali;
    } else
      quali = qualiTEC.text;
  }



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
            TextField(
              controller: drFirstTEC,
              decoration: kTextFieldDecoration.copyWith(
                hintText: drFirst,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            textFieldLabel('Last Name'),
            TextField(
              controller: drLastTEC,
              decoration: kTextFieldDecoration.copyWith(
                hintText: drLast,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            textFieldLabel('Qualifications'),
            TextField(
              controller: qualiTEC,
              decoration: kTextFieldDecoration.copyWith(
                hintText: quali,
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
              height: 10.0,
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
              height: 10.0,
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
                          clinicAdr = clinicAdr;
                          drFirst = drFirst;
                          drLast = drLast;
                          drTele = drTele;
                          fax = fax;
                          province = province;
                          quali = quali;
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
                          drUpdateProfile();
                          DatabaseAuth(uid: loggedInUser.uid).updateDoctorData(
                            clinicAdr,
                            drFirst,
                            drLast,
                            fax,
                            drTele,
                            province,
                            quali,
                          );
                          Navigator.pop(
                            context,
                            {
                              clinicAdr,
                              drFirst,
                              drLast,
                              fax,
                              drTele,
                              province,
                              quali,
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
