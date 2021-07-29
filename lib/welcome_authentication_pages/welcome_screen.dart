import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mobile_health_app/authentication_button.dart';
import 'package:mobile_health_app/welcome_authentication_pages/loginpage.dart';
import '../main.dart';
import 'signup.dart';

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

    FirebaseMessaging.instance.getInitialMessage();
    // .then(
    //   (RemoteMessage? message) {
    //     if (message != null) {
    //       Navigator.pushNamed(context, 'green',
    //           arguments: MessageArguments(message, true));
    //     }
    //   },
    // );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final routeFromMessage = message.data['route'];
      print('A new onMessage event was published!');
      Navigator.of(context).pushNamed(routeFromMessage);

      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin!.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel!.id,
              channel!.name,
              channel!.description,
              //      one that already exists in example app.
              icon: 'launch_background',
            ),
          ),
          payload: message.data['route'],
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      final routeFromMessage = message.data['route'];
      print('A new onMessageOpenedApp event was published!');
      Navigator.of(context).pushNamed(routeFromMessage);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                                image: AssetImage(
                                    'images/logo-1-removebg-preview.png'),
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
                  // MaterialButton(
                  //   color: Colors.white,
                  //   height: 50.0,
                  //   minWidth: 300,
                  //   onPressed: () {
                  //     Navigator.push(context,
                  //         MaterialPageRoute(builder: (context) => LoginPage()));
                  //   },
                  //   shape: RoundedRectangleBorder(
                  //     // side: BorderSide(
                  //     //   color: Colors.black,
                  //     // ),
                  //     borderRadius: BorderRadius.circular(50.0),
                  //   ),
                  //   child: Text(
                  //     'Login',
                  //     style: TextStyle(
                  //       fontWeight: FontWeight.w500,
                  //       fontSize: 18.0,
                  //     ),
                  //   ),
                  // ),
                  AuthenticationButton('Log in', () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  }, Colors.blueGrey),
                  SizedBox(
                    height: 20.0,
                  ),

                  AuthenticationButton('Sign up', () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SignupPage()));
                  }, Colors.cyan)
                  // MaterialButton(
                  //   color: Colors.blue,
                  //   height: 50.0,
                  //   minWidth: 300.0,
                  //   onPressed: () {
                  //     Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //             builder: (context) => SignupPage()));
                  //   },
                  //   shape: RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.circular(50.0),
                  //   ),
                  //   child: Text(
                  //     'Signup',
                  //     style: TextStyle(
                  //         fontWeight: FontWeight.w500,
                  //         fontSize: 18.0,
                  //         color: Colors.white),
                  //   ),
                  // ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
