import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_state.dart';

class UserStore {
  static const _key = "user_session";

  static Future<void> save(UserSession user) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_key, jsonEncode(user.toJson()));
  }

  static Future<UserSession?> read() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);

    if (raw == null) return null;

    final json = jsonDecode(raw);
    return UserSession.fromJson(json);
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(_key);
  }
}
