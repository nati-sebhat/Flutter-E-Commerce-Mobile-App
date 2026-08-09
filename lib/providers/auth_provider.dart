import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';
import '../models/users.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();

  String? token;
  User? currentUser;
  bool isLoading = false;
  String? errorMessage;


  bool get isLoggedIn => token != null;

  Future<void> tryAuthLogin() async{
    final savedToken = await _storageService.getToken();
    final savedUserId = await _storageService.getUserId();
    if(savedToken != null && savedUserId != null){
      token = savedToken;
      try{
        currentUser = await _apiService.getUser(savedUserId);
      }catch(_){

      }
      notifyListeners();
    }
  }

  Future<bool> login(String username, String password) async{
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try{
      final resultToken = await _apiService.login(username, password);
      token = resultToken;

      const demoUserId = 3;
      currentUser = await _apiService.getUser(demoUserId);
      await _storageService.saveSession(resultToken, demoUserId);


      isLoading = false;
      notifyListeners();
      return true;
    }catch(e){
         errorMessage = 'Login failed. Check your username and password.';
         isLoading = false;
         notifyListeners();
         return false;
    }

  }

  Future<void> logout() async{
    token=null;
    currentUser=null;
    await _storageService.clearSession();
    notifyListeners();
  }
}