// lib/features/customer/screens/store_list_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:delivery_app/app/routes/app_routes.dart';
import 'package:delivery_app/core/widgets/loading_widget.dart';
import 'package:delivery_app/core/widgets/empty_state_widget.dart';
import 'package:delivery_app/core/widgets/error_widget.dart' as app_error;
import 'package:delivery_app/features/customer/controllers/store_controller.dart';
import 'package:delivery_app/features/customer/widgets/store_card.dart';
import 'package:delivery_app/features/customer/widgets/store_filter_widget.dart';
import 'package:delivery_app/features/customer/widgets/store_search_bar.dart';
import 'package:delivery_app/app/themes/app_colors.dart';

class StoreListScreen extends StatelessWidget {
  final StoreController controller = Get.find<StoreController>();

  StoreListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Restaurants'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearchDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterBottomSheet(context),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: controller.refreshStores,
        child: Obx(() {
          if (controller.isLoading) {
            return const LoadingWidget();
          }

          if (controller.hasError) {
            return app_error.ErrorWidget(
              message: controller.errorMessage,
              onRetry: controller.refreshStores,
            );
          }

          if (!controller.hasStores) {
            return const EmptyStateWidget(
              message: 'No restaurants found nearby',
              icon: Icons.store_mall_directory_outlined,
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.stores.length,
            itemBuilder: (context, index) {
              final store = controller.stores[index];
              return StoreCard(
                store: store,
                onTap: () => Get.toNamed(
                  Routes.STORE_DETAIL,
                  arguments: {'storeId': store.id},
                ),
              );
            },
          );
        }),
      ),
    );
  }

  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: StoreSearchBar(
          onSearch: controller.filterStores,
          onClear: controller.refreshStores,
        ),
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => StoreFilterWidget(
        onSortByDistance: controller.sortStoresByDistance,
        onSortByRating: controller.sortStoresByRating,
      ),
    );
  }
}
