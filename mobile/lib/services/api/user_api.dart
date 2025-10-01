// lib/core/network/user_api.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../models/models.dart';

class UserApi {
  final String baseUrl;
  UserApi(this.baseUrl);

  Future<PointTransaction> fetchUserPoints(String token) async {
    final r = await http.get(
      Uri.parse('$baseUrl/points'),
      headers: {'Authorization': token},
    );
    if (r.statusCode == 200) {
      final data = jsonDecode(r.body) as Map<String, dynamic>;
      return PointTransaction.fromJson(data['data'] as Map<String, dynamic>);
    }
    throw Exception('Failed to load points');
  }

  Future<Map<String, dynamic>> fetchUserById(String token, String id) async {
    final r = await http.get(
      Uri.parse('$baseUrl/user/$id'),
      headers: {'Authorization': token},
    );
    if (r.statusCode == 200) {
      return jsonDecode(r.body) as Map<String, dynamic>;
    }
    throw Exception('Failed to load user');
  }

  // Optional: current user endpoint if your backend supports it
  Future<Map<String, dynamic>> fetchMe(String token) async {
    final r = await http.get(
      Uri.parse('$baseUrl/user/me'),
      headers: {'Authorization': token},
    );
    if (r.statusCode == 200) {
      return jsonDecode(r.body) as Map<String, dynamic>;
    }
    throw Exception('Failed to load current user');
  }

  // Optional: update profile
  Future<Map<String, dynamic>> updateMe(
    String token, {
    String? displayName,
    String? email,
    String? avatarUrl,
  }) async {
    final r = await http.put(
      Uri.parse('$baseUrl/user/me'),
      headers: {'Authorization': token, 'Content-Type': 'application/json'},
      body: jsonEncode({
        if (displayName != null) 'displayName': displayName,
        if (email != null) 'email': email,
        if (avatarUrl != null) 'avatarUrl': avatarUrl,
      }),
    );
    if (r.statusCode == 200) {
      return jsonDecode(r.body) as Map<String, dynamic>;
    }
    throw Exception('Failed to update user');
  }
}

class PointTransactionApi {
  final String baseUrl;
  PointTransactionApi(this.baseUrl);

  Future<List<PointTransaction>> getAllTransactions(String userUid) async {
    final r = await http.get(
      Uri.parse('$baseUrl/user/userPoints/$userUid'),
      headers: {'Content-Type': 'application/json'},
    );

    if (r.statusCode == 200) {
      final res = jsonDecode(r.body);

      final list = (res['data'] as List<dynamic>);
      return list
          .map((e) => PointTransaction.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    throw Exception('Failed to load transactions: ${r.body}');
  }
}
