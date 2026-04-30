import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  static const String _isLoggedInKey = "isLoggedIn";
  static const String _userNameKey = "userName";
  static const String _userEmailKey = "userEmail";

  // SIGN UP (Firebase + Save locally)
  Future<String?> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      await userCredential.user!.updateDisplayName(name);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_isLoggedInKey, true);
      await prefs.setString(_userNameKey, name);
      await prefs.setString(_userEmailKey, email);

      return "success";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // LOGIN
  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      final user = _auth.currentUser;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_isLoggedInKey, true);
      await prefs.setString(_userNameKey, user?.displayName ?? "");
      await prefs.setString(_userEmailKey, email);

      return "success";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userNameKey);
  }

  static Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userEmailKey);
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await FirebaseAuth.instance.signOut();
  }

  String getAuthErrorMessage(String error) {
    switch (error) {
      case "The email address is badly formatted.":
        return "Please enter a valid email address.";

      case "There is no user record corresponding to this identifier.":
        return "No account found. Please sign up first.";

      case "The password is invalid or the user does not have a password.":
        return "Incorrect password. Try again.";

      case "A network error (such as timeout) occurred.":
        return "No internet connection. Please try again.";

      case "The email address is already in use by another account.":
        return "This email is already registered. Try logging in.";

      default:
        return "Something went wrong. Please try again.";
    }
  }
}
