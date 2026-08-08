import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import '../models/users.dart';

class ApiService {
  static const String baseUrl = 'https://fakestoreapi.com';

  Future<List<Product>> getProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/products'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<List<String>> getCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/products/categories'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => item.toString()).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<User> getUser(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/users/$userId'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return User.fromJson(data);
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<String> login(String username, String password) async {
  final response = await http.post(
    Uri.parse('$baseUrl/auth/login'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'username': username, 'password': password}),
  );

  print('LOGIN STATUS CODE: ${response.statusCode}');
  print('LOGIN RESPONSE BODY: ${response.body}');

  if (response.statusCode == 200 || response.statusCode == 201) {
    final data = jsonDecode(response.body);
    return data['token'];
  } else {
    throw Exception('Login failed');
  }
}
}