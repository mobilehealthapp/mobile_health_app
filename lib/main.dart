import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:mobile_health_app/welcome_screen.dart';

late List<CameraDescription> cameras;
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   cameras = await availableCameras();
//   runApp(MyApp());
// }
void main() {
  runApp(MyApp());
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
        home: WelcomeScreen());
  }
}
