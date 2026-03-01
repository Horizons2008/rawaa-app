import 'dart:developer';

import 'package:rawaa_app/styles/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

import 'local_notification.dart';

class PushNotificationServices {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;

  static Future init() async {
    await messaging.requestPermission();
    String? token = await messaging.getToken();
    log(token ?? "token vide");
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      log('Token refreshed: $newToken');
      Constants.reposit.repUpdateFcmToken(newToken).then((value) {
        log("Token updated: $value");
      });
      // You might want to save this token to your backend or local storage if required
    });
    FirebaseMessaging.onBackgroundMessage(handlerBackground);
    handleForGround();
  }

  static void saveNotification(String? title, String? body) {}

  static Future<void> handlerBackground(RemoteMessage message) async {
    // Initialize Firebase only if not already initialized (background handler runs in separate isolate)
    try {
      await Firebase.initializeApp();
    } catch (e) {
      // Firebase already initialized, ignore the error
      if (e.toString().contains('duplicate-app')) {
        print('Firebase already initialized in background handler');
      } else {
        rethrow;
      }
    }
    print("BaCKGROUND NOTIFICATION 123................................");

    await Hive.initFlutter();
  }

  static handleForGround() {
    FirebaseMessaging.onMessage.listen((RemoteMessage onData) {
      LocalNotificationService.showBasicNotification(onData);
      saveNotification(
        onData.notification?.title ?? "",
        onData.notification?.body ?? "",
      );
    });
  }
}
