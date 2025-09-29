// lib/core/network/user_api.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class UserApi {
  final String baseUrl;
  UserApi(this.baseUrl);

  Future<int> fetchUserPoints(String token) async {
    final r = await http.get(
      Uri.parse('$baseUrl/points'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (r.statusCode == 200) {
      final data = jsonDecode(r.body) as Map<String, dynamic>;
      return (data['points'] as num).toInt();
    }
    throw Exception('Failed to load points');
  }

  Future<Map<String, dynamic>> fetchUserById(String token, String id) async {
    final r = await http.get(
      Uri.parse('$baseUrl/user/$id'),
      headers: {'Authorization': 'Bearer $token'},
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
      headers: {'Authorization': 'Bearer $token'},
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
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
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
