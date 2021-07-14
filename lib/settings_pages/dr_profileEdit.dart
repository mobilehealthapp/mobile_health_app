import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_health_app/settings_pages/settings_card.dart';
import 'settings_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DrProfileEdit extends StatefulWidget {
  static String drFirst = 'First Name';
  static String drLast = 'Last Name';
  static String quali = 'My Qualifications';
  static String drTele = 'Telephone Number';
  static String drEmail = 'Email Address';
  static String drFax = 'Fax';
  static String clinicAdd = 'Clinic Address';

  static TextEditingController drFirstTEC = TextEditingController();
  static TextEditingController drLastTEC = TextEditingController();
  static TextEditingController qualiTEC = TextEditingController();
  static TextEditingController drTeleTEC = TextEditingController();
  static TextEditingController drEmailTEC = TextEditingController();
  static TextEditingController drFaxTEC = TextEditingController();
  static TextEditingController clinicAddTEC = TextEditingController();

  static void drUpdateProfile() {
    if (drFirstTEC.text == '') {
      DrProfileEdit.drFirst = DrProfileEdit.drFirst;
    } else
      DrProfileEdit.drFirst = drFirstTEC.text;

    if (drLastTEC.text == '') {
      DrProfileEdit.drLast = DrProfileEdit.drLast;
    } else
      DrProfileEdit.drLast = drLastTEC.text;

    if (qualiTEC.text == '') {
      DrProfileEdit.quali = DrProfileEdit.quali;
    } else
      DrProfileEdit.quali = qualiTEC.text;

    if (drTeleTEC.text == '') {
      DrProfileEdit.drTele = DrProfileEdit.drTele;
    } else
      DrProfileEdit.drTele = drTeleTEC.text;

    if (drEmailTEC.text == '') {
      DrProfileEdit.drEmail = DrProfileEdit.drEmail;
    } else
      DrProfileEdit.drEmail = drEmailTEC.text;

    if (drFaxTEC.text == '') {
      DrProfileEdit.drFax = DrProfileEdit.drFax;
    } else
      DrProfileEdit.drFax = drFaxTEC.text;

    if (clinicAddTEC.text == '') {
      DrProfileEdit.clinicAdd = DrProfileEdit.clinicAdd;
    } else
      DrProfileEdit.clinicAdd = clinicAddTEC.text;
  }

  @override
  _DrProfileEditState createState() => _DrProfileEditState();
}

class _DrProfileEditState extends State<DrProfileEdit> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  late User loggedInUser;

  @override
  void initState() {
    super.initState();

    getUser();
  }

  void getUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFB2EBF2),
      appBar: AppBar(
        title: Text(
          'Edit my Information',
          style: kAppBarLabelStyle,
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF00BCD4),
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: ListView(
          children: <Widget>[
            TextField(
              controller: DrProfileEdit.drFirstTEC,
              decoration: kTextFieldDecoration.copyWith(
                hintText: DrProfileEdit.drFirst,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            TextField(
              controller: DrProfileEdit.drLastTEC,
              decoration: kTextFieldDecoration.copyWith(
                hintText: DrProfileEdit.drLast,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            TextField(
              controller: DrProfileEdit.qualiTEC,
              decoration: kTextFieldDecoration.copyWith(
                hintText: DrProfileEdit.quali,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            TextField(
              controller: DrProfileEdit.drTeleTEC,
              decoration: kTextFieldDecoration.copyWith(
                hintText: DrProfileEdit.drTele,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            TextField(
              controller: DrProfileEdit.drEmailTEC,
              decoration: kTextFieldDecoration.copyWith(
                hintText: DrProfileEdit.drEmail,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            TextField(
              controller: DrProfileEdit.drFaxTEC,
              decoration: kTextFieldDecoration.copyWith(
                hintText: DrProfileEdit.drFax,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            TextField(
              controller: DrProfileEdit.clinicAddTEC,
              decoration: kTextFieldDecoration.copyWith(
                hintText: DrProfileEdit.clinicAdd,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: GestureDetector(
                    child: CancelOrConfirm(
                      whichOne: 'Cancel',
                      colour: Colors.red[900],
                    ),
                    onTap: () {
                      setState(
                        () {
                          Navigator.pop(
                            context,
                            {
                              DrProfileEdit.drFirst = DrProfileEdit.drFirst,
                              DrProfileEdit.drLast = DrProfileEdit.drLast,
                              DrProfileEdit.quali = DrProfileEdit.quali,
                              DrProfileEdit.drTele = DrProfileEdit.drTele,
                              DrProfileEdit.drEmail = DrProfileEdit.drEmail,
                              DrProfileEdit.drFax = DrProfileEdit.drFax,
                              DrProfileEdit.clinicAdd = DrProfileEdit.clinicAdd,
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: GestureDetector(
                    child: CancelOrConfirm(
                      whichOne: 'Confirm',
                      colour: Colors.green[400],
                    ),
                    onTap: () {
                      setState(
                        () {
                          DrProfileEdit.drUpdateProfile();
                          _firestore.collection('doctorprofile').add(
                            {
                              'drFirst': DrProfileEdit.drFirst,
                              'drLast': DrProfileEdit.drLast,
                              'quali': DrProfileEdit.quali,
                              'drTele': DrProfileEdit.drTele,
                              'drEmail': DrProfileEdit.drEmail,
                              'drFax': DrProfileEdit.drFax,
                              'clinicAddress': DrProfileEdit.clinicAdd,
                            },
                          );
                          Navigator.pop(
                            context,
                            // {
                            //   DrProfileEdit.drFirst,
                            //   DrProfileEdit.drLast,
                            //   DrProfileEdit.quali,
                            //   DrProfileEdit.drTele,
                            //   DrProfileEdit.drEmail,
                            //   DrProfileEdit.drFax,
                            //   DrProfileEdit.clinicAdd,
                            // },
                          );
                        },
                      );
                    },
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
