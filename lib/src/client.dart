import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'models.dart';
import 'rbac.dart';
import 'secure_storage.dart';

class SerafortClient {
  final SerafortConfig config;
  final SecureStorage storage;
  final http.Client httpClient;

  final ValueNotifier<UserContext?> currentUser = ValueNotifier<UserContext?>(null);

  SerafortClient({
    required this.config,
    SecureStorage? storage,
    http.Client? httpClient,
  })  : storage = storage ?? InMemorySecureStorage(),
        httpClient = httpClient ?? http.Client();

  Future<UserContext> validateToken(String token) async {
    final url = Uri.parse('${config.endpoint.replaceAll(RegExp(r'/+$'), '')}/api/v1/auth/me');
    try {
      final response = await httpClient.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode != 200) {
        throw SerafortException('Validation failed with status ${response.statusCode}: ${response.body}');
      }

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final user = UserContext.fromJson(json);
      currentUser.value = user;
      return user;
    } catch (e) {
      if (e is SerafortException) rethrow;
      throw SerafortException('Network error during token validation', e);
    }
  }

  Future<void> setTokens(AuthTokens tokens) async {
    await storage.write(key: '${config.keyPrefix}_access_token', value: tokens.accessToken);
    if (tokens.refreshToken != null) {
      await storage.write(key: '${config.keyPrefix}_refresh_token', value: tokens.refreshToken!);
    }
    if (tokens.idToken != null) {
      await storage.write(key: '${config.keyPrefix}_id_token', value: tokens.idToken!);
    }
  }

  Future<String?> getAccessToken() async {
    return storage.read(key: '${config.keyPrefix}_access_token');
  }

  Future<void> logout() async {
    await storage.deleteAll();
    currentUser.value = null;
  }

  bool hasPermission(String permission) {
    final user = currentUser.value;
    if (user == null) return false;
    return RBAC.hasPermission(user, permission);
  }

  bool hasRole(String role) {
    final user = currentUser.value;
    if (user == null) return false;
    return RBAC.hasRole(user, role);
  }
}
