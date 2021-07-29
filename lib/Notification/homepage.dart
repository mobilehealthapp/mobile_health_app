import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mobile_health_app/main.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({required this.title});
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
              // TODO add a proper drawable resource to android, for now using
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
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Center(
            child: Text(
          "Finally got it to work on both foreground and background within assigned time intervals",
          style: TextStyle(fontSize: 34),
        )),
      ),
    );
  }

// getToken() async {
//   String? token = await FirebaseMessaging.instance.getToken();
//   print(token);
// }
}
