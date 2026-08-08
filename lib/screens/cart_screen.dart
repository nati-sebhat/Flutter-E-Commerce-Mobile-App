import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: cart.items.isEmpty
          ? const Center(child: Text('Your cart is empty.'))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: cart.items.length,
              itemBuilder: (context, index) {
                final item = cart.items[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: Image.network(
                      item.product.image,
                      width: 50,
                      errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported),
                    ),
                    title: Text(item.product.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                    subtitle: Text('\$${item.product.price.toStringAsFixed(2)}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: () => cart.decreaseQuantity(item.product.id),
                        ),
                        Text('${item.quantity}'),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          onPressed: () => cart.increaseQuantity(item.product.id),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: cart.items.isEmpty
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total: \$${cart.totalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Checkout not implemented (out of scope)')),
                        );
                      },
                      child: const Text('Checkout'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}