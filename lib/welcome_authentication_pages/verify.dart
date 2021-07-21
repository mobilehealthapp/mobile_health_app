import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_health_app/HomePage.dart';
import 'package:mobile_health_app/physHome.dart';

import 'accountcheck.dart';
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

  @override
  void initState() {
    user = auth.currentUser;
    user.sendEmailVerification();

    timer = Timer.periodic(Duration(seconds: 5), (timer) {
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
      body: Center(
        child: Text(
            'An email has been sent to ${user.email}, please follow steps in email to verify and access full app functionality'),
      ),
    );
  }

  Future<void> checkEmailVerify() async {
    user = auth.currentUser;
    var uid = user!.uid;
    await user.reload();
    if (user.emailVerified) {
      timer.cancel();
      bool isPatient = await patientAccountCheck(uid);
      bool isDoctor = await doctorAccountCheck(uid);
      if (isPatient) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomePage()));
      } else if (isDoctor) {
        String physicianCode = getSecureCode(12);
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Physician access code'),
                content: Text(
                    'Your physician access code is $physicianCode, please write this code down and keep it secure. Provide it to your patients so they can add you to their list of approved physicians'),
              );
            });
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => PhysHome()));
      }
    }
  }
}
