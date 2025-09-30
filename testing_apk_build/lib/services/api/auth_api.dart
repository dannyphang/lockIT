// auth_api.dart (example)
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';

final dio = Dio();
final storage = FlutterSecureStorage();

class AuthApi {
  final String baseUrl;
  AuthApi(this.baseUrl);

  Future<String> login(String email, String password) async {
    final r = await http.post(
      Uri.parse('$baseUrl/user/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (r.statusCode == 200) {
      final data = jsonDecode(r.body) as Map<String, dynamic>;
      final token = data['data'] as String;
      await storage.write(key: 'jwt', value: token);
      Logger().i(token);
      return token;
    }
    throw Exception('Invalid credentials');
  }
}
