import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_health_app/HomePage.dart';

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
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Center(
          child: Text(
            'An email has been sent to ${user.email}, please follow steps in email to verify and access full app functionality',
            style: TextStyle(fontSize: 20.0),
          ),
        ),
      ),
    );
  }

  Future<void> checkEmailVerify() async {
    user = auth.currentUser;
    await user.reload();
    setState(() {
      showSpinner = true;
    });
    if (user.emailVerified) {
      timer.cancel();
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
      setState(() {
        showSpinner = false;
      });
    }
  }
}
