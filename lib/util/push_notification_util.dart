import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notification_test/util/logger.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class PushNotificationUtil {
  PushNotificationUtil._();

  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static init() async {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('mipmap/ic_launcher');
    DarwinInitializationSettings initializationSettingsIOS =
        const DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      // onDidReceiveBackgroundNotificationResponse: (notification) async {
      //   logger.i('onDidReceiveBackgroundNotificationResponse: $notification');
      // },
    );

    Future<void> _listenerWithTerminated() async {
      FlutterLocalNotificationsPlugin _localNotification =
          FlutterLocalNotificationsPlugin();

      NotificationAppLaunchDetails? details =
          await _localNotification.getNotificationAppLaunchDetails();
      if (details != null) {
        if (details.didNotificationLaunchApp) {
          logger.i('notificationResponse: ${details.notificationResponse}');
        }
      }
    }
  }

  static Future<bool> requestNotificationPermission() async {
    final bool? iosResult;
    final bool? androidResult;

    if (Platform.isIOS) {
      iosResult = (await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          ));
      logger.i('ios push Notification Result: $iosResult');
      return iosResult ?? false;
    } else {
      androidResult = await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
      logger.i('android push Notification Result: $androidResult');
      return androidResult ?? false;
    }
  }

  static tz.TZDateTime _timeZoneSetting({
    required int hour,
    required int minute,
  }) {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Seoul'));
    tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    return scheduledDate;
  }

  static Future<void> selectedTimePushAlarm({
    required int hour,
    required int minute,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'Alarm 1',
      '앱 사용 푸시',
      channelDescription: 'channel description',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: DarwinNotificationDetails(
        badgeNumber: 0,
      ),
    );

    try {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        1,
        '노티 테스트 타이틀',
        '노티 내용',
        _timeZoneSetting(
          hour: hour,
          minute: minute,
        ),
        notificationDetails,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
      logger.i('Notification Scheduled Successfully at $hour:$minute');
    } catch (e) {
      logger.e(e);
    }
  }

  static Future<void> cancelAllNotification() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  static Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }
}
