import 'package:get/get.dart';
import 'package:delivery_app/core/services/external/connectivity_service.dart';

class ConnectivityController extends GetxController {
  final ConnectivityService _connectivityService =
      Get.find<ConnectivityService>();

  bool get isConnected => _connectivityService.isConnected;
}
