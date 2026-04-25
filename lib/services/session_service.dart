import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  static const _userKey = 'current_user';

  static Future<void> saveUser(Map<String, dynamic> user) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_userKey, jsonEncode(user));
  }

  static Future<Map<String, dynamic>?> getUser() async {
    final preferences = await SharedPreferences.getInstance();
    final rawUser = preferences.getString(_userKey);
    if (rawUser == null || rawUser.isEmpty) {
      return null;
    }

    final decoded = jsonDecode(rawUser);
    if (decoded is Map<String, dynamic>) {
      return decoded;
    }
    return null;
  }

  static Future<int?> getUserId() async {
    final user = await getUser();
    final rawId = user?['id'];
    if (rawId is int) {
      return rawId;
    }
    return int.tryParse('$rawId');
  }

  static Future<bool> isLoggedIn() async => await getUserId() != null;

  static Future<void> clear() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(_userKey);
  }
}
