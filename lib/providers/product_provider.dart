import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';

class ProductProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Product> _allProducts = [];
  List<String> categories = [];
  String? selectedCategory;
  String searchQuery = '';

  bool isLoading = false;
  String? errorMessage;

  Future<void> loadProducts() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      _allProducts = await _apiService.getProducts();
      categories = await _apiService.getCategories();
      isLoading = false;
      notifyListeners();
    } catch (e) {
      errorMessage = 'Could not load products. Check your connection and try again.';
      isLoading = false;
      notifyListeners();
    }
  }


  List<Product> get products {
  var result = _allProducts;
  if (selectedCategory != null) {
    result = result.where((p) => p.category == selectedCategory).toList();
  }
  if (searchQuery.isNotEmpty) {
    result = result
        .where((p) => p.title.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
  }
  return result;
}

void setCategory(String? category) {
  selectedCategory = category;
  notifyListeners();
}

void setSearchQuery(String query) {
  searchQuery = query;
  notifyListeners();
}
}