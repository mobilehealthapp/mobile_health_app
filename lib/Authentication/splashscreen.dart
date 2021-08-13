import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mobile_health_app/Authentication/accountcheck.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    accountCheckNavigation(context);
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
    if (FirebaseAuth.instance.currentUser!.emailVerified) {
      if (await patientAccountCheck(FirebaseAuth.instance.currentUser!.uid)) {
        WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
          Navigator.pushReplacementNamed(context, '/home');
        });
      } else if (await doctorAccountCheck(
          FirebaseAuth.instance.currentUser!.uid)) {
        WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
          Navigator.pushReplacementNamed(context, '/physHome');
        });
      }
    } else
      Navigator.pushReplacementNamed(context, '/verify');
  } else {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      Navigator.pushReplacementNamed(context, '/');
    });
  }
}
