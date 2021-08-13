import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mobile_health_app/HomePage.dart';
import 'package:mobile_health_app/settings_pages/delete_data_or_account.dart';
import 'package:mobile_health_app/settings_pages/my_doctor_profile.dart';
import 'package:mobile_health_app/welcome_authentication_pages/splashscreen.dart';
import 'package:mobile_health_app/welcome_authentication_pages/welcome_screen.dart';
import 'package:mobile_health_app/health_analysis.dart';

import 'Camera/camera_input.dart';
import 'Camera/data_input_page.dart';
import 'health_analysis.dart';
import 'physHome.dart';
import 'settings_pages/add_a_doctor.dart';
import 'settings_pages/dr_profile.dart';
import 'settings_pages/dr_profileEdit.dart';
import 'settings_pages/dr_settings.dart';
import 'settings_pages/medical_disclaimer.dart';
import 'settings_pages/my_doctors.dart';
import 'settings_pages/privacy_policy.dart';
import 'settings_pages/profile_edit.dart';
import 'settings_pages/profile_tab.dart';
import 'settings_pages/settings.dart';
import 'settings_pages/terms_and_conditions.dart';
import 'welcome_authentication_pages/loginpage.dart';
import 'welcome_authentication_pages/passwordreset.dart';
import 'welcome_authentication_pages/signup.dart';
import 'welcome_authentication_pages/verify.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

AndroidNotificationChannel? channel;

FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

late List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
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
        primaryColor: Color(0xFF00BCD4),
        primaryColorDark: Color(0xFF0097A7),
        primaryColorLight: Color(0xFFB2EBF2),
        accentColor: Color(0xFF607D8B),
        textTheme: TextTheme().apply(
          bodyColor: Color(0xFF212121),
          displayColor: Color(0xFF757575),
        ),
      ),
      initialRoute:
          '/splash', //FirebaseAuth.instance.currentUser != null ? '/home' : '/',
      routes: {
        "/splash": (context) => SplashScreen(),
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
        '/myDoctorProfile': (context) => MyDoctorProfile(),
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
