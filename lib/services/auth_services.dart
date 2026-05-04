import 'package:shared_preferences/shared_preferences.dart';

class AuthServices {
  static const String _isLoggedInKey = "isLoggedIn";
  static const String _userNameKey = "userName";
  static const String _userProfessionKey = "userProfession";

  // SAVE USER (instead of signup/login)
  Future<void> saveUser({
    required String name,
    required String profession,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(_isLoggedInKey, true);
    await prefs.setString(_userNameKey, name);
    await prefs.setString(_userProfessionKey, profession);
  }

  // CHECK LOGIN
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  // GET NAME
  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userNameKey);
  }

  // GET PROFESSION
  static Future<String?> getUserProfession() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userProfessionKey);
  }

  // LOGOUT / RESET
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
