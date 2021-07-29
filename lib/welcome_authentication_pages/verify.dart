import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_health_app/Constants.dart';
import 'package:mobile_health_app/physHome.dart';

import 'accountcheck.dart';
import 'database_auth_services.dart';
import 'physiciancode.dart';

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
    user = auth.currentUser;
    user.sendEmailVerification();

    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      checkEmailVerify();
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
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
    var uid = user!.uid;
    await user.reload();
    if (user.emailVerified) {
      setState(() {
        showSpinner = true;
      });
      timer.cancel();
      bool isPatient = await patientAccountCheck(uid);
      bool isDoctor = await doctorAccountCheck(uid);
      if (isPatient) {
        Navigator.of(context).pushReplacementNamed('/home');
        setState(() {
          showSpinner = false;
        });
      } else if (isDoctor == true) {
        String physicianCode = getSecureCode(12);
        DatabaseAuth(uid: uid).setDoctorCode(physicianCode);
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => PhysHome()));
                      },
                      child: Text('Dismiss'))
                ],
                title: Text('Physician access code'),
                content: Text(
                    'Your physician access code is $physicianCode, please write this code down and keep it secure. Provide it to your patients so they can add you to their list of approved physicians'),
              );
            });
        Navigator.of(context).pushReplacementNamed('/physHome');
        setState(() {
          showSpinner = false;
        });
      }
    }
  }
}
