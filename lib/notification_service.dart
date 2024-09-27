import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:permission_handler/permission_handler.dart';
class NotificationService {
  static final NotificationService _notificationService = NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  Future<void> initializeNotifications() async {
    print("Initializing notifications...");

    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings();

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        print('Notification clicked with payload: ${response.payload}');
      },
    );

    // Check for notification permissions on Android 13+
    if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
      flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

      final bool? permissionGranted = await androidImplementation?.requestNotificationsPermission();
      if (permissionGranted != null && !permissionGranted) {
        print('Notification permission denied on Android');
        return;
      }
    }

    // Initialize time zones for scheduling notifications
    tz.initializeTimeZones();
    print("Time zones initialized and notifications are ready.");
  }

  Future<void> showInstantNotification() async {
    print("Showing instant notification...");

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'instant_channel',
      'Instant Notifications',
      channelDescription: 'This channel is for instant notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    try {
      await flutterLocalNotificationsPlugin.show(
        0,
        'Wash Clothes!',  // Updated title
        'Your dirty clothes are piling up now!',  // Updated description
        notificationDetails,
      );
      print("Instant notification shown.");
    } catch (e) {
      print("Error showing notification: $e");
    }
  }

  Future<void> cancelAllNotifications() async {
    print("Cancelling all notifications...");
    await flutterLocalNotificationsPlugin.cancelAll();
    print("All notifications cancelled.");
  }
}
