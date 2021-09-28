import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_health_app/constants.dart';

import 'account_check.dart';
import 'database_auth_services.dart';
import 'physician_code.dart';

//This file contains the UI and functionality for user email verification
class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({Key? key}) : super(key: key);

  @override
  _EmailVerificationScreenState createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final auth = FirebaseAuth.instance;
  var user;
  var timer;
  bool showSpinner = false;
  @override
  void initState() {
    user = auth.currentUser; //obtains current user
    user.sendEmailVerification(); //sends firebase email verification request to user's inbox

    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      checkEmailVerify(); //timer that performs checkEmailVerify function every second
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel(); //timer is canceled when page is closed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSecondaryColour,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 200.0,
              height: 200.0,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('images/BCLogo.png'), fit: BoxFit.fill),
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(30.0),
              child: Text(
                'An email has been sent to ${user.email}, please follow steps in email to verify and access full app functionality.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> checkEmailVerify() async {
    user = auth.currentUser;
    var uid = user!.uid; //obtains current user's uid
    await user.reload();
    if (user.emailVerified) {
      //checks if current user's email has been verified
      setState(() {
        showSpinner = true; //if verified, activates progress spinner
      });
      timer.cancel();
      bool isPatient = await patientAccountCheck(
          uid); //checks if user is patient using function from account_check.dart
      bool isDoctor = await doctorAccountCheck(
          uid); //checks if user is doctor using function from account_check.dart
      if (isPatient) {
        Navigator.of(context).pushReplacementNamed(
            '/home'); //navigates to patient homepage if user is patient
        setState(() {
          showSpinner = false;
        });
      } else if (isDoctor == true) {
        //if user is a doctor/physician
        String physicianCode =
            getSecureCode(12); //Generates a secure access code
        DatabaseAuth(uid: uid).setDoctorCode(
            physicianCode); //Stores code in doctor's profile in firebase
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                //Displays alert that shows doctors their code and explains its use
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed(
                            '/physHome'); //Navigates to physician home when alert is dismissed
                      },
                      child: Text('Dismiss'))
                ],
                title: Text('Physician access code'),
                content: Text(
                    'Your physician access code is $physicianCode, please write this code down and keep it secure. Provide it to your patients so they can add you to their list of approved physicians'),
              );
            });
        setState(() {
          showSpinner = false;
        });
      }
    }
  }
}
