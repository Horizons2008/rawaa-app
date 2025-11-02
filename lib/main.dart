import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:rawaa_app/firebase_options.dart';
import 'package:rawaa_app/services/notification/local_notification.dart';
import 'package:rawaa_app/services/notification/push_notification.dart';
import 'package:rawaa_app/styles/constants.dart';
import 'package:rawaa_app/styles/my_theme.dart';
import 'package:rawaa_app/translations/messages.dart';
import 'package:rawaa_app/controller/language_controller.dart';
import 'package:rawaa_app/views/splash/screen_splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseMessaging.instance.getToken().then((onValue) {
    log("token: $onValue");
  });

  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await Hive.initFlutter();
  await Hive.openBox('userBox');
  await Hive.openBox(Constants.boxConfig);
  Future.wait([
    PushNotificationServices.init(),
    LocalNotificationService.init(),
    LocalNotificationService().createNotificationChannel(),
  ]);
  debugPrint("bbbbbbbbbbbbbbbbbbbbbbbbbb ${Constants.baseUrl}");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize language controller
    Get.put(LanguageController());

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'app_name'.tr,
      theme: MyTheme.customTheme(),

      // Internationalization
      translations: Messages(),
      locale: Get.find<LanguageController>().currentLocale.value,
      fallbackLocale: Locale('fr', ''),

      home: ScreenSplash(),
    );
  }
}
