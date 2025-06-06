import 'package:permission_handler/permission_handler.dart';
import 'package:get/get.dart' as getx;

class PermissionService extends getx.GetxService {
  // Location permissions
  Future<bool> requestLocationPermission() async {
    final status = await Permission.location.request();
    return status.isGranted;
  }

  Future<bool> checkLocationPermission() async {
    final status = await Permission.location.status;
    return status.isGranted;
  }

  Future<bool> requestLocationAlwaysPermission() async {
    final status = await Permission.locationAlways.request();
    return status.isGranted;
  }

  // Camera permissions
  Future<bool> requestCameraPermission() async {
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  Future<bool> checkCameraPermission() async {
    final status = await Permission.camera.status;
    return status.isGranted;
  }

  // Storage permissions
  Future<bool> requestStoragePermission() async {
    final status = await Permission.storage.request();
    return status.isGranted;
  }

  Future<bool> checkStoragePermission() async {
    final status = await Permission.storage.status;
    return status.isGranted;
  }

  // Photos permissions (for iOS 14+)
  Future<bool> requestPhotosPermission() async {
    final status = await Permission.photos.request();
    return status.isGranted;
  }

  Future<bool> checkPhotosPermission() async {
    final status = await Permission.photos.status;
    return status.isGranted;
  }

  // Notification permissions
  Future<bool> requestNotificationPermission() async {
    final status = await Permission.notification.request();
    return status.isGranted;
  }

  Future<bool> checkNotificationPermission() async {
    final status = await Permission.notification.status;
    return status.isGranted;
  }

  // Microphone permissions (for voice messages if needed)
  Future<bool> requestMicrophonePermission() async {
    final status = await Permission.microphone.request();
    return status.isGranted;
  }

  Future<bool> checkMicrophonePermission() async {
    final status = await Permission.microphone.status;
    return status.isGranted;
  }

  // Phone permissions (for calling customers/drivers)
  Future<bool> requestPhonePermission() async {
    final status = await Permission.phone.request();
    return status.isGranted;
  }

  Future<bool> checkPhonePermission() async {
    final status = await Permission.phone.status;
    return status.isGranted;
  }

  // Contacts permissions (if needed for contact integration)
  Future<bool> requestContactsPermission() async {
    final status = await Permission.contacts.request();
    return status.isGranted;
  }

  Future<bool> checkContactsPermission() async {
    final status = await Permission.contacts.status;
    return status.isGranted;
  }

  // Check if permission is permanently denied
  Future<bool> isPermissionPermanentlyDenied(Permission permission) async {
    final status = await permission.status;
    return status.isPermanentlyDenied;
  }

  // Open app settings
  Future<bool> openAppSettings() async {
    return await openAppSettings();
  }

  // Request multiple permissions at once
  Future<Map<Permission, PermissionStatus>> requestMultiplePermissions(
    List<Permission> permissions,
  ) async {
    return await permissions.request();
  }

  // Check multiple permissions at once
  Future<Map<Permission, PermissionStatus>> checkMultiplePermissions(
    List<Permission> permissions,
  ) async {
    final Map<Permission, PermissionStatus> results = {};
    for (final permission in permissions) {
      results[permission] = await permission.status;
    }
    return results;
  }

  // Essential permissions for the app
  Future<bool> requestEssentialPermissions() async {
    final permissions = [Permission.location, Permission.notification];

    final results = await requestMultiplePermissions(permissions);

    // Check if all essential permissions are granted
    return results.values.every((status) => status.isGranted);
  }

  // Driver-specific permissions
  Future<bool> requestDriverPermissions() async {
    final permissions = [
      Permission.location,
      Permission.locationAlways,
      Permission.notification,
      Permission.phone,
    ];

    final results = await requestMultiplePermissions(permissions);

    // At minimum, location and notification should be granted
    return results[Permission.location]?.isGranted == true &&
        results[Permission.notification]?.isGranted == true;
  }

  // Store-specific permissions
  Future<bool> requestStorePermissions() async {
    final permissions = [
      Permission.camera,
      Permission.storage,
      Permission.notification,
    ];

    final results = await requestMultiplePermissions(permissions);

    // At minimum, notification should be granted
    return results[Permission.notification]?.isGranted == true;
  }

  // Customer-specific permissions
  Future<bool> requestCustomerPermissions() async {
    final permissions = [Permission.location, Permission.notification];

    final results = await requestMultiplePermissions(permissions);

    // Both permissions should be granted for best experience
    return results.values.every((status) => status.isGranted);
  }

  // Show permission rationale dialog
  Future<bool> shouldShowRequestPermissionRationale(
    Permission permission,
  ) async {
    final status = await permission.status;
    return status.isDenied && !status.isPermanentlyDenied;
  }

  // Get permission status message
  String getPermissionStatusMessage(PermissionStatus status) {
    switch (status) {
      case PermissionStatus.granted:
        return 'Permission granted';
      case PermissionStatus.denied:
        return 'Permission denied';
      case PermissionStatus.restricted:
        return 'Permission restricted';
      // case PermissionStatus.limitedPermission:
      //   return 'Limited permission granted';
      case PermissionStatus.permanentlyDenied:
        return 'Permission permanently denied. Please enable in settings.';
      default:
        return 'Unknown permission status';
    }
  }

  // Get user-friendly permission name
  String getPermissionName(Permission permission) {
    switch (permission) {
      case Permission.location:
        return 'Location';
      case Permission.locationAlways:
        return 'Background Location';
      case Permission.camera:
        return 'Camera';
      case Permission.storage:
        return 'Storage';
      case Permission.photos:
        return 'Photos';
      case Permission.notification:
        return 'Notifications';
      case Permission.microphone:
        return 'Microphone';
      case Permission.phone:
        return 'Phone';
      case Permission.contacts:
        return 'Contacts';
      default:
        return 'Unknown';
    }
  }
}
