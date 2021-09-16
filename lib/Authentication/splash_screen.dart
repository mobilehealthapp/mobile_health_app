import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mobile_health_app/Authentication/account_check.dart';

//This file contains the UI and functionality for the Splash Screen, which is briefly displayed every time the app is launched
//TODO: This page functions properly, feel free to improve UI if necessary
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    accountCheckNavigation(
        context); //Calls function that checks account type and navigates to correct side of the app upon launch
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('images/logo.png'), fit: BoxFit.fill),
              ),
            ),
            SizedBox(height: 20),
            SpinKitFadingCircle(
              //Circular loading animation to show user that something is happening
              color: Colors.blueGrey,
              size: 75,
            )
          ],
        ),
      ),
    );
  }
}

void accountCheckNavigation(BuildContext context) async {
  if (FirebaseAuth.instance.currentUser != null) {
    //Checks if a user is currently logged in
    if (FirebaseAuth.instance.currentUser!.emailVerified) {
      //Checks if current user's email is verified
      if (await patientAccountCheck(FirebaseAuth.instance.currentUser!.uid)) {
        //Checks if user is a patient by inputting the current user's UID into function defined in accountCheck.dart
        WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
          Navigator.pushReplacementNamed(context,
              '/home'); //If user is a patient, navigates to patient homepage
        });
      } else if (await doctorAccountCheck(
          //Same as previous function but checks if user is a doctor.
          FirebaseAuth.instance.currentUser!.uid)) {
        WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
          Navigator.pushReplacementNamed(context,
              '/physHome'); //If user is a doctor, navigates to physician homepage
        });
      }
    } else
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        Navigator.pushReplacementNamed(context, '/verify');
      }); //If user's email has not been verified, navigates to email verification screen
  } else {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      Navigator.pushReplacementNamed(
          context, '/'); //If user is not logged in, navigates to welcome screen
    });
  }
}
