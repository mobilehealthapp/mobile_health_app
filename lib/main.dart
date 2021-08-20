// flutter packages imports
import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/services.dart';

// camera/data input imports
import 'Camera/camera_input.dart';
import 'Camera/data_input_page.dart';

// home page imports
import 'Physician side/physHome.dart';
import 'package:mobile_health_app/Home page/HomePage.dart';
import 'Constants.dart';

// settings imports
import 'Settings/add_a_doctor.dart';
import 'Settings/dr_profile.dart';
import 'Settings/dr_profileEdit.dart';
import 'Settings/dr_settings.dart';
import 'Settings/medical_disclaimer.dart';
import 'Settings/my_doctors.dart';
import 'Settings/privacy_policy.dart';
import 'Settings/profile_edit.dart';
import 'Settings/profile_tab.dart';
import 'Settings/settings.dart';
import 'Settings/terms_and_conditions.dart';
import 'Settings/delete_data_or_account.dart';
import 'Settings/my_doctor_profile.dart';

// analysis imports
import 'package:mobile_health_app/Analysis/health_analysis_form.dart';
import 'Analysis/health_analysis.dart';

// authentication imports
import 'Authentication/loginpage.dart';
import 'Authentication/passwordreset.dart';
import 'Authentication/signup.dart';
import 'Authentication/verify.dart';
import 'Authentication/splashscreen.dart';
import 'Authentication/welcome_screen.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

// Global key for our Navigation so that we can push a route w/o context
final GlobalKey<NavigatorState> navigator = new GlobalKey<NavigatorState>();

// You need to add this in your AndroidManifest.xml
// <meta-data
//  android:name="com.google.firebase.messaging.default_notification_channel_id"
//  android:value="high_importance_channel" />
//
// Also see the file in android/app/src/main/res/values/string.xml
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

  //This is our app icon
  //Must be placed in android/app/src/main/drawable
  // <meta-data
  // android:name="com.google.firebase.messaging.default_notification_icon"
  // android:resource="@drawable/companyicon2" />

  // Add the icon image, in this case, its companyicon2, to app/src/res/drawable
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

  //This will handle our click if the app is in Foreground
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String? payload) async {
    debugPrint('payload: $payload');
    //A route must always start with "/"
    //If it doesn't start with "/" we get an error
    navigator.currentState!.pushNamed('/' + '$payload');
  });

  /// Create an Android Notification Channel.
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
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
        /*
        named routes like these make it easier to navigate within the app and clean the code
        they mean files require less imports as they are all named here
         */
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
