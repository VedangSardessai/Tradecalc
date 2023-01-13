import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_fcm/flutter_fcm.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class MyNotifications {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final AndroidInitializationSettings _androidInitializationSettings =
      const AndroidInitializationSettings('logo');

  static String? token;

  static initFCM() async {
    try {
      await FCM.initializeFCM(
          onNotificationPressed: (Map<String, dynamic> data) {
            print('onNotificationPressed : $data');
          },
          onTokenChanged: (String? token) {
            MyNotifications.token = token!;
            print('onTokenChanged : $token');
          },
          onNotificationReceived: (RemoteMessage message) {
            print('onNotificationReceived $message');
            throw ('hello');
          },
          icon: 'logo');
    } catch (e) {
      print('Error on line 29 : ${e}');
    }
  }

  void showTextNotification(String title, String body) async {
    // initializeFirebasePushNotification();

    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails(
      'channelId',
      'channelName',
      priority: Priority.high,
      importance: Importance.max,
    );

    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    await _flutterLocalNotificationsPlugin.show(
        0, title, body, notificationDetails);
  }
}
