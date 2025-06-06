import 'package:get/get.dart';

class NotificationController extends GetxController {
  final RxInt _unreadCount = 0.obs;
  int get unreadCount => _unreadCount.value;

  void updateUnreadCount(int count) {
    _unreadCount.value = count;
  }

  void clearNotifications() {
    _unreadCount.value = 0;
  }
}
