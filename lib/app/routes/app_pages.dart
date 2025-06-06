// import 'package:get/get.dart';
// import 'package:delivery_app/features/shared/screens/splash_screen.dart';
// import 'package:delivery_app/features/shared/screens/onboarding_screen.dart';
// import 'package:delivery_app/features/shared/screens/main_navigation_screen.dart';
// import 'package:delivery_app/features/shared/screens/no_internet_screen.dart';
// import 'package:delivery_app/features/shared/screens/maintenance_screen.dart';
// import 'package:delivery_app/features/shared/screens/error_screen.dart';
//
// // Auth imports
// import 'package:delivery_app/features/auth/screens/login_screen.dart';
// import 'package:delivery_app/features/auth/screens/register_screen.dart';
// import 'package:delivery_app/features/auth/screens/forgot_password_screen.dart';
// import 'package:delivery_app/features/auth/screens/reset_password_screen.dart';
// import 'package:delivery_app/features/auth/screens/profile_screen.dart';
// import 'package:delivery_app/features/auth/screens/edit_profile_screen.dart';
//
// // Customer imports
// import 'package:delivery_app/features/customer/screens/home_screen.dart';
// import 'package:delivery_app/features/customer/screens/store_list_screen.dart';
// import 'package:delivery_app/features/customer/screens/store_detail_screen.dart';
// import 'package:delivery_app/features/customer/screens/menu_screen.dart';
// import 'package:delivery_app/features/customer/screens/menu_item_detail_screen.dart';
// import 'package:delivery_app/features/customer/screens/cart_screen.dart';
// import 'package:delivery_app/features/customer/screens/checkout_screen.dart';
// import 'package:delivery_app/features/customer/screens/order_history_screen.dart';
// import 'package:delivery_app/features/customer/screens/order_detail_screen.dart';
// import 'package:delivery_app/features/customer/screens/order_tracking_screen.dart';
// import 'package:delivery_app/features/customer/screens/review_screen.dart';
// import 'package:delivery_app/features/customer/screens/customer_profile_screen.dart';
//
// // Driver imports
// import 'package:delivery_app/features/driver/screens/driver_home_screen.dart';
// import 'package:delivery_app/features/driver/screens/driver_requests_screen.dart';
// import 'package:delivery_app/features/driver/screens/request_detail_screen.dart';
// import 'package:delivery_app/features/driver/screens/delivery_screen.dart';
// import 'package:delivery_app/features/driver/screens/navigation_screen.dart';
// import 'package:delivery_app/features/driver/screens/driver_orders_screen.dart';
// import 'package:delivery_app/features/driver/screens/driver_earnings_screen.dart';
// import 'package:delivery_app/features/driver/screens/driver_profile_screen.dart';
// import 'package:delivery_app/features/driver/screens/driver_settings_screen.dart';
//
// // Store imports
// import 'package:delivery_app/features/store/screens/store_dashboard_screen.dart';
// import 'package:delivery_app/features/store/screens/store_analytics_screen.dart';
// import 'package:delivery_app/features/store/screens/menu_management_screen.dart';
// import 'package:delivery_app/features/store/screens/add_menu_item_screen.dart';
// import 'package:delivery_app/features/store/screens/edit_menu_item_screen.dart';
// import 'package:delivery_app/features/store/screens/store_orders_screen.dart';
// import 'package:delivery_app/features/store/screens/order_detail_screen.dart';
// import 'package:delivery_app/features/store/screens/store_profile_screen.dart';
// import 'package:delivery_app/features/store/screens/store_settings_screen.dart';
//
// import 'app_routes.dart';
// import '../bindings/auth_binding.dart';
// import '../bindings/customer_binding.dart';
// import '../bindings/driver_binding.dart';
// import '../bindings/store_binding.dart';
//
// class AppPages {
//   AppPages._();
//
//   static const INITIAL = Routes.SPLASH;
//
//   static final routes = [
//     // Shared routes
//     GetPage(name: Routes.SPLASH, page: () => const SplashScreen()),
//     GetPage(name: Routes.ONBOARDING, page: () => const OnboardingScreen()),
//     GetPage(
//       name: Routes.MAIN_NAVIGATION,
//       page: () => const MainNavigationScreen(),
//     ),
//     GetPage(name: Routes.NO_INTERNET, page: () => const NoInternetScreen()),
//     GetPage(name: Routes.MAINTENANCE, page: () => const MaintenanceScreen()),
//     GetPage(name: Routes.ERROR, page: () => const ErrorScreen()),
//
//     // Auth routes
//     GetPage(
//       name: Routes.LOGIN,
//       page: () => const LoginScreen(),
//       binding: AuthBinding(),
//     ),
//     GetPage(
//       name: Routes.REGISTER,
//       page: () => const RegisterScreen(),
//       binding: AuthBinding(),
//     ),
//     GetPage(
//       name: Routes.FORGOT_PASSWORD,
//       page: () => const ForgotPasswordScreen(),
//       binding: AuthBinding(),
//     ),
//     GetPage(
//       name: Routes.RESET_PASSWORD,
//       page: () => const ResetPasswordScreen(),
//       binding: AuthBinding(),
//     ),
//     GetPage(
//       name: Routes.PROFILE,
//       page: () => const ProfileScreen(),
//       binding: AuthBinding(),
//     ),
//     GetPage(
//       name: Routes.EDIT_PROFILE,
//       page: () => const EditProfileScreen(),
//       binding: AuthBinding(),
//     ),
//
//     // Customer routes
//     GetPage(
//       name: Routes.CUSTOMER_HOME,
//       page: () => const CustomerHomeScreen(),
//       binding: CustomerBinding(),
//     ),
//     GetPage(
//       name: Routes.STORE_LIST,
//       page: () => const StoreListScreen(),
//       binding: CustomerBinding(),
//     ),
//     GetPage(
//       name: Routes.STORE_DETAIL,
//       page: () => const StoreDetailScreen(),
//       binding: CustomerBinding(),
//     ),
//     GetPage(
//       name: Routes.MENU,
//       page: () => const MenuScreen(),
//       binding: CustomerBinding(),
//     ),
//     GetPage(
//       name: Routes.MENU_ITEM_DETAIL,
//       page: () => const MenuItemDetailScreen(),
//       binding: CustomerBinding(),
//     ),
//     GetPage(
//       name: Routes.CART,
//       page: () => const CartScreen(),
//       binding: CustomerBinding(),
//     ),
//     GetPage(
//       name: Routes.CHECKOUT,
//       page: () => const CheckoutScreen(),
//       binding: CustomerBinding(),
//     ),
//     GetPage(
//       name: Routes.ORDER_HISTORY,
//       page: () => const OrderHistoryScreen(),
//       binding: CustomerBinding(),
//     ),
//     GetPage(
//       name: Routes.ORDER_DETAIL,
//       page: () => const CustomerOrderDetailScreen(),
//       binding: CustomerBinding(),
//     ),
//     GetPage(
//       name: Routes.ORDER_TRACKING,
//       page: () => const OrderTrackingScreen(),
//       binding: CustomerBinding(),
//     ),
//     GetPage(
//       name: Routes.REVIEW,
//       page: () => const ReviewScreen(),
//       binding: CustomerBinding(),
//     ),
//     GetPage(
//       name: Routes.CUSTOMER_PROFILE,
//       page: () => const CustomerProfileScreen(),
//       binding: CustomerBinding(),
//     ),
//
//     // Driver routes
//     GetPage(
//       name: Routes.DRIVER_HOME,
//       page: () => const DriverHomeScreen(),
//       binding: DriverBinding(),
//     ),
//     GetPage(
//       name: Routes.DRIVER_REQUESTS,
//       page: () => const DriverRequestsScreen(),
//       binding: DriverBinding(),
//     ),
//     GetPage(
//       name: Routes.REQUEST_DETAIL,
//       page: () => const RequestDetailScreen(),
//       binding: DriverBinding(),
//     ),
//     GetPage(
//       name: Routes.DELIVERY,
//       page: () => const DeliveryScreen(),
//       binding: DriverBinding(),
//     ),
//     GetPage(
//       name: Routes.NAVIGATION,
//       page: () => const NavigationScreen(),
//       binding: DriverBinding(),
//     ),
//     GetPage(
//       name: Routes.DRIVER_ORDERS,
//       page: () => const DriverOrdersScreen(),
//       binding: DriverBinding(),
//     ),
//     GetPage(
//       name: Routes.DRIVER_EARNINGS,
//       page: () => const DriverEarningsScreen(),
//       binding: DriverBinding(),
//     ),
//     GetPage(
//       name: Routes.DRIVER_PROFILE,
//       page: () => const DriverProfileScreen(),
//       binding: DriverBinding(),
//     ),
//     GetPage(
//       name: Routes.DRIVER_SETTINGS,
//       page: () => const DriverSettingsScreen(),
//       binding: DriverBinding(),
//     ),
//
//     // Store routes
//     GetPage(
//       name: Routes.STORE_DASHBOARD,
//       page: () => const StoreDashboardScreen(),
//       binding: StoreBinding(),
//     ),
//     GetPage(
//       name: Routes.STORE_ANALYTICS,
//       page: () => const StoreAnalyticsScreen(),
//       binding: StoreBinding(),
//     ),
//     GetPage(
//       name: Routes.MENU_MANAGEMENT,
//       page: () => const MenuManagementScreen(),
//       binding: StoreBinding(),
//     ),
//     GetPage(
//       name: Routes.ADD_MENU_ITEM,
//       page: () => const AddMenuItemScreen(),
//       binding: StoreBinding(),
//     ),
//     GetPage(
//       name: Routes.EDIT_MENU_ITEM,
//       page: () => const EditMenuItemScreen(),
//       binding: StoreBinding(),
//     ),
//     GetPage(
//       name: Routes.STORE_ORDERS,
//       page: () => const StoreOrdersScreen(),
//       binding: StoreBinding(),
//     ),
//     GetPage(
//       name: Routes.STORE_ORDER_DETAIL,
//       page: () => const StoreOrderDetailScreen(),
//       binding: StoreBinding(),
//     ),
//     GetPage(
//       name: Routes.STORE_PROFILE,
//       page: () => const StoreProfileScreen(),
//       binding: StoreBinding(),
//     ),
//     GetPage(
//       name: Routes.STORE_SETTINGS,
//       page: () => const StoreSettingsScreen(),
//       binding: StoreBinding(),
//     ),
//   ];
// }
import 'package:get/get.dart';
import 'package:delivery_app/features/shared/screens/splash_screen.dart';
import 'package:delivery_app/features/shared/screens/onboarding_screen.dart';
import 'package:delivery_app/features/shared/screens/main_navigation_screen.dart';
import 'package:delivery_app/features/shared/screens/no_internet_screen.dart';
import 'package:delivery_app/features/shared/screens/maintenance_screen.dart';
import 'package:delivery_app/features/shared/screens/error_screen.dart';

// Auth imports
import 'package:delivery_app/features/auth/screens/login_screen.dart';
import 'package:delivery_app/features/auth/screens/register_screen.dart';
import 'package:delivery_app/features/auth/screens/forgot_password_screen.dart';
import 'package:delivery_app/features/auth/screens/reset_password_screen.dart';
import 'package:delivery_app/features/auth/screens/profile_screen.dart';
import 'package:delivery_app/features/auth/screens/edit_profile_screen.dart';

// Customer imports
import 'package:delivery_app/features/customer/screens/home_screen.dart';
import 'package:delivery_app/features/customer/screens/store_list_screen.dart';
import 'package:delivery_app/features/customer/screens/store_detail_screen.dart';
import 'package:delivery_app/features/customer/screens/menu_screen.dart';
import 'package:delivery_app/features/customer/screens/menu_item_detail_screen.dart';
import 'package:delivery_app/features/customer/screens/cart_screen.dart';
import 'package:delivery_app/features/customer/screens/checkout_screen.dart';
import 'package:delivery_app/features/customer/screens/order_history_screen.dart';
import 'package:delivery_app/features/customer/screens/order_detail_screen.dart';
import 'package:delivery_app/features/customer/screens/order_tracking_screen.dart';
import 'package:delivery_app/features/customer/screens/review_screen.dart';
import 'package:delivery_app/features/customer/screens/customer_profile_screen.dart';

// Driver imports
import 'package:delivery_app/features/driver/screens/driver_home_screen.dart';
import 'package:delivery_app/features/driver/screens/driver_requests_screen.dart';
import 'package:delivery_app/features/driver/screens/request_detail_screen.dart';
import 'package:delivery_app/features/driver/screens/delivery_screen.dart';
import 'package:delivery_app/features/driver/screens/navigation_screen.dart';
import 'package:delivery_app/features/driver/screens/driver_orders_screen.dart';
import 'package:delivery_app/features/driver/screens/driver_earnings_screen.dart';
import 'package:delivery_app/features/driver/screens/driver_profile_screen.dart';
import 'package:delivery_app/features/driver/screens/driver_settings_screen.dart';

// Store imports
import 'package:delivery_app/features/store/screens/store_dashboard_screen.dart';
import 'package:delivery_app/features/store/screens/store_analytics_screen.dart';
import 'package:delivery_app/features/store/screens/menu_management_screen.dart';
import 'package:delivery_app/features/store/screens/add_menu_item_screen.dart';
import 'package:delivery_app/features/store/screens/edit_menu_item_screen.dart';
import 'package:delivery_app/features/store/screens/store_orders_screen.dart';
import 'package:delivery_app/features/store/screens/order_detail_screen.dart';
import 'package:delivery_app/features/store/screens/store_profile_screen.dart';
import 'package:delivery_app/features/store/screens/store_settings_screen.dart';

import 'app_routes.dart';
import '../bindings/auth_binding.dart';
import '../bindings/customer_binding.dart';
import '../bindings/driver_binding.dart';
import '../bindings/store_binding.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    // Shared routes
    GetPage(name: Routes.SPLASH, page: () => const SplashScreen()),
    GetPage(name: Routes.ONBOARDING, page: () => const OnboardingScreen()),
    GetPage(
      name: Routes.MAIN_NAVIGATION,
      page: () => const MainNavigationScreen(),
    ),
    GetPage(name: Routes.NO_INTERNET, page: () => const NoInternetScreen()),
    GetPage(name: Routes.MAINTENANCE, page: () => const MaintenanceScreen()),
    GetPage(name: Routes.ERROR, page: () => const ErrorScreen()),

    // Auth routes
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.REGISTER,
      page: () => const RegisterScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.FORGOT_PASSWORD,
      page: () => const ForgotPasswordScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.RESET_PASSWORD,
      page: () => const ResetPasswordScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.PROFILE,
      page: () => const ProfileScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.EDIT_PROFILE,
      page: () => const EditProfileScreen(),
      binding: AuthBinding(),
    ),

    // Customer routes
    GetPage(
      name: Routes.CUSTOMER_HOME,
      page: () => const CustomerHomeScreen(),
      binding: CustomerBinding(),
    ),
    GetPage(
      name: Routes.STORE_LIST,
      page: () => StoreListScreen(),
      binding: CustomerBinding(),
    ),
    GetPage(
      name: Routes.STORE_DETAIL,
      page: () => const StoreDetailScreen(),
      binding: CustomerBinding(),
    ),
  ];
}
