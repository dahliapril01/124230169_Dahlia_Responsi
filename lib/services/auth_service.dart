import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // Register user
  Future<bool> register(String username, String password) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('registered_username', username);
      await prefs.setString('registered_password', password);
      return true;
    } catch (e) {
      return false;
    }
  }

  // Login user
  Future<bool> login(String username, String password) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedUsername = prefs.getString('registered_username');
      final savedPassword = prefs.getString('registered_password');

      if (username == savedUsername && password == savedPassword) {
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('username', username);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  // Get current username
  Future<String?> getCurrentUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }

  // Logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    await prefs.remove('username');
  }

  // Check if user is registered
  Future<bool> isUserRegistered() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('registered_username');
    return username != null;
  }
}