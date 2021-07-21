import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_health_app/settings_pages/settings_card.dart';
import 'package:mobile_health_app/settings_pages/settings_constants.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile_health_app/welcome_authentication_pages/database.dart';

class ProfileEdit extends StatefulWidget {
  static String? sexChoose = '--Sex--';
  static String first = 'First Name';
  static String last = 'Last Name';
  static String age = 'Age';
  static String dob = 'Date of Birth (DD-MM-YYYY)';
  static String meds = 'My Medications';
  static String conds = 'My Medical Conditions';
  static String wt = 'Weight';
  static String ht = 'Height';
  static String tele = 'Telephone Number';
  static String email = 'Email Address';
  static String adr = 'Home Address';

  static TextEditingController firstTEC = TextEditingController();
  static TextEditingController lastTEC = TextEditingController();
  static TextEditingController ageTEC = TextEditingController();
  static TextEditingController dobTEC = TextEditingController();
  static TextEditingController medsTEC = TextEditingController();
  static TextEditingController condsTEC = TextEditingController();
  static TextEditingController wtTEC = TextEditingController();
  static TextEditingController htTEC = TextEditingController();
  static TextEditingController teleTEC = TextEditingController();
  static TextEditingController emailTEC = TextEditingController();
  static TextEditingController adrTEC = TextEditingController();

  static void updateProfile() {
    if (firstTEC.text == '') {
      ProfileEdit.first = ProfileEdit.first;
    } else
      ProfileEdit.first = firstTEC.text;

    if (lastTEC.text == '') {
      ProfileEdit.last = ProfileEdit.last;
    } else
      ProfileEdit.last = lastTEC.text;

    if (ageTEC.text == '') {
      ProfileEdit.age = ProfileEdit.age;
    } else
      ProfileEdit.age = ageTEC.text;

    if (dobTEC.text == '') {
      ProfileEdit.dob = ProfileEdit.dob;
    } else
      ProfileEdit.dob = dobTEC.text;

    if (medsTEC.text == '') {
      ProfileEdit.meds = ProfileEdit.meds;
    } else
      ProfileEdit.meds = medsTEC.text;

    if (condsTEC.text == '') {
      ProfileEdit.conds = ProfileEdit.conds;
    } else
      ProfileEdit.conds = condsTEC.text;

    if (wtTEC.text == '') {
      ProfileEdit.wt = ProfileEdit.wt;
    } else
      ProfileEdit.wt = wtTEC.text;

    if (htTEC.text == '') {
      ProfileEdit.ht = ProfileEdit.ht;
    } else
      ProfileEdit.ht = htTEC.text;

    if (teleTEC.text == '') {
      ProfileEdit.tele = ProfileEdit.tele;
    } else
      ProfileEdit.tele = teleTEC.text;

    if (emailTEC.text == '') {
      ProfileEdit.email = ProfileEdit.email;
    } else
      ProfileEdit.email = emailTEC.text;

    if (adrTEC.text == '') {
      ProfileEdit.adr = ProfileEdit.adr;
    } else
      ProfileEdit.adr = adrTEC.text;
  }

  @override
  _ProfileEditState createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  final _auth = FirebaseAuth.instance;
  late User loggedInUser;
  bool showSpinner = false;

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
        print(loggedInUser.uid);
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
            Padding(
              padding: EdgeInsets.all(10.0),
            ),
            TextField(
              controller: ProfileEdit.firstTEC,
              decoration: kTextFieldDecoration.copyWith(
                hintText: ProfileEdit.first,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            TextField(
              controller: ProfileEdit.lastTEC,
              decoration: kTextFieldDecoration.copyWith(
                hintText: ProfileEdit.last,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            TextField(
              controller: ProfileEdit.ageTEC,
              decoration: kTextFieldDecoration.copyWith(
                hintText: ProfileEdit.age,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            TextField(
              controller: ProfileEdit.dobTEC,
              decoration: kTextFieldDecoration.copyWith(
                hintText: ProfileEdit.dob,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownButton<String>(
                  value: ProfileEdit.sexChoose,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                  ),
                  items: [
                    DropdownMenuItem(
                      child: Text('--Sex--'),
                      value: '--Sex--',
                    ),
                    DropdownMenuItem(
                      child: Text('M'),
                      value: 'Male',
                    ),
                    DropdownMenuItem(
                      child: Text('F'),
                      value: 'Female',
                    ),
                    DropdownMenuItem(
                      child: Text('X'),
                      value: 'X',
                    ),
                  ],
                  onChanged: (value) {
                    setState(
                      () {
                        ProfileEdit.sexChoose = value.toString();
                      },
                    );
                  },
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            TextField(
              controller: ProfileEdit.htTEC,
              decoration: kTextFieldDecoration.copyWith(
                hintText: ProfileEdit.ht,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            TextField(
              controller: ProfileEdit.wtTEC,
              decoration: kTextFieldDecoration.copyWith(
                hintText: ProfileEdit.wt,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            TextField(
              controller: ProfileEdit.condsTEC,
              decoration: kTextFieldDecoration.copyWith(
                hintText: ProfileEdit.conds,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            TextField(
              controller: ProfileEdit.medsTEC,
              decoration: kTextFieldDecoration.copyWith(
                hintText: ProfileEdit.meds,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            TextField(
              controller: ProfileEdit.teleTEC,
              decoration: kTextFieldDecoration.copyWith(
                hintText: ProfileEdit.tele,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            TextField(
              controller: ProfileEdit.emailTEC,
              decoration: kTextFieldDecoration.copyWith(
                hintText: ProfileEdit.email,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            TextField(
              controller: ProfileEdit.adrTEC,
              decoration: kTextFieldDecoration.copyWith(
                hintText: ProfileEdit.adr,
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
                          ProfileEdit.first = ProfileEdit.first;
                          ProfileEdit.last = ProfileEdit.last;
                          ProfileEdit.age = ProfileEdit.age;
                          ProfileEdit.dob = ProfileEdit.dob;
                          ProfileEdit.meds = ProfileEdit.meds;
                          ProfileEdit.conds = ProfileEdit.conds;
                          ProfileEdit.wt = ProfileEdit.wt;
                          ProfileEdit.ht = ProfileEdit.ht;
                          ProfileEdit.tele = ProfileEdit.tele;
                          ProfileEdit.email = ProfileEdit.email;
                          ProfileEdit.adr = ProfileEdit.adr;
                          Navigator.pop(context);
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
                        () async {
                          showSpinner = true;
                          ProfileEdit.updateProfile();
                          await Database(uid: loggedInUser.uid)
                              .updatePatientInfo(
                            's',
                            ProfileEdit.age,
                            ProfileEdit.dob,
                            ProfileEdit.meds,
                            ProfileEdit.conds,
                            ProfileEdit.wt,
                            ProfileEdit.ht,
                            ProfileEdit.tele,
                            ProfileEdit.email,
                            ProfileEdit.adr,
                          );

                          // _firestore.collection('patientprofile').add(
                          //   {
                          //     'first': ProfileEdit.first,
                          //     'last': ProfileEdit.last,
                          //     'age': ProfileEdit.age,
                          //     'dob': ProfileEdit.dob,
                          //     'sexChoose': ProfileEdit.sexChoose,
                          //     'conds': ProfileEdit.conds,
                          //     'meds': ProfileEdit.meds,
                          //     'wt': ProfileEdit.wt,
                          //     'ht': ProfileEdit.ht,
                          //     'tele': ProfileEdit.tele,
                          //     'email': ProfileEdit.email,
                          //     'address': ProfileEdit.adr,
                          //     'user': loggedInUser,
                          //   },
                          // );
                          Navigator.pop(
                            context,
                            // {
                            //   ProfileEdit.first,
                            //   ProfileEdit.last,
                            //   ProfileEdit.dob,
                            //   ProfileEdit.age,
                            //   ProfileEdit.sexChoose,
                            //   ProfileEdit.conds,
                            //   ProfileEdit.meds,
                            //   ProfileEdit.wt,
                            //   ProfileEdit.ht,
                            //   ProfileEdit.tele,
                            //   ProfileEdit.email,
                            //   ProfileEdit.adr,
                            // },
                          );
                          setState(() {
                            showSpinner = false;
                          });
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
