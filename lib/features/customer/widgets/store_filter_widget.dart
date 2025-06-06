import 'package:flutter/material.dart';
import 'package:delivery_app/app/themes/app_text_styles.dart';

class StoreFilterWidget extends StatelessWidget {
  final VoidCallback onSortByDistance;
  final VoidCallback onSortByRating;

  const StoreFilterWidget({
    super.key,
    required this.onSortByDistance,
    required this.onSortByRating,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Sort by', style: AppTextStyles.h6),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.location_on),
            title: const Text('Distance'),
            onTap: () {
              onSortByDistance();
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.star),
            title: const Text('Rating'),
            onTap: () {
              onSortByRating();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
