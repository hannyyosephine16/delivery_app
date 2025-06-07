import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:delivery_app/data/models/store/store_model.dart';
import 'package:delivery_app/app/themes/app_colors.dart';
import 'package:delivery_app/app/themes/app_text_styles.dart';
import 'package:delivery_app/core/constants/app_constants.dart';

class StoreCard extends StatelessWidget {
  final StoreModel store;
  final VoidCallback onTap;

  const StoreCard({super.key, required this.store, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Store image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: SizedBox(
                height: 150,
                width: double.infinity,
                child: store.imageUrl != null
                    ? CachedNetworkImage(
                        imageUrl: store.imageUrl!,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) => Image.asset(
                          AppConstants.defaultStoreImageUrl,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Image.asset(
                        AppConstants.defaultStoreImageUrl,
                        fit: BoxFit.cover,
                      ),
              ),
            ),

            // Store info
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Store name and status
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          store.name,
                          style: AppTextStyles.h6,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      _buildStatusBadge(),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Store address
                  Text(
                    store.address,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  // Rating and distance
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Rating
                      Row(
                        children: [
                          Icon(Icons.star, color: AppColors.rating, size: 18),
                          const SizedBox(width: 4),
                          Text(
                            store.displayRating,
                            style: AppTextStyles.bodyMedium,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '(${store.reviewCount ?? 0})',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),

                      // Distance
                      if (store.distance != null)
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: AppColors.primary,
                              size: 18,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              store.displayDistance,
                              style: AppTextStyles.bodyMedium,
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge() {
    // Fixed: Use isOpenNow() method instead of isOpen()
    final isOpen = store.isOpenNow();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isOpen
            ? AppColors.success.withOpacity(0.1)
            : AppColors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        isOpen ? 'Open' : 'Closed',
        style: AppTextStyles.labelSmall.copyWith(
          color: isOpen ? AppColors.success : AppColors.error,
        ),
      ),
    );
  }
}
