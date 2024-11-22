import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// firebase_messaging_service.dart

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

// Background message handler (top-level function)
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Background message received: ${message.data}");

  // Show a local notification when the app is in the background or terminated
  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'your_channel_id',
    'your_channel_name',
    channelDescription: 'your_channel_description',
    importance: Importance.max,
    priority: Priority.high,
  );

  const NotificationDetails platformDetails = NotificationDetails(android: androidDetails);

  await flutterLocalNotificationsPlugin.show(
    0, // Notification ID
    'Background Notification', // Title
    message.notification?.title ?? 'No Title', // Body
    platformDetails,
    payload: message.data.toString(),
  );
}


class FirebaseMessagingService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // Method to initialize notifications and background message handler
  Future<void> init() async {
    // Initialize local notifications
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Background message handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  // Method to handle messages when the app is in the foreground
  Future<void> onMessageReceived(RemoteMessage message) async {
    print('Received message: ${message.notification?.title}, ${message.notification?.body}');
    await _showNotification(message);
  }

  // Background message handler (when the app is in the background or terminated)
  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print('Handling a background message: ${message.notification?.title}, ${message.notification?.body}');
    // You can call the method to show notification here as well
  }

  // Method to display the notification
  Future<void> _showNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidNotificationDetails);

    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      message.notification?.title, // Title
      message.notification?.body, // Body
      platformChannelSpecifics, // Notification details
      payload: 'item x', // Optional data
    );
  }
}
