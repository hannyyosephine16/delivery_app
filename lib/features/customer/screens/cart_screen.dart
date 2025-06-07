import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:del_pick/features/customer/controllers/cart_controller.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CartController controller = Get.find<CartController>();

    return Scaffold(
      appBar: AppBar(title: const Text('My Cart')),
      body: Obx(() {
        if (controller.isEmpty) {
          return const Center(
            child: Text('Your cart is empty'),
          );
        }

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: controller.cartItems.length,
                itemBuilder: (context, index) {
                  final item = controller.cartItems[index];
                  return ListTile(
                    title: Text(item.name),
                    subtitle: Text('Qty: ${item.quantity}'),
                    trailing: Text(item.formattedTotalPrice),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total:'),
                      Text(controller.formattedTotal),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: controller.proceedToCheckout,
                    child: const Text('Proceed to Checkout'),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
