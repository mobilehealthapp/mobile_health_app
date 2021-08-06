import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/services.dart';
import 'package:mobile_health_app/Constants.dart';

import 'Camera/camera_input.dart';
import 'Camera/data_input_page.dart';

import 'package:mobile_health_app/welcome_authentication_pages/welcome_screen.dart';
import 'welcome_authentication_pages/loginpage.dart';
import 'welcome_authentication_pages/signup.dart';
import 'welcome_authentication_pages/verify.dart';
import 'welcome_authentication_pages/passwordreset.dart';

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

import 'package:mobile_health_app/Home%20page/HomePage.dart';
import 'Analysis/health_analysis.dart';
import 'Physician side/physHome.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

AndroidNotificationChannel? channel;

FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

List<CameraDescription> cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    cameras = await availableCameras();
  } catch (e) {
    cameras = [];
    print(e);
  }
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage;

  if (!kIsWeb) {
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      'This channel is used for important notifications.', // description
      importance: Importance.high,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin!
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel!);

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mobile Health App',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backwardsCompatibility: false,
          systemOverlayStyle: SystemUiOverlayStyle.light,
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          titleTextStyle: kAppBarLabelStyle,
          backgroundColor: kPrimaryColour,
          centerTitle: true,
        ),
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
        '/green': (context) => ResetScreen(),
      },
    );
  }
}
