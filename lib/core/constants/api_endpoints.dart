class ApiEndpoints {
  // Base paths
  static const String auth = '/auth';
  static const String customers = '/customers';
  static const String drivers = '/drivers';
  static const String stores = '/stores';
  static const String menuItems = '/menu-items';
  static const String orders = '/orders';
  static const String driverRequests = '/driver-requests';
  static const String tracking = '/tracking';

  // Auth endpoints
  static const String login = '$auth/login';
  static const String register = '$auth/register';
  static const String logout = '$auth/logout';
  static const String profile = '$auth/profile';
  static const String updateProfile = '$auth/update-profile';
  static const String forgotPassword = '$auth/forgot-password';
  static const String resetPassword = '$auth/reset-password';

  // Store endpoints
  static const String getAllStores = stores;
  static String getStoreById(int id) => '$stores/$id';
  static const String createStore = stores;
  static String updateStore(int id) => '$stores/$id';
  static String deleteStore(int id) => '$stores/$id';
  static const String updateStoreProfile = '$stores/update';
  static String updateStoreStatus(int id) => '$stores/$id/status';

  // Menu item endpoints
  static const String getAllMenuItems = menuItems;
  static String getMenuItemsByStoreId(int storeId) =>
      '$menuItems/store/$storeId';
  static String getMenuItemById(int id) => '$menuItems/$id';
  static const String createMenuItem = menuItems;
  static String updateMenuItem(int id) => '$menuItems/$id';
  static String deleteMenuItem(int id) => '$menuItems/$id';

  // Order endpoints
  static const String createOrder = orders;
  static const String userOrders = '$orders/user';
  static const String storeOrders = '$orders/store';
  static String getOrderById(int id) => '$orders/$id';
  static String processOrder(int id) => '$orders/$id/process';
  static String cancelOrder(int id) => '$orders/$id/cancel';
  static const String createReview = '$orders/review';
  static const String updateOrderStatus = '$orders/status';

  // Driver endpoints
  static const String getAllDrivers = drivers;
  static String getDriverById(int id) => '$drivers/$id';
  static const String createDriver = drivers;
  static String updateDriver(int id) => '$drivers/$id';
  static String deleteDriver(int id) => '$drivers/$id';
  static const String updateDriverLocation = '$drivers/location';
  static String getDriverLocation(int driverId) =>
      '$drivers/$driverId/location';
  static const String updateDriverStatus = '$drivers/status';
  static const String updateDriverProfile = '$drivers/update';
  static const String driverOrders = '$drivers/orders';

  // Driver request endpoints
  static const String getDriverRequests = driverRequests;
  static String getDriverRequestById(int id) => '$driverRequests/$id';
  static String respondToDriverRequest(int id) => '$driverRequests/$id/respond';

  // Tracking endpoints
  static String getTrackingData(int orderId) => '$tracking/$orderId';
  static String startDelivery(int orderId) => '$tracking/$orderId/start';
  static String completeDelivery(int orderId) => '$tracking/$orderId/complete';

  // Review endpoints
  static const String reviews = '/reviews';
}
