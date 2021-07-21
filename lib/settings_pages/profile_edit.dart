import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_health_app/settings_pages/settings_card.dart';
import 'package:mobile_health_app/settings_pages/settings_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile_health_app/welcome_authentication_pages/database.dart';

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
  void initState() {
    getCurrentUser();
    getUserData(uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFB2EBF2),
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
            TextFormField(
              controller: firstTEC,
              decoration: kTextFieldDecoration.copyWith(
                hintText: first,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            TextFormField(
              controller: lastTEC,
              decoration: kTextFieldDecoration.copyWith(
                hintText: last,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
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
            TextFormField(
              maxLength: 10,
              controller: dobTEC,
              keyboardType: TextInputType.number,
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
                  value: sex,
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
            TextFormField(
              controller: htTEC,
              decoration: kTextFieldDecoration.copyWith(
                hintText: ht,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            TextFormField(
              controller: wtTEC,
              decoration: kTextFieldDecoration.copyWith(
                hintText: wt,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            TextFormField(
              controller: condsTEC,
              decoration: kTextFieldDecoration.copyWith(
                hintText: conds,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            TextFormField(
              controller: medsTEC,
              decoration: kTextFieldDecoration.copyWith(
                hintText: meds,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            TextFormField(
              controller: teleTEC,
              decoration: kTextFieldDecoration.copyWith(
                hintText: tele,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            TextFormField(
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
                          updateProfile();
                          Database(uid: loggedInUser.uid).updatePatientInfo(
                              first,
                              last,
                              age,
                              dob,
                              sex.toString(),
                              ht,
                              wt,
                              conds,
                              meds,
                              tele,
                              adr);
                          Navigator.pop(
                            context,
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
