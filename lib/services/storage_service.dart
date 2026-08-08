import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_item.dart';

class StorageService{
  static const _tokenKey = 'auth_token';
  static const _userIdKey = 'user_id';
  static const _cartKey = 'cart_items';

  Future<void> saveSession(String token, int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setInt(_userIdKey, userId);
  }

  Future<String?> getToke() async {
    final prefs =  await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_userIdKey);
  }

  Future <void> clearSession() async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userIdKey);
  }

  Future<void> saveCart(List<CartItem> items) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = items.map((item) => item.toJson()).toList();
    await prefs.setString(_cartKey, jsonEncode(jsonList));
  }

  Future<List<CartItem>> loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_cartKey);

    if(raw == null) return [];
    final List<dynamic> decoded = jsonDecode(raw);
    return decoded.map((json) => CartItem.fromJson(json)).toList();
  }
}