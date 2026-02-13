import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';

/// Top-level function to handle background messages
/// Must be a top-level function, not a class method
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (kDebugMode) {
    print("🔔 Background Message: ${message.notification?.title}");
  }
}

/// Notification Service for Firebase Cloud Messaging
///
/// Handles all FCM operations:
/// - Requesting permissions
/// - Receiving foreground messages
/// - Handling background messages
/// - Getting device token
/// - Displaying local notifications
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  String? _deviceToken;
  final StreamController<RemoteMessage> _messageStreamController =
      StreamController<RemoteMessage>.broadcast();

  /// Stream of incoming messages
  Stream<RemoteMessage> get onMessage => _messageStreamController.stream;

  /// Get the current device token
  String? get deviceToken => _deviceToken;

  /// Initialize FCM and local notifications
  Future<void> initialize() async {
    // Skip initialization on web platform
    if (kIsWeb) {
      if (kDebugMode) {
        print('⚠️ FCM not supported on web, skipping initialization');
      }
      return;
    }

    try {
      // Request notification permissions
      final settings = await _requestPermission();

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        if (kDebugMode) {
          print('✅ User granted notification permission');
        }
      } else if (settings.authorizationStatus ==
          AuthorizationStatus.provisional) {
        if (kDebugMode) {
          print('⚠️ User granted provisional permission');
        }
      } else {
        if (kDebugMode) {
          print('❌ User declined or has not accepted permission');
        }
        return;
      }

      // Initialize local notifications
      await _initializeLocalNotifications();

      // Get and save device token
      _deviceToken = await _getDeviceToken();
      if (kDebugMode) {
        print('📱 FCM Device Token: $_deviceToken');
      }

      // Listen to token refresh
      _messaging.onTokenRefresh.listen((newToken) {
        _deviceToken = newToken;
        if (kDebugMode) {
          print('🔄 Token refreshed: $newToken');
        }
      });

      // Handle foreground messages
      _setupForegroundMessageHandler();

      // Handle background messages (when app is in background but not terminated)
      _setupBackgroundMessageHandler();

      // Handle notification tap when app was terminated
      _setupTerminatedMessageHandler();

      // Set background message handler (top-level function)
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

      if (kDebugMode) {
        print('✅ Notification Service initialized successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error initializing notifications: $e');
      }
    }
  }

  /// Request notification permissions
  Future<NotificationSettings> _requestPermission() async {
    return await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  /// Initialize local notifications plugin
  Future<void> _initializeLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Create Android notification channel
    const channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
      enableVibration: true,
      playSound: true,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  /// Get FCM device token
  Future<String?> _getDeviceToken() async {
    try {
      return await _messaging.getToken();
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error getting device token: $e');
      }
      return null;
    }
  }

  /// Handle foreground messages
  void _setupForegroundMessageHandler() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('🔔 Foreground message received');
        print('Title: ${message.notification?.title}');
        print('Body: ${message.notification?.body}');
        print('Data: ${message.data}');
      }

      // Add to stream for UI updates
      _messageStreamController.add(message);

      // Show local notification
      _showLocalNotification(message);
    });
  }

  /// Handle background messages (app in background, not terminated)
  void _setupBackgroundMessageHandler() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('🔔 App opened from background notification');
        print('Title: ${message.notification?.title}');
        print('Data: ${message.data}');
      }

      // Add to stream for UI updates
      _messageStreamController.add(message);
    });
  }

  /// Handle message when app was terminated
  Future<void> _setupTerminatedMessageHandler() async {
    RemoteMessage? initialMessage = await FirebaseMessaging.instance
        .getInitialMessage();

    if (initialMessage != null) {
      if (kDebugMode) {
        print('🔔 App opened from terminated state');
        print('Title: ${initialMessage.notification?.title}');
        print('Data: ${initialMessage.data}');
      }

      // Add to stream for UI updates
      _messageStreamController.add(initialMessage);
    }
  }

  /// Show local notification for foreground messages
  Future<void> _showLocalNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;

    if (notification != null) {
      await _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notifications',
            channelDescription:
                'This channel is used for important notifications.',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
            playSound: true,
            enableVibration: true,
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: message.data.toString(),
      );
    }
  }

  /// Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    if (kDebugMode) {
      print('🔔 Notification tapped: ${response.payload}');
    }
  }

  /// Subscribe to a topic
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _messaging.subscribeToTopic(topic);
      if (kDebugMode) {
        print('✅ Subscribed to topic: $topic');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error subscribing to topic: $e');
      }
    }
  }

  /// Unsubscribe from a topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _messaging.unsubscribeFromTopic(topic);
      if (kDebugMode) {
        print('✅ Unsubscribed from topic: $topic');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error unsubscribing from topic: $e');
      }
    }
  }

  /// Delete device token
  Future<void> deleteToken() async {
    try {
      await _messaging.deleteToken();
      _deviceToken = null;
      if (kDebugMode) {
        print('✅ Device token deleted');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error deleting token: $e');
      }
    }
  }

  /// Dispose resources
  void dispose() {
    _messageStreamController.close();
  }
}
