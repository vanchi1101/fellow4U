import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://127.0.0.1:8080';
    }

    if (Platform.isAndroid) {
      return 'http://10.0.2.2:8080';
    }

    return 'http://127.0.0.1:8080';
  }

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) {
    return _request(
      'POST',
      '/api/auth/login',
      body: <String, dynamic>{'email': email, 'password': password},
    );
  }

  static Future<Map<String, dynamic>> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String role,
    required String country,
  }) {
    return _request(
      'POST',
      '/api/auth/register',
      body: <String, dynamic>{
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'password': password,
        'role': role,
        'country': country,
      },
    );
  }

  static Future<Map<String, dynamic>> logout() {
    return _request('POST', '/api/auth/logout');
  }

  static Future<Map<String, dynamic>> getExplore() {
    return _request('GET', '/api/explore');
  }

  static Future<Map<String, dynamic>> getMyTrip(int userId) {
    return _request('GET', '/api/my-trip?userId=$userId');
  }

  static Future<List<dynamic>> getChats(int userId) async {
    final response = await _request('GET', '/api/chat?userId=$userId');
    return List<dynamic>.from(response['chatUsers'] as List? ?? const []);
  }

  static Future<List<dynamic>> getNotifications(int userId) async {
    final response = await _request('GET', '/api/notifications?userId=$userId');
    return List<dynamic>.from(response['notifications'] as List? ?? const []);
  }

  static Future<Map<String, dynamic>> getProfile(int userId) async {
    final response = await _request('GET', '/api/profile?userId=$userId');
    return Map<String, dynamic>.from(
      response['profile'] as Map? ?? <String, dynamic>{},
    );
  }

  static Future<List<dynamic>> getUsers() async {
    final response = await _request('GET', '/api/users');
    return List<dynamic>.from(response['users'] as List? ?? const []);
  }

  static Future<Map<String, dynamic>> updateProfile({
    required int userId,
    required String firstName,
    required String lastName,
  }) async {
    final response = await _request(
      'PUT',
      '/api/profile',
      body: <String, dynamic>{
        'userId': userId,
        'firstName': firstName,
        'lastName': lastName,
      },
    );
    return Map<String, dynamic>.from(
      response['profile'] as Map? ?? <String, dynamic>{},
    );
  }

  static Future<Map<String, dynamic>> _request(
    String method,
    String path, {
    Map<String, dynamic>? body,
  }) async {
    final uri = Uri.parse('$baseUrl$path');
    late http.Response response;

    switch (method.toUpperCase()) {
      case 'POST':
        response = await http.post(
          uri,
          headers: _headers,
          body: jsonEncode(body ?? <String, dynamic>{}),
        );
        break;
      case 'PUT':
        response = await http.put(
          uri,
          headers: _headers,
          body: jsonEncode(body ?? <String, dynamic>{}),
        );
        break;
      default:
        response = await http.get(uri, headers: _headers);
    }

    final decoded = jsonDecode(response.body);
    final payload = _normalizeJson(
      decoded is Map<String, dynamic>
          ? decoded
          : <String, dynamic>{'data': decoded},
    );

    if (response.statusCode >= 400) {
      throw ApiException(
        payload['message'] as String? ?? 'Request failed',
        response.statusCode,
      );
    }

    return payload;
  }

  static const Map<String, String> _headers = <String, String>{
    'Content-Type': 'application/json',
  };

  static dynamic _normalizeJson(dynamic value) {
    if (value is Map) {
      final mapped = value.map(
        (key, item) => MapEntry('$key', _normalizeJson(item)),
      );

      if (mapped.length == 1) {
        final singleKey = mapped.keys.first;
        if (singleKey.startsWith('JSON_')) {
          return mapped.values.first;
        }
      }

      return mapped;
    }

    if (value is List) {
      return value.map(_normalizeJson).toList();
    }

    if (value is String) {
      final trimmed = value.trim();
      if ((trimmed.startsWith('{') && trimmed.endsWith('}')) ||
          (trimmed.startsWith('[') && trimmed.endsWith(']'))) {
        try {
          return _normalizeJson(jsonDecode(trimmed));
        } catch (_) {
          return value;
        }
      }
    }

    return value;
  }
}

class ApiException implements Exception {
  ApiException(this.message, this.statusCode);

  final String message;
  final int statusCode;

  @override
  String toString() => 'ApiException($statusCode): $message';
}
