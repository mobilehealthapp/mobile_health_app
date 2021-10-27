import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

class NotificationApi {
  static final _notifications = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String?>();

  static Future _notificationDetails() async {
    return NotificationDetails(
        android: AndroidNotificationDetails(
          'channel id',
          'channel name',
          'channel description',
          importance: Importance.max,
        ),
        iOS: IOSNotificationDetails());
  }

  static Future init({bool initScheduled = false}) async {
    final android = AndroidInitializationSettings("companyicon2");
    final iOS = IOSInitializationSettings();
    final settings = InitializationSettings(android: android, iOS: iOS);
    await _notifications.initialize(settings,
        onSelectNotification: (payload) async {
      onNotifications.add(payload);
    });
    if (initScheduled) {
      tz.initializeTimeZones();
      final locationName = await FlutterNativeTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(locationName));
    }
  }

  static Future showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async =>
      _notifications.show(
        id,
        title,
        body,
        await _notificationDetails(),
        payload: payload,
      );

  static void showScheduledNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async =>
      _notifications.zonedSchedule(
        id,
        title,
        body,
        _scheduleDaily(Time(4, 0,
            0)), //4pm UTC (12pm est) reminder... tz.local does not find local timezone on emulator
        //TODO: find a way to find user's timezone, location is not shared through the app
        await _notificationDetails(),
        payload: payload,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );

  static tz.TZDateTime _scheduleDaily(Time time) {
    print('Scheduling');
    final now = tz.TZDateTime.now(tz.local);
    final scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day,
        time.hour, time.minute, time.second);
    if (scheduledDate.isBefore(now)) {
      scheduledDate.add(Duration(
          days:
              1)); //show the notification the next day if the scheduled time is before current time
    }
    return scheduledDate;
  }
}
