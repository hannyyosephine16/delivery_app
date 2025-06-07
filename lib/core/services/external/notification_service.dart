// lib/core/services/external/notification_service.dart - Fixed for compatibility

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';  // Temporarily commented
import 'package:get/get.dart' as getx;
import 'package:del_pick/core/services/local/storage_service.dart';
import 'package:del_pick/core/constants/storage_constants.dart';

class NotificationService extends getx.GetxService {
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;  // Temporarily commented
  final StorageService _storageService = getx.Get.find<StorageService>();

  String? _fcmToken;
  String? get fcmToken => _fcmToken;

  @override
  Future<void> onInit() async {
    super.onInit();
    await _initializeLocalNotifications();
    // await _initializeFirebaseMessaging();  // Temporarily commented
  }

  Future<void> _initializeLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
  }

  // Temporarily commented Firebase methods
  /*
  Future<void> _initializeFirebaseMessaging() async {
    // Request permission for iOS
    if (Platform.isIOS) {
      await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );
    }

    // Get FCM token
    _fcmToken = await _firebaseMessaging.getToken();

    // Listen for token refresh
    _firebaseMessaging.onTokenRefresh.listen((token) {
      _fcmToken = token;
    });

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Handle background messages
    FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);
  }
  */

  Future<bool> requestPermission() async {
    if (Platform.isAndroid) {
      final androidPlugin =
          _localNotifications.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      if (androidPlugin != null) {
        final bool? granted =
            await androidPlugin.requestNotificationsPermission();
        return granted ?? false;
      }
      return true;
    } else if (Platform.isIOS) {
      final iosPlugin =
          _localNotifications.resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>();
      final granted = await iosPlugin?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      return granted ?? false;
    }
    return true;
  }

  Future<void> showLocalNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
    String? channelId,
    String? channelName,
    Priority priority = Priority.defaultPriority,
    Importance importance = Importance.defaultImportance,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      channelId ?? 'default_channel',
      channelName ?? 'Default Notifications',
      importance: importance,
      priority: priority,
      showWhen: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      id,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  Future<void> showOrderNotification({
    required String orderId,
    required String title,
    required String body,
  }) async {
    await showLocalNotification(
      id: orderId.hashCode,
      title: title,
      body: body,
      payload: 'order:$orderId',
      channelId: 'order_channel',
      channelName: 'Order Notifications',
      importance: Importance.high,
      priority: Priority.high,
    );
  }

  Future<void> showDeliveryNotification({
    required String orderId,
    required String title,
    required String body,
  }) async {
    await showLocalNotification(
      id: 'delivery_$orderId'.hashCode,
      title: title,
      body: body,
      payload: 'delivery:$orderId',
      channelId: 'delivery_channel',
      channelName: 'Delivery Notifications',
      importance: Importance.high,
      priority: Priority.high,
    );
  }

  void _onNotificationTapped(NotificationResponse response) {
    final payload = response.payload;
    if (payload != null) {
      _handleNotificationPayload(payload);
    }
  }

  void _handleNotificationPayload(String payload) {
    if (payload.startsWith('order:')) {
      final orderId = payload.split(':')[1];
      getx.Get.toNamed('/order_detail', arguments: {'orderId': orderId});
    } else if (payload.startsWith('delivery:')) {
      final orderId = payload.split(':')[1];
      getx.Get.toNamed('/order_tracking', arguments: {'orderId': orderId});
    }
  }

  Future<void> cancelNotification(int id) async {
    await _localNotifications.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await _localNotifications.cancelAll();
  }

  // Settings management
  bool get notificationsEnabled {
    return _storageService.readBoolWithDefault(
      StorageConstants.notificationsEnabled,
      true,
    );
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    await _storageService.writeBool(
      StorageConstants.notificationsEnabled,
      enabled,
    );
  }
}
