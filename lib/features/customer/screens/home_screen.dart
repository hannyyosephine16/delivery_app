import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:del_pick/features/customer/controllers/home_controller.dart';
import 'package:del_pick/features/customer/widgets/store_card.dart';
import 'package:del_pick/features/customer/widgets/order_card.dart';
import 'package:del_pick/core/widgets/loading_widget.dart';
import 'package:del_pick/core/widgets/empty_state_widget.dart';
import 'package:del_pick/app/themes/app_colors.dart';
import 'package:del_pick/app/themes/app_text_styles.dart';
import 'package:del_pick/app/themes/app_dimensions.dart';

class CustomerHomeScreen extends StatelessWidget {
  const CustomerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(
        storeRepository: Get.find(),
        orderRepository: Get.find(),
        locationService: Get.find(),
      ),
      builder:
          (controller) => Scaffold(
            backgroundColor: AppColors.background,
            body: SafeArea(
              child: RefreshIndicator(
                onRefresh: controller.refreshData,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingLG,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: AppDimensions.spacingLG),

                      // Header Section
                      _buildHeader(controller),

                      const SizedBox(height: AppDimensions.spacingXL),

                      // Location Section
                      _buildLocationSection(controller),

                      const SizedBox(height: AppDimensions.spacingXL),

                      // Quick Actions
                      _buildQuickActions(controller),

                      const SizedBox(height: AppDimensions.spacingXL),

                      // Nearby Stores Section
                      _buildNearbyStoresSection(controller),

                      const SizedBox(height: AppDimensions.spacingXL),

                      // Recent Orders Section
                      _buildRecentOrdersSection(controller),

                      const SizedBox(height: AppDimensions.spacingXL),
                    ],
                  ),
                ),
              ),
            ),
          ),
    );
  }

  Widget _buildHeader(HomeController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() => Text(controller.greeting, style: AppTextStyles.h4)),
            const SizedBox(height: AppDimensions.spacingXS),
            Text(
              'What would you like to eat?',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        Row(
          children: [
            IconButton(
              onPressed: controller.navigateToCart,
              icon: const Icon(Icons.shopping_cart_outlined),
              style: IconButton.styleFrom(
                backgroundColor: AppColors.primaryLight.withOpacity(0.1),
                foregroundColor: AppColors.primary,
              ),
            ),
            const SizedBox(width: AppDimensions.spacingSM),
            IconButton(
              onPressed: controller.navigateToProfile,
              icon: const Icon(Icons.person_outline),
              style: IconButton.styleFrom(
                backgroundColor: AppColors.primaryLight.withOpacity(0.1),
                foregroundColor: AppColors.primary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLocationSection(HomeController controller) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingLG),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppDimensions.paddingSM),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
            ),
            child: const Icon(
              Icons.location_on,
              color: AppColors.primary,
              size: AppDimensions.iconMD,
            ),
          ),
          const SizedBox(width: AppDimensions.spacingMD),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Deliver to',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                Obx(
                  () => Text(
                    controller.currentAddress,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.keyboard_arrow_down,
            color: AppColors.textSecondary,
            size: AppDimensions.iconMD,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(HomeController controller) {
    return Row(
      children: [
        Expanded(
          child: _buildQuickActionCard(
            icon: Icons.restaurant,
            title: 'Browse Restaurants',
            subtitle: 'Find nearby food',
            color: AppColors.primary,
            onTap: controller.navigateToStores,
          ),
        ),
        const SizedBox(width: AppDimensions.spacingMD),
        Expanded(
          child: _buildQuickActionCard(
            icon: Icons.history,
            title: 'Order History',
            subtitle: 'Track your orders',
            color: AppColors.secondary,
            onTap: controller.navigateToOrders,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.paddingLG),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
          border: Border.all(color: color.withOpacity(0.2), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: AppDimensions.iconLG),
            const SizedBox(height: AppDimensions.spacingSM),
            Text(
              title,
              style: AppTextStyles.labelLarge.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              subtitle,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNearbyStoresSection(HomeController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Nearby Restaurants', style: AppTextStyles.h5),
            TextButton(
              onPressed: controller.navigateToStores,
              child: Text(
                'See All',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.spacingMD),
        Obx(() {
          if (controller.isLoading) {
            return const SizedBox(
              height: 150,
              child: Center(child: LoadingWidget()),
            );
          }

          if (!controller.hasStores) {
            return const EmptyStateWidget(
              message: 'No restaurants found nearby',
              icon: Icons.store_mall_directory_outlined,
            );
          }

          return SizedBox(
            height: 220,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: controller.nearbyStores.length,
              itemBuilder: (context, index) {
                final store = controller.nearbyStores[index];
                return Container(
                  width: 280,
                  margin: EdgeInsets.only(
                    right:
                        index < controller.nearbyStores.length - 1
                            ? AppDimensions.spacingMD
                            : 0,
                  ),
                  child: StoreCard(
                    store: store,
                    onTap: () => controller.navigateToStoreDetail(store.id),
                  ),
                );
              },
            ),
          );
        }),
      ],
    );
  }

  Widget _buildRecentOrdersSection(HomeController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Recent Orders', style: AppTextStyles.h5),
            TextButton(
              onPressed: controller.navigateToOrders,
              child: Text(
                'View All',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.spacingMD),
        Obx(() {
          if (controller.isLoading) {
            return const SizedBox(
              height: 100,
              child: Center(child: LoadingWidget()),
            );
          }

          if (!controller.hasOrders) {
            return const EmptyStateWidget(
              message: 'No recent orders',
              icon: Icons.receipt_long_outlined,
            );
          }

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.recentOrders.length,
            itemBuilder: (context, index) {
              final order = controller.recentOrders[index];
              return Container(
                margin: EdgeInsets.only(
                  bottom:
                      index < controller.recentOrders.length - 1
                          ? AppDimensions.spacingMD
                          : 0,
                ),
                child: OrderCard(
                  order: order,
                  onTap: () => controller.navigateToOrderDetail(order.id),
                ),
              );
            },
          );
        }),
      ],
    );
  }
}
