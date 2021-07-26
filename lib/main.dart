import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mobile_health_app/HomePage.dart';
import 'package:mobile_health_app/welcome_authentication_pages/welcome_screen.dart';

late List<CameraDescription> cameras;
const kPrimaryColour = Color(0xFF1B4DA8);
const kSecondaryColour = Color(0xFFDAE9F4);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
      home: FirebaseAuth.instance.currentUser != null
          ? HomePage()
          : WelcomeScreen(),
    ),
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
    );
  }
}
