import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/services.dart';
import 'package:mobile_health_app/Constants.dart';
import 'package:mobile_health_app/settings_pages/delete_data_or_account.dart';
import 'package:mobile_health_app/settings_pages/my_doctor_profile.dart';
import 'package:mobile_health_app/welcome_authentication_pages/splashscreen.dart';
import 'package:mobile_health_app/welcome_authentication_pages/welcome_screen.dart';
import 'package:mobile_health_app/Analysis/health_analysis.dart';

import 'Camera/camera_input.dart';
import 'Camera/data_input_page.dart';
import 'package:mobile_health_app/Physician side/physHome.dart';
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

import 'package:mobile_health_app/Home page/HomePage.dart';
import 'package:mobile_health_app/Analysis/health_analysis_form.dart';
import 'Physician side/physHome.dart';
import 'welcome_authentication_pages/loginpage.dart';
import 'welcome_authentication_pages/passwordreset.dart';
import 'welcome_authentication_pages/signup.dart';
import 'welcome_authentication_pages/verify.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

final GlobalKey<NavigatorState> navigator = new GlobalKey<NavigatorState>();

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.high,
);
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

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

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('companyicon2');

  /// Note: permissions aren't requested here just to demonstrate that can be
  /// done later
  final IOSInitializationSettings initializationSettingsIOS =
      IOSInitializationSettings(
    requestAlertPermission: false,
    requestBadgePermission: false,
    requestSoundPermission: false,
  );
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String? payload) async {
    debugPrint('payload: $payload');
    navigator.currentState!.pushNamed('/' + '$payload');
  });

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

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
        '/healthAnalysisForm': (context) => HealthAnalysisForm(),
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
        '/resetpass': (context) => ResetScreen(),
      },
      navigatorKey: navigator,
    );
  }
}
