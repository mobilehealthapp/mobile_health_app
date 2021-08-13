import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mobile_health_app/Authentication/authentication_button.dart';
import 'package:mobile_health_app/main.dart';
import '../main.dart';
import 'package:mobile_health_app/Constants.dart';
import 'dart:io';

// final GlobalKey<NavigatorState> _navigator = new GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.blue[300],
      ),
      home: WelcomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    if (Platform.isIOS) {
      FirebaseMessaging.instance.requestPermission();
    }
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        navigator.currentState!.pushNamed('/' + message.data['view']);
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                icon: 'companyicon2',
                playSound: true,
              ),
            ),
            payload: message.data["view"]);
      }
    });
    FirebaseMessaging.instance.subscribeToTopic('test');

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('A new onMessageOpenedApp event was published!');
      navigator.currentState!.pushNamed('/' + message.data['view']);
    });
    getToken();
  }

  void getToken() {
    FirebaseMessaging.instance.getToken.call().then((token) {
      debugPrint('Token: $token');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSecondaryColour,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 27.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  SizedBox(
                    height: 125,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Hero(
                        tag: 'logo',
                        child: Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('images/logo.png'),
                                fit: BoxFit.fill),
                          ),
                        ),
                      ),
                      Text(
                        'AppName',
                        style: TextStyle(
                            fontSize: 35, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Text(
                    'Providing families with faster and safer treatment',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  AuthenticationButton(
                      label: 'Log in',
                      onPressed: () {
                        Navigator.of(context).pushNamed('/login');
                      },
                      colour: Colors.blueGrey),
                  SizedBox(
                    height: 20.0,
                  ),
                  AuthenticationButton(
                      label: 'Sign up',
                      onPressed: () {
                        Navigator.of(context).pushNamed('/signup');
                      },
                      colour: kPrimaryColour)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
