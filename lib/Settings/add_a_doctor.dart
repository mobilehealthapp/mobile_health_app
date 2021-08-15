import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_health_app/Constants.dart';

import 'settings_card.dart';
import 'settings_constants.dart';

class AddDoctors extends StatefulWidget {
  @override
  _AddDoctorsState createState() => _AddDoctorsState();
}

class _AddDoctorsState extends State<AddDoctors> {
  var inputtedCode;
  var firstName;
  var lastName;
  var label;
  var email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSecondaryColour,
      appBar: AppBar(
        title: Text('Add A Doctor'),
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  'Please enter your physician\'s information below to add them to your list of doctors',
                  textAlign: TextAlign.center,
                  style: kLabelStyle.copyWith(color: Colors.black),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
              child: TextFormField(
                decoration:
                    kTextFieldDecoration.copyWith(hintText: 'First Name'),
                onChanged: (value) {
                  firstName = value;
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
              child: TextFormField(
                decoration:
                    kTextFieldDecoration.copyWith(hintText: 'Last Name'),
                onChanged: (value) {
                  lastName = value;
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
              child: TextFormField(
                decoration:
                    kTextFieldDecoration.copyWith(hintText: 'Email Address'),
                onChanged: (value) {
                  email = value;
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.0, bottom: 5.0),
              child: TextFormField(
                onChanged: (value) {
                  inputtedCode = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Doctor\'s Access Code'),
              ),
            ),
            Container(
              padding: EdgeInsets.only(right: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MaterialButton(
                    child: Text(
                      'What is this?',
                      style: TextStyle(color: Colors.grey[800], fontSize: 17),
                    ),
                    onPressed: () async {
                      return showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return new Alert3();
                          // displays alert explaining how doctors receive a unique access code when they sign up
                        },
                      );
                    },
                    padding: EdgeInsets.only(bottom: 20.0, top: 5.0),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
              child: TextFormField(
                decoration:
                    kTextFieldDecoration.copyWith(hintText: 'Doctor\'s Label'),
                onChanged: (value) {
                  label = value;
                },
              ),
            ),
            Container(
              padding: EdgeInsets.only(right: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MaterialButton(
                    child: Text(
                      'What is this?',
                      style: TextStyle(color: Colors.grey[800], fontSize: 17),
                    ),
                    onPressed: () async {
                      return showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return new Alert4();
                          // displays alert explaining that the user can create any label for the doctor
                          // that they'd like to help them remember who the doctor is to them (specialist, family physician, etc.)
                        },
                      );
                    },
                    padding: EdgeInsets.only(bottom: 20.0, top: 5.0),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: ElevatedButton(
                onPressed: () async {
                  String uid = FirebaseAuth.instance.currentUser!.uid;
                  await FirebaseFirestore.instance
                      .collection('doctorprofile')
                      .where('access code', isEqualTo: inputtedCode)
                      .get()
                      .then((QuerySnapshot querySnapshot) {
                    if (querySnapshot.docs.length == 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          duration: Duration(seconds: 10),
                          backgroundColor: Colors.red,
                          content: Text(
                            'This code does not match an existing doctor profile. Please ensure you are inputting the correct code as provided by your doctor',
                            style: TextStyle(fontSize: 20.0),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    } else {
                      querySnapshot.docs.forEach((doc) async {
                        String doctorUID = doc.id;
                        FirebaseFirestore.instance
                            .collection('patientprofile')
                            .doc(uid)
                            .collection('patientDoctors')
                            .doc(doctorUID)
                            .set({
                          'doctorUID': doctorUID,
                          'doctorFirstName': firstName,
                          'doctorLastName': lastName,
                          'doctorEmail': email,
                          'doctorLabel': label
                        });
                        var patientUID = FirebaseAuth.instance.currentUser!.uid;
                        var patientSnapshot = await FirebaseFirestore.instance
                            .collection('patientprofile')
                            .doc(patientUID)
                            .get();
                        var patientData = patientSnapshot.data();
                        print(patientData);

                        await FirebaseFirestore.instance
                            .collection('doctorprofile')
                            .doc(doctorUID)
                            .collection('doctorPatients')
                            .doc(patientUID)
                            .set(patientData!);
                        await FirebaseFirestore.instance
                            .collection('doctorprofile')
                            .doc(doctorUID)
                            .collection('doctorPatients')
                            .doc(patientUID)
                            .update({'patientUID': patientUID});
                      });

                      Navigator.pop(context);
                    }
                  });
                },
                child: Text(
                  'Add This Doctor',
                  style: kLabelStyle,
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(20.0),
                  primary: Colors.green[400],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
