import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart' as getx;
import 'package:delivery_app/core/services/local/storage_service.dart';
import 'package:delivery_app/core/constants/storage_constants.dart';

class NotificationService extends getx.GetxService {
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final StorageService _storageService = getx.Get.find<StorageService>();

  String? _fcmToken;
  String? get fcmToken => _fcmToken;

  @override
  Future<void> onInit() async {
    super.onInit();
    await _initializeLocalNotifications();
    await _initializeFirebaseMessaging();
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

  Future<bool> requestPermission() async {
    if (Platform.isAndroid) {
      final androidPlugin =
          _localNotifications.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      // For Android 13+, request notification permission
      if (androidPlugin != null) {
        final bool? granted =
            await androidPlugin.requestNotificationsPermission();
        return granted ?? false;
      }
      return true; // Assume granted for older Android versions
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

  Future<void> showDriverRequestNotification({
    required String requestId,
    required String title,
    required String body,
  }) async {
    await showLocalNotification(
      id: 'request_$requestId'.hashCode,
      title: title,
      body: body,
      payload: 'driver_request:$requestId',
      channelId: 'driver_request_channel',
      channelName: 'Driver Request Notifications',
      importance: Importance.max,
      priority: Priority.max,
    );
  }

  void _handleForegroundMessage(RemoteMessage message) {
    if (kDebugMode) {
      print('Foreground message: ${message.notification?.title}');
    }

    // Show local notification for foreground messages
    if (message.notification != null) {
      showLocalNotification(
        id: message.hashCode,
        title: message.notification!.title ?? '',
        body: message.notification!.body ?? '',
        payload: message.data.toString(),
      );
    }
  }

  void _handleBackgroundMessage(RemoteMessage message) {
    if (kDebugMode) {
      print('Background message: ${message.notification?.title}');
    }

    // Handle navigation based on message type
    final messageType = message.data['type'];
    final data = message.data;

    _navigateBasedOnNotification(messageType, data);
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
    } else if (payload.startsWith('driver_request:')) {
      final requestId = payload.split(':')[1];
      getx.Get.toNamed('/request_detail', arguments: {'requestId': requestId});
    }
  }

  void _navigateBasedOnNotification(String? type, Map<String, dynamic> data) {
    switch (type) {
      case 'order_update':
        final orderId = data['orderId'];
        if (orderId != null) {
          getx.Get.toNamed('/order_detail', arguments: {'orderId': orderId});
        }
        break;
      case 'delivery_update':
        final orderId = data['orderId'];
        if (orderId != null) {
          getx.Get.toNamed('/order_tracking', arguments: {'orderId': orderId});
        }
        break;
      case 'driver_request':
        final requestId = data['requestId'];
        if (requestId != null) {
          getx.Get.toNamed(
            '/request_detail',
            arguments: {'requestId': requestId},
          );
        }
        break;
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

  bool get orderNotificationsEnabled {
    return _storageService.readBoolWithDefault(
      StorageConstants.orderNotifications,
      true,
    );
  }

  Future<void> setOrderNotificationsEnabled(bool enabled) async {
    await _storageService.writeBool(
      StorageConstants.orderNotifications,
      enabled,
    );
  }

  bool get deliveryNotificationsEnabled {
    return _storageService.readBoolWithDefault(
      StorageConstants.deliveryNotifications,
      true,
    );
  }

  Future<void> setDeliveryNotificationsEnabled(bool enabled) async {
    await _storageService.writeBool(
      StorageConstants.deliveryNotifications,
      enabled,
    );
  }
}
