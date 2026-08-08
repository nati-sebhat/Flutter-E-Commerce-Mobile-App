import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../models/product.dart';
import '../services/storage_service.dart';

class CartProvider extends ChangeNotifier {
  final StorageService _storageService = StorageService();
  List<CartItem> items = [];

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice => items.fold(0, (sum, item) => sum + item.totalPrice);

  Future<void> loadCart() async {
    items = await _storageService.loadCart();
    notifyListeners();
  }

  void addToCart(Product product) {
    final existingIndex = items.indexWhere((item) => item.product.id == product.id);
    if (existingIndex >= 0) {
      items[existingIndex].quantity++;
    } else {
      items.add(CartItem(product: product));
    }
    _persist();
    notifyListeners();
  }

  void increaseQuantity(int productId) {
    final index = items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      items[index].quantity++;
      _persist();
      notifyListeners();
    }
  }

  void decreaseQuantity(int productId) {
    final index = items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      if (items[index].quantity > 1) {
        items[index].quantity--;
      } else {
        items.removeAt(index);
      }
      _persist();
      notifyListeners();
    }
  }

  void removeItem(int productId) {
    items.removeWhere((item) => item.product.id == productId);
    _persist();
    notifyListeners();
  }

  void clearCart() {
    items = [];
    _persist();
    notifyListeners();
  }

  void _persist() {
    _storageService.saveCart(items);
  }
}