import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'Camera/camera_input.dart';
import 'Camera/data_input_page.dart';

import 'package:mobile_health_app/welcome_authentication_pages/welcome_screen.dart';
import 'welcome_authentication_pages/loginpage.dart';
import 'welcome_authentication_pages/signup.dart';
import 'welcome_authentication_pages/verify.dart';
import 'welcome_authentication_pages/passwordreset..dart';

import 'settings_pages/settings.dart';
import 'settings_pages/dr_settings.dart';
import 'settings_pages/profile_edit.dart';
import 'settings_pages/profile_tab.dart';
import 'settings_pages/dr_profileEdit.dart';
import 'settings_pages/dr_profile.dart';
import 'settings_pages/privacy_policy.dart';
import 'settings_pages/terms_and_conditions.dart';
import 'settings_pages/my_doctors.dart';
import 'settings_pages/add_a_doctor.dart';
import 'package:mobile_health_app/settings_pages/delete_data_or_account.dart';
import 'settings_pages/medical_disclaimer.dart';

import 'package:mobile_health_app/HomePage.dart';
import 'health_analysis.dart';
import 'physHome.dart';

late List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  await Firebase.initializeApp();
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mobile Health App',
      theme: ThemeData(
        primaryColor: Color(0xFF00BCD4),
        primaryColorDark: Color(0xFF0097A7),
        primaryColorLight: Color(0xFFB2EBF2),
        accentColor: Color(0xFF607D8B),
        textTheme: TextTheme().apply(
          bodyColor: Color(0xFF212121),
          displayColor: Color(0xFF757575),
        ),
      ),
      initialRoute: FirebaseAuth.instance.currentUser != null ? '/home' : '/',
      routes: {
        '/': (context) => WelcomeScreen(),
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignupPage(),
        '/verify': (context) => EmailVerificationScreen(),
        '/reset': (context) => ResetScreen(),
        '/home': (context) => HomePage(),
        '/physHome': (context) => PhysHome(),
        '/healthAnalysis': (context) => HealthAnalysis(),

        '/cameraInput': (context) => CameraApp(),
        '/dataInput': (context) => DataInput(),

        '/settings': (context) => SettingsPage(),
        '/drSettings': (context) => DrSettingsPage(),
        '/profile': (context) => ProfilePage(),
        '/drProfile': (context) => DrProfilePage(),
        '/profileEdit': (context) => ProfileEdit(),
        '/drProfileEdit': (context) => DrProfileEdit(),
        '/myDoctors': (context) => MyDoctors(),
        '/addDoctors': (context) => AddDoctors(),
        '/privacyPolicy': (context) => PrivacyPolicy(),
        '/termsAndConditions': (context) => TermsAndConditions(),
        '/medicalDisclaimer': (context) => MedicalDisclaimer(),

        '/alertPatientAcc': (context) => AlertPatientAccount(),
        '/alertPatientData': (context) => AlertPatientData(),
        '/alertDoctorAcc': (context) => AlertDoctorAccount(),
        '/alertDoctorData': (context) => AlertDoctorData(),
      },
    );
  }
}