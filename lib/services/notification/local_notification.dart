import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  //************************************************* */
  // Create a notification channel
  Future<void> createNotificationChannel() async {
    AndroidNotificationChannel regularChannel = AndroidNotificationChannel(
      'regular', // Channel ID
      'Regular Notifications', // Channel Name
      description:
          'This channel plays a custom regular sound for notifications.', // Channel Description
      importance: Importance.defaultImportance, // Importance level
      sound: RawResourceAndroidNotificationSound('regular'), // Custom sound
    );
    AndroidNotificationChannel dangerChannel = AndroidNotificationChannel(
      'danger', // Channel ID
      'Danger Notifications', // Channel Name
      description:
          'This channel plays a custom danger sound for critical notifications.', // Channel Description
      importance: Importance.high, // Importance level
      sound: RawResourceAndroidNotificationSound('dangerlong'), // Custom sound
    );
    AndroidNotificationChannel mediumChannel = AndroidNotificationChannel(
      'medium', // Channel ID
      'Medium Notifications', // Channel Name
      description:
          'This channel plays a custom medium sound for notifications.', // Channel Description
      importance: Importance.defaultImportance, // Importance level
      sound: RawResourceAndroidNotificationSound('medium'), // Custom sound
    );
    AndroidNotificationChannel happyChannel = AndroidNotificationChannel(
      'happy', // Channel ID
      'Happy Notifications', // Channel Name
      description:
          'This channel plays a custom medium sound for notifications.', // Channel Description
      importance: Importance.defaultImportance, // Importance level
      sound: RawResourceAndroidNotificationSound('happy'), // Custom sound
    );
    AndroidNotificationChannel lowChannel = AndroidNotificationChannel(
      'low', // Channel ID
      'Low Notifications', // Channel Name
      description:
          'This channel plays a custom low sound for notifications.', // Channel Description
      importance: Importance.defaultImportance, // Importance level
      sound: RawResourceAndroidNotificationSound('low'), // Custom sound
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(dangerChannel);
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(regularChannel);
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(mediumChannel);
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(happyChannel);
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(lowChannel);

    /*  AndroidNotificationChannel channel2 = AndroidNotificationChannel(
      'happy1.wav', // Channel ID
      'Custom Sound Notifications', // Channel Name
      description:
          'This channel plays a custom sound for notifications.', // Channel Description
      importance: Importance.high, // Importance level
      sound: RawResourceAndroidNotificationSound('happy1'), // Custom sound
    );*/
  }

  //************************************************* */

  static StreamController<NotificationResponse> streamController =
      StreamController();
  static onTap(NotificationResponse notificationResponse) {
    // log(notificationResponse.id!.toString());
    // log(notificationResponse.payload!.toString());
    streamController.add(notificationResponse);
    // Navigator.push(context, route);
  }

  static Future init() async {
    InitializationSettings settings = const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );
    flutterLocalNotificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: onTap,
      onDidReceiveBackgroundNotificationResponse: onTap,
    );
  }

  //basic Notification
  static void showBasicNotification(RemoteMessage message) async {
    /* final http.Response image = await http
        .get(Uri.parse(message.notification?.android?.imageUrl ?? ''));
    BigPictureStyleInformation bigPictureStyleInformation =
        BigPictureStyleInformation(
      ByteArrayAndroidBitmap.fromBase64String(
        base64Encode(image.bodyBytes),
      ),
      largeIcon: ByteArrayAndroidBitmap.fromBase64String(
        base64Encode(image.bodyBytes),
      ),
    );*/
    // String sound = message.notification?.android?.sound ?? "danger1";
    // print("1112 $sound");
    print("1112 ${message.notification?.android?.channelId}");
    AndroidNotificationDetails android = AndroidNotificationDetails(
      message.notification?.android?.channelId ?? 'regular',
      'Regular Notifications',
    );
    NotificationDetails details = NotificationDetails(android: android);
    await flutterLocalNotificationsPlugin.show(
      0,
      (message.notification?.title ?? '') + 'bachir',
      (message.notification?.body ?? '') + 'bachir body',
      details,
    );
  }
}
