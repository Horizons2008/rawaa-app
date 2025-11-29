import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static StreamController<NotificationResponse> streamController =
      StreamController.broadcast();

  //************************************************* */
  // Create notification channels
  static Future<void> createNotificationChannels() async {
    final androidPlugin = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin == null) return;

    final channels = [
      AndroidNotificationChannel(
        'regular',
        'Regular Notifications',
        description: 'This channel plays a custom regular sound for notifications.',
        importance: Importance.defaultImportance,
        sound: RawResourceAndroidNotificationSound('regular'),
      ),
      AndroidNotificationChannel(
        'danger',
        'Danger Notifications',
        description: 'This channel plays a custom danger sound for critical notifications.',
        importance: Importance.high,
        sound: RawResourceAndroidNotificationSound('dangerlong'),
      ),
      AndroidNotificationChannel(
        'medium',
        'Medium Notifications',
        description: 'This channel plays a custom medium sound for notifications.',
        importance: Importance.defaultImportance,
        sound: RawResourceAndroidNotificationSound('medium'),
      ),
      AndroidNotificationChannel(
        'happy',
        'Happy Notifications',
        description: 'This channel plays a custom happy sound for notifications.',
        importance: Importance.defaultImportance,
        sound: RawResourceAndroidNotificationSound('happy'),
      ),
      AndroidNotificationChannel(
        'low',
        'Low Notifications',
        description: 'This channel plays a custom low sound for notifications.',
        importance: Importance.defaultImportance,
        sound: RawResourceAndroidNotificationSound('low'),
      ),
    ];

    for (var channel in channels) {
      await androidPlugin.createNotificationChannel(channel);
    }
  }

  //************************************************* */

  static void onTap(NotificationResponse notificationResponse) {
    streamController.add(notificationResponse);
  }

  // Initialize everything including Firebase messaging
  static Future<void> init() async {
    // Create notification channels first
    await createNotificationChannels();

    const InitializationSettings settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      ),
    );

    await flutterLocalNotificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: onTap,
      onDidReceiveBackgroundNotificationResponse: onTap,
    );

    // Set up Firebase messaging handlers
    await _setupFirebaseMessaging();
  }

  // Setup Firebase messaging handlers
  static Future<void> _setupFirebaseMessaging() async {
    final FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Request permission
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');

    // Set up foreground message handler
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Foreground message received: ${message.messageId}');
      _handleForegroundMessage(message);
    });

    // Set up when app is opened from background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('App opened from background via notification: ${message.messageId}');
      _handleBackgroundMessageTap(message);
    });

    // Get the token
    String? token = await messaging.getToken();
    print("FCM Token: $token");
  }

  // Handle foreground messages
  static void _handleForegroundMessage(RemoteMessage message) {
    print('Handling foreground message');
    showBasicNotification(message);
  }

  // Handle when user taps notification while app is in background
  static void _handleBackgroundMessageTap(RemoteMessage message) {
    print('Notification tapped while app was in background');
    // You can add navigation logic here
    streamController.add(NotificationResponse(
      payload: message.data['payload'] ?? message.data['route'] ?? '',
      id: int.tryParse(message.data['id'] ?? '0') ?? 0,
      actionId: message.data['actionId'],
      input: message.data['input'],
      notificationResponseType: NotificationResponseType.selectedNotification

    ));
  }

  // Background message handler - static method
  @pragma('vm:entry-point')
  static Future<void> handleBackgroundMessage(RemoteMessage message) async {
    print("Handling background message: ${message.messageId}");
    
    // Initialize notifications in background isolate
    await _initializeInBackground();
    
    // Show the notification
    await showBasicNotification(message);
  }

  // Initialize notifications in background isolate
  static Future<void> _initializeInBackground() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings();
    
    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(settings);
  }

  // Basic Notification
  static Future<void> showBasicNotification(RemoteMessage message) async {
    try {
      AndroidNotificationDetails android = AndroidNotificationDetails(
        message.notification?.android?.channelId ?? 
        message.data['channel'] ?? 'regular',
        'Regular Notifications',
        channelDescription: 'Regular notifications channel',
        importance: Importance.high,
        priority: Priority.high,
      );

      NotificationDetails details = NotificationDetails(android: android);
      
      await flutterLocalNotificationsPlugin.show(
        DateTime.now().millisecondsSinceEpoch.remainder(100000),
        message.notification?.title ?? message.data['title'] ?? 'Notification',
        message.notification?.body ?? message.data['body'] ?? '',
        details,
        payload: message.data['payload'] ?? message.data['route'] ?? '',
      );
      
      print('Notification shown successfully');
    } catch (e) {
      print('Error showing notification: $e');
    }
  }
}