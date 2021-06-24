import 'package:flutter/material.dart';
import 'package:mobile_health_app/drawers.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
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
          )),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HomePage is here'),
      ),
      drawer: Drawers(),
    );
  }
}
