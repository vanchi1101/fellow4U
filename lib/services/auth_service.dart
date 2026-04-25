import 'package:sign_up_in/services/api_service.dart';
import 'package:sign_up_in/services/session_service.dart';

class AuthService {
  static Future<Map<String, dynamic>> signIn(
    String email,
    String password,
  ) async {
    final response = await ApiService.login(email: email, password: password);
    final user = Map<String, dynamic>.from(
      response['user'] as Map? ?? <String, dynamic>{},
    );
    await SessionService.saveUser(user);
    return user;
  }

  static Future<Map<String, dynamic>> signUp(
    String firstName,
    String lastName,
    String email,
    String password,
    String role,
    String country,
  ) async {
    final response = await ApiService.register(
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
      role: role,
      country: country,
    );
    final user = Map<String, dynamic>.from(
      response['user'] as Map? ?? <String, dynamic>{},
    );
    await SessionService.saveUser(user);
    return user;
  }

  static Future<void> signOut() async {
    try {
      await ApiService.logout();
    } finally {
      await SessionService.clear();
    }
  }
}
