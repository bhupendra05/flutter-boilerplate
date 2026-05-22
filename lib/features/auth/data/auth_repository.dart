import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../domain/user_model.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final client = ref.watch(apiClientProvider);
  return AuthRepository(client: client);
});

class AuthRepository {
  final ApiClient client;

  AuthRepository({required this.client});

  Future<User?> getCurrentUser() async {
    try {
      final response = await client.get<Map<String, dynamic>>('/auth/me');
      return User.fromJson(response.data!);
    } catch (_) {
      return null;
    }
  }

  Future<User> login({required String email, required String password}) async {
    final response = await client.post('/auth/login', data: {
      'email': email,
      'password': password,
    });

    final data = response.data as Map<String, dynamic>;
    await client.saveTokens(
      access: data['access_token'] as String,
      refresh: data['refresh_token'] as String?,
    );

    return User.fromJson(data['user'] as Map<String, dynamic>);
  }

  Future<User> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await client.post('/auth/register', data: {
      'name': name,
      'email': email,
      'password': password,
    });

    final data = response.data as Map<String, dynamic>;
    await client.saveTokens(
      access: data['access_token'] as String,
      refresh: data['refresh_token'] as String?,
    );

    return User.fromJson(data['user'] as Map<String, dynamic>);
  }

  Future<void> logout() async {
    try {
      await client.post('/auth/logout');
    } finally {
      await client.clearTokens();
    }
  }
}
